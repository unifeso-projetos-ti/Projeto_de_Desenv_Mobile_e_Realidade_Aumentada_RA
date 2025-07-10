/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.ar.core.examples.kotlin.helloar

import android.opengl.GLES30
import android.opengl.Matrix
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.google.ar.core.Anchor
import com.google.ar.core.Camera
import com.google.ar.core.DepthPoint
import com.google.ar.core.Frame
import com.google.ar.core.InstantPlacementPoint
import com.google.ar.core.LightEstimate
import com.google.ar.core.Plane
import com.google.ar.core.Point
import com.google.ar.core.Session
import com.google.ar.core.Trackable
import com.google.ar.core.TrackingFailureReason
import com.google.ar.core.TrackingState
import com.google.ar.core.examples.java.common.helpers.DisplayRotationHelper
import com.google.ar.core.examples.java.common.helpers.TrackingStateHelper
import com.google.ar.core.examples.java.common.samplerender.Framebuffer
import com.google.ar.core.examples.java.common.samplerender.GLError
import com.google.ar.core.examples.java.common.samplerender.Mesh
import com.google.ar.core.examples.java.common.samplerender.SampleRender
import com.google.ar.core.examples.java.common.samplerender.Shader
import com.google.ar.core.examples.java.common.samplerender.Texture
import com.google.ar.core.examples.java.common.samplerender.VertexBuffer
import com.google.ar.core.examples.java.common.samplerender.arcore.BackgroundRenderer
import com.google.ar.core.examples.java.common.samplerender.arcore.PlaneRenderer
import com.google.ar.core.examples.java.common.samplerender.arcore.SpecularCubemapFilter
import com.google.ar.core.exceptions.CameraNotAvailableException
import com.google.ar.core.exceptions.NotYetAvailableException
import java.io.IOException
import java.nio.ByteBuffer

/** Renders the HelloAR application using our example Renderer. */
class HelloArRenderer(val activity: HelloArActivity) :
  SampleRender.Renderer, DefaultLifecycleObserver {
  companion object {
    val TAG = "HelloArRenderer"

    private val Z_NEAR = 0.1f
    private val Z_FAR = 100f

    // Assumed distance from the device camera to the surface on which user will try to place
    // objects.
    // This value affects the apparent scale of objects while the tracking method of the
    // Instant Placement point is SCREENSPACE_WITH_APPROXIMATE_DISTANCE.
    // Values in the [0.2, 2.0] meter range are a good choice for most AR experiences. Use lower
    // values for AR experiences where users are expected to place objects on surfaces close to the
    // camera. Use larger values for experiences where the user will likely be standing and trying
    // to
    // place an object on the ground or floor in front of them.
    val APPROXIMATE_DISTANCE_METERS = 2.0f

    val CUBEMAP_RESOLUTION = 16
    val CUBEMAP_NUMBER_OF_IMPORTANCE_SAMPLES = 32
  }

  lateinit var render: SampleRender
  lateinit var planeRenderer: PlaneRenderer
  lateinit var backgroundRenderer: BackgroundRenderer
  lateinit var virtualSceneFramebuffer: Framebuffer
  var hasSetTextureNames = false

  // Point Cloud
  lateinit var pointCloudVertexBuffer: VertexBuffer
  lateinit var pointCloudMesh: Mesh
  lateinit var pointCloudShader: Shader

  // Keep track of the last point cloud rendered to avoid updating the VBO if point cloud
  // was not changed.  Do this using the timestamp since we can't compare PointCloud objects.
  var lastPointCloudTimestamp: Long = 0

  // Text renderer instead of 3D model
  lateinit var textRenderer: TextRenderer

  private val wrappedAnchors = mutableListOf<WrappedAnchor>()
  private val anchorTexts = mutableMapOf<Anchor, String>()

  // Environmental HDR
  lateinit var dfgTexture: Texture
  lateinit var cubemapFilter: SpecularCubemapFilter

  // Temporary matrix allocated here to reduce number of allocations for each frame.
  val modelMatrix = FloatArray(16)
  val viewMatrix = FloatArray(16)
  val projectionMatrix = FloatArray(16)
  val modelViewMatrix = FloatArray(16) // view x model

  val modelViewProjectionMatrix = FloatArray(16) // projection x view x model

  val viewInverseMatrix = FloatArray(16)

  val session
    get() = activity.arCoreSessionHelper.session

  val displayRotationHelper = DisplayRotationHelper(activity)
  val trackingStateHelper = TrackingStateHelper(activity)

  override fun onResume(owner: LifecycleOwner) {
    displayRotationHelper.onResume()
    hasSetTextureNames = false
  }

  override fun onPause(owner: LifecycleOwner) {
    displayRotationHelper.onPause()
  }

  override fun onSurfaceCreated(render: SampleRender) {
    // Prepare the rendering objects.
    // This involves reading shaders and 3D model files, so may throw an IOException.
    try {
      planeRenderer = PlaneRenderer(render)
      backgroundRenderer = BackgroundRenderer(render)
      virtualSceneFramebuffer = Framebuffer(render, /*width=*/ 1, /*height=*/ 1)

      cubemapFilter =
        SpecularCubemapFilter(render, CUBEMAP_RESOLUTION, CUBEMAP_NUMBER_OF_IMPORTANCE_SAMPLES)
      // Load environmental lighting values lookup table
      dfgTexture =
        Texture(
          render,
          Texture.Target.TEXTURE_2D,
          Texture.WrapMode.CLAMP_TO_EDGE,
          /*useMipmaps=*/ false
        )
      // The dfg.raw file is a raw half-float texture with two channels.
      val dfgResolution = 64
      val dfgChannels = 2
      val halfFloatSize = 2

      val buffer: ByteBuffer =
        ByteBuffer.allocateDirect(dfgResolution * dfgResolution * dfgChannels * halfFloatSize)
      activity.assets.open("models/dfg.raw").use { it.read(buffer.array()) }

      // SampleRender abstraction leaks here.
      GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, dfgTexture.textureId)
      GLError.maybeThrowGLException("Failed to bind DFG texture", "glBindTexture")
      GLES30.glTexImage2D(
        GLES30.GL_TEXTURE_2D,
        /*level=*/ 0,
        GLES30.GL_RG16F,
        /*width=*/ dfgResolution,
        /*height=*/ dfgResolution,
        /*border=*/ 0,
        GLES30.GL_RG,
        GLES30.GL_HALF_FLOAT,
        buffer
      )
      GLError.maybeThrowGLException("Failed to populate DFG texture", "glTexImage2D")

      // Point cloud
      pointCloudShader =
        Shader.createFromAssets(
            render,
            "shaders/point_cloud.vert",
            "shaders/point_cloud.frag",
            /*defines=*/ null
          )
          .setVec4("u_Color", floatArrayOf(31.0f / 255.0f, 188.0f / 255.0f, 210.0f / 255.0f, 1.0f))
          .setFloat("u_PointSize", 5.0f)

      // four entries per vertex: X, Y, Z, confidence
      pointCloudVertexBuffer =
        VertexBuffer(render, /*numberOfEntriesPerVertex=*/ 4, /*entries=*/ null)
      val pointCloudVertexBuffers = arrayOf(pointCloudVertexBuffer)
      pointCloudMesh =
        Mesh(render, Mesh.PrimitiveMode.POINTS, /*indexBuffer=*/ null, pointCloudVertexBuffers)

      // Initialize text renderer
      Log.d(TAG, "Initializing text renderer...")
      textRenderer = TextRenderer(render)
      textRenderer.init()
    } catch (e: IOException) {
      Log.e(TAG, "Failed to read a required asset file", e)
      showError("Failed to read a required asset file: $e")
    } catch (e: Exception) {
      Log.e(TAG, "Unexpected error during surface creation", e)
      showError("Unexpected error: $e")
    }
  }

  override fun onSurfaceChanged(render: SampleRender, width: Int, height: Int) {
    displayRotationHelper.onSurfaceChanged(width, height)
    virtualSceneFramebuffer.resize(width, height)
  }

  override fun onDrawFrame(render: SampleRender) {
    try {
      val session = session ?: return

    // Texture names should only be set once on a GL thread unless they change. This is done during
    // onDrawFrame rather than onSurfaceCreated since the session is not guaranteed to have been
    // initialized during the execution of onSurfaceCreated.
    if (!hasSetTextureNames) {
      session.setCameraTextureNames(intArrayOf(backgroundRenderer.cameraColorTexture.textureId))
      hasSetTextureNames = true
    }

    // -- Update per-frame state

    // Notify ARCore session that the view size changed so that the perspective matrix and
    // the video background can be properly adjusted.
    displayRotationHelper.updateSessionIfNeeded(session)

    // Obtain the current frame from ARSession. When the configuration is set to
    // UpdateMode.BLOCKING (it is by default), this will throttle the rendering to the
    // camera framerate.
    val frame =
      try {
        session.update()
      } catch (e: CameraNotAvailableException) {
        Log.e(TAG, "Camera not available during onDrawFrame", e)
        showError("Camera not available. Try restarting the app.")
        return
      }

    val camera = frame.camera

    // Update BackgroundRenderer state to match the depth settings.
    try {
      backgroundRenderer.setUseDepthVisualization(
        render,
        activity.depthSettings.depthColorVisualizationEnabled()
      )
      backgroundRenderer.setUseOcclusion(render, activity.depthSettings.useDepthForOcclusion())
    } catch (e: IOException) {
      Log.e(TAG, "Failed to read a required asset file", e)
      showError("Failed to read a required asset file: $e")
      return
    }

    // BackgroundRenderer.updateDisplayGeometry must be called every frame to update the coordinates
    // used to draw the background camera image.
    backgroundRenderer.updateDisplayGeometry(frame)
    val shouldGetDepthImage =
      activity.depthSettings.useDepthForOcclusion() ||
        activity.depthSettings.depthColorVisualizationEnabled()
    if (camera.trackingState == TrackingState.TRACKING && shouldGetDepthImage) {
      try {
        val depthImage = frame.acquireDepthImage16Bits()
        backgroundRenderer.updateCameraDepthTexture(depthImage)
        depthImage.close()
      } catch (e: NotYetAvailableException) {
        // This normally means that depth data is not available yet. This is normal so we will not
        // spam the logcat with this.
      }
    }

    // Handle one tap per frame.
    handleTap(frame, camera)

    // Keep the screen unlocked while tracking, but allow it to lock when tracking stops.
    trackingStateHelper.updateKeepScreenOnFlag(camera.trackingState)

    // Show a message based on whether tracking has failed, if planes are detected, and if the user
    // has placed any objects.
    val message: String? =
      when {
        camera.trackingState == TrackingState.PAUSED &&
          camera.trackingFailureReason == TrackingFailureReason.NONE ->
          activity.getString(R.string.searching_planes)
        camera.trackingState == TrackingState.PAUSED ->
          TrackingStateHelper.getTrackingFailureReasonString(camera)
        session.hasTrackingPlane() && wrappedAnchors.isEmpty() ->
          activity.getString(R.string.waiting_taps)
        session.hasTrackingPlane() && wrappedAnchors.isNotEmpty() -> null
        else -> activity.getString(R.string.searching_planes)
      }
    if (message == null) {
      activity.view.snackbarHelper.hide(activity)
    } else {
      activity.view.snackbarHelper.showMessage(activity, message)
    }

    // -- Draw background
    if (frame.timestamp != 0L) {
      // Suppress rendering if the camera did not produce the first frame yet. This is to avoid
      // drawing possible leftover data from previous sessions if the texture is reused.
      backgroundRenderer.drawBackground(render)
    }

    // If not tracking, don't draw 3D objects.
    if (camera.trackingState == TrackingState.PAUSED) {
      return
    }

    // -- Draw non-occluded virtual objects (planes, point cloud)

    // Get projection matrix.
    camera.getProjectionMatrix(projectionMatrix, 0, Z_NEAR, Z_FAR)

    // Get camera matrix and draw.
    camera.getViewMatrix(viewMatrix, 0)
    frame.acquirePointCloud().use { pointCloud ->
      if (pointCloud.timestamp > lastPointCloudTimestamp) {
        pointCloudVertexBuffer.set(pointCloud.points)
        lastPointCloudTimestamp = pointCloud.timestamp
      }
      Matrix.multiplyMM(modelViewProjectionMatrix, 0, projectionMatrix, 0, viewMatrix, 0)
      pointCloudShader.setMat4("u_ModelViewProjection", modelViewProjectionMatrix)
      render.draw(pointCloudMesh, pointCloudShader)
    }

    // Visualize planes.
    planeRenderer.drawPlanes(
      render,
      session.getAllTrackables<Plane>(Plane::class.java),
      camera.displayOrientedPose,
      projectionMatrix
    )

    // -- Draw occluded virtual objects

    // Update lighting parameters in the shader
    updateLightEstimation(frame.lightEstimate, viewMatrix)

    // Render text at anchor positions
    render.clear(virtualSceneFramebuffer, 0f, 0f, 0f, 0f)
    for ((anchor, trackable) in
      wrappedAnchors.filter { it.anchor.trackingState == TrackingState.TRACKING }) {
      // Get the current pose of an Anchor in world space
      val position = anchor.pose.translation
      
      // Get text for this anchor or use default
      val text = anchorTexts[anchor] ?: ""
      
      // Update text renderer with current text and background
      textRenderer.updateTextWithBackground(text)
      
      // Render text at this position
      try {
        textRenderer.renderText(position, viewMatrix, projectionMatrix)
      } catch (e: Exception) {
        Log.e(TAG, "Error rendering text", e)
        // Continue with other objects instead of crashing
      }
    }

    // Compose the virtual scene with the background.
    backgroundRenderer.drawVirtualScene(render, virtualSceneFramebuffer, Z_NEAR, Z_FAR)
    } catch (e: Exception) {
      Log.e(TAG, "Error in onDrawFrame", e)
      // Don't show error message here to avoid spam
    }
  }

  /** Checks if we detected at least one plane. */
  private fun Session.hasTrackingPlane() =
    getAllTrackables(Plane::class.java).any { it.trackingState == TrackingState.TRACKING }

  /** Update state based on the current frame's light estimation. */
  private fun updateLightEstimation(lightEstimate: LightEstimate, viewMatrix: FloatArray) {
    // Light estimation not needed for text rendering
    // Keeping the cubemap filter update for potential future use
    if (lightEstimate.state == LightEstimate.State.VALID) {
      cubemapFilter.update(lightEstimate.acquireEnvironmentalHdrCubeMap())
    }
  }

  // Light estimation methods removed as they're not needed for text rendering

  // Handle only one tap per frame, as taps are usually low frequency compared to frame rate.
  private fun handleTap(frame: Frame, camera: Camera) {
    if (camera.trackingState != TrackingState.TRACKING) return
    val tap = activity.view.tapHelper.poll() ?: return

    val hitResultList =
      if (activity.instantPlacementSettings.isInstantPlacementEnabled) {
        frame.hitTestInstantPlacement(tap.x, tap.y, APPROXIMATE_DISTANCE_METERS)
      } else {
        frame.hitTest(tap)
      }

    // First, check if we tapped on an existing anchor
    val existingAnchorHit = hitResultList.firstOrNull { hit ->
      // Check if the hit is close to any existing anchor
      wrappedAnchors.any { wrappedAnchor ->
        val anchorPosition = wrappedAnchor.anchor.pose.translation
        val hitPosition = hit.hitPose.translation
        val distance = Math.sqrt(
          Math.pow((anchorPosition[0] - hitPosition[0]).toDouble(), 2.0) +
          Math.pow((anchorPosition[1] - hitPosition[1]).toDouble(), 2.0) +
          Math.pow((anchorPosition[2] - hitPosition[2]).toDouble(), 2.0)
        )
        distance < 0.5 // 50cm threshold
      }
    }

    if (existingAnchorHit != null) {
      // Find the closest anchor to the hit point
      val closestAnchor = wrappedAnchors.minByOrNull { wrappedAnchor ->
        val anchorPosition = wrappedAnchor.anchor.pose.translation
        val hitPosition = existingAnchorHit.hitPose.translation
        val distance = Math.sqrt(
          Math.pow((anchorPosition[0] - hitPosition[0]).toDouble(), 2.0) +
          Math.pow((anchorPosition[1] - hitPosition[1]).toDouble(), 2.0) +
          Math.pow((anchorPosition[2] - hitPosition[2]).toDouble(), 2.0)
        )
        distance
      }
      
      closestAnchor?.let { wrappedAnchor ->
        // Show edit dialog for existing anchor
        try {
          activity.runOnUiThread { 
            try {
              showTextInputDialog(wrappedAnchor.anchor, true)
            } catch (e: Exception) {
              Log.e(TAG, "Error showing edit dialog", e)
            }
          }
        } catch (e: Exception) {
          Log.e(TAG, "Error running on UI thread for edit", e)
        }
      }
      return
    }

    // Hits are sorted by depth. Consider only closest hit on a plane, Oriented Point, Depth Point,
    // or Instant Placement Point.
    val firstHitResult =
      hitResultList.firstOrNull { hit ->
        when (val trackable = hit.trackable!!) {
          is Plane ->
            trackable.isPoseInPolygon(hit.hitPose) &&
              PlaneRenderer.calculateDistanceToPlane(hit.hitPose, camera.pose) > 0
          is Point -> trackable.orientationMode == Point.OrientationMode.ESTIMATED_SURFACE_NORMAL
          is InstantPlacementPoint -> true
          // DepthPoints are only returned if Config.DepthMode is set to AUTOMATIC.
          is DepthPoint -> true
          else -> false
        }
      }

    if (firstHitResult != null) {
      // Cap the number of objects created. This avoids overloading both the
      // rendering system and ARCore.
      if (wrappedAnchors.size >= 20) {
        wrappedAnchors[0].anchor.detach()
        wrappedAnchors.removeAt(0)
      }

      // Adding an Anchor tells ARCore that it should track this position in
      // space. This anchor is created on the Plane to place the text
      // in the correct position relative both to the world and to the plane.
      val newAnchor = firstHitResult.createAnchor()
      wrappedAnchors.add(WrappedAnchor(newAnchor, firstHitResult.trackable))
      
      // Show text input dialog for this anchor
      try {
        activity.runOnUiThread { 
          try {
            showTextInputDialog(newAnchor)
            activity.view.showOcclusionDialogIfNeeded() 
          } catch (e: Exception) {
            Log.e(TAG, "Error showing text input dialog", e)
            // Fallback to default text
            anchorTexts[newAnchor] = "Texto ${wrappedAnchors.size}"
          }
        }
      } catch (e: Exception) {
        Log.e(TAG, "Error running on UI thread", e)
        // Fallback to default text
        anchorTexts[newAnchor] = "Texto ${wrappedAnchors.size}"
      }
    }
  }

  fun updateText(newText: String) {
    textRenderer.updateText(newText)
  }
  
  fun setAnchorText(anchor: Anchor, text: String) {
    anchorTexts[anchor] = text
  }
  
  fun getAnchorText(anchor: Anchor): String? {
    return anchorTexts[anchor]
  }
  
  private fun showTextInputDialog(anchor: Anchor, isEdit: Boolean = false) {
    try {
      // Inflate custom layout
      val inflater = activity.layoutInflater
      val dialogView = inflater.inflate(R.layout.text_edit_dialog, null)
      
      // Get views from layout
      val titleText = dialogView.findViewById<android.widget.TextView>(R.id.dialog_title)
      val textInput = dialogView.findViewById<android.widget.EditText>(R.id.text_input)
      val deleteButton = dialogView.findViewById<android.widget.Button>(R.id.delete_button)
      val cancelButton = dialogView.findViewById<android.widget.Button>(R.id.cancel_button)
      val saveButton = dialogView.findViewById<android.widget.Button>(R.id.save_button)
      
      // Set title
      titleText.text = if (isEdit) "Gerenciar Texto" else "Novo Texto"
      
      // Set current text if editing, otherwise use default
      val currentText = if (isEdit) anchorTexts[anchor] else null
      textInput.setText(currentText ?: "Texto ${wrappedAnchors.size}")
      
      // Select all text for easy editing
      if (isEdit) {
        textInput.selectAll()
      }
      
      // Show/hide delete button based on mode
      deleteButton.visibility = if (isEdit) android.view.View.VISIBLE else android.view.View.GONE
      
      // Create dialog
      val dialog = android.app.AlertDialog.Builder(activity)
        .setView(dialogView)
        .setCancelable(false)
        .create()
      
      // Set button click listeners
      saveButton.setOnClickListener {
        val text = textInput.text.toString().trim()
        if (text.isNotEmpty()) {
          anchorTexts[anchor] = text
          Log.d(TAG, "Text ${if (isEdit) "updated" else "set"} for anchor: '$text'")
        } else {
          // Use default text if empty
          anchorTexts[anchor] = "Texto ${wrappedAnchors.size}"
          Log.d(TAG, "Empty text, using default: 'Texto ${wrappedAnchors.size}'")
        }
        dialog.dismiss()
      }
      
      cancelButton.setOnClickListener {
        if (!isEdit) {
          // Use default text if cancelled for new anchors
          anchorTexts[anchor] = "Texto ${wrappedAnchors.size}"
          Log.d(TAG, "Dialog cancelled, using default text: 'Texto ${wrappedAnchors.size}'")
        }
        dialog.dismiss()
      }
      
      deleteButton.setOnClickListener {
        dialog.dismiss()
        deleteAnchor(anchor)
      }
      
      // Show the dialog
      dialog.show()
      
      // Log dialog creation for debugging
      Log.d(TAG, "Text input dialog shown - isEdit: $isEdit, deleteButton visible: ${deleteButton.visibility == android.view.View.VISIBLE}")

      // Focus on the input field and show keyboard
      textInput.requestFocus()
      val imm = activity.getSystemService(android.content.Context.INPUT_METHOD_SERVICE) as android.view.inputmethod.InputMethodManager
      imm.showSoftInput(textInput, android.view.inputmethod.InputMethodManager.SHOW_IMPLICIT)

    } catch (e: Exception) {
      Log.e(TAG, "Error creating text input dialog", e)
      // Fallback to default text only for new anchors
      if (!isEdit) {
        anchorTexts[anchor] = "Texto ${wrappedAnchors.size}"
      }
    }
  }

  private fun deleteAnchor(anchor: Anchor) {
    try {
      // Remove from lists directly without confirmation
      val wrappedAnchor = wrappedAnchors.find { it.anchor == anchor }
      wrappedAnchor?.let {
        wrappedAnchors.remove(it)
        anchorTexts.remove(anchor)
        anchor.detach()
        Log.d(TAG, "Anchor deleted successfully")
      }
    } catch (e: Exception) {
      Log.e(TAG, "Error deleting anchor", e)
    }
  }
  
  private fun showError(errorMessage: String) {
    try {
      activity.view.snackbarHelper.showError(activity, errorMessage)
    } catch (e: Exception) {
      Log.e(TAG, "Failed to show error message: $errorMessage", e)
      // Fallback to toast if snackbar fails
      try {
        android.widget.Toast.makeText(activity, errorMessage, android.widget.Toast.LENGTH_LONG).show()
      } catch (e2: Exception) {
        Log.e(TAG, "Failed to show toast as well", e2)
      }
    }
  }
}

/**
 * Associates an Anchor with the trackable it was attached to. This is used to be able to check
 * whether or not an Anchor originally was attached to an {@link InstantPlacementPoint}.
 */
private data class WrappedAnchor(
  val anchor: Anchor,
  val trackable: Trackable,
)
