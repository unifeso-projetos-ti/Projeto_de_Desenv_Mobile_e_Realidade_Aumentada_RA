package com.google.ar.core.examples.kotlin.helloar

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.opengl.GLES20
import android.opengl.Matrix
import android.util.Log
import com.google.ar.core.examples.java.common.samplerender.IndexBuffer
import com.google.ar.core.examples.java.common.samplerender.Mesh
import com.google.ar.core.examples.java.common.samplerender.SampleRender
import com.google.ar.core.examples.java.common.samplerender.Shader
import com.google.ar.core.examples.java.common.samplerender.Texture
import com.google.ar.core.examples.java.common.samplerender.VertexBuffer
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import java.nio.IntBuffer
import java.io.Closeable

class TextRenderer(private val render: SampleRender) : Closeable {

    private lateinit var textMesh: Mesh
    private lateinit var textShader: Shader
    private lateinit var textTexture: Texture

    fun init() {
        try {
            // Quad geometry: separate position and UV buffers
            val positions = floatArrayOf(
                -0.5f, -0.5f, 0.0f,  // bottom‑left
                0.5f, -0.5f, 0.0f,  // bottom‑right
                0.5f,  0.5f, 0.0f,  // top‑right
                -0.5f,  0.5f, 0.0f   // top‑left
            )

            val uvs = floatArrayOf(
                0.0f, 1.0f,  // bottom-left (inverted Y)
                1.0f, 1.0f,  // bottom-right (inverted Y)
                1.0f, 0.0f,  // top-right (inverted Y)
                0.0f, 0.0f   // top-left (inverted Y)
            )

            val indices = intArrayOf(0, 1, 2, 0, 2, 3)

            // Criar buffers diretos para OpenGL
            val posBuffer = VertexBuffer(render, 3, ByteBuffer.allocateDirect(positions.size * 4).order(ByteOrder.nativeOrder()).asFloatBuffer().apply { put(positions); rewind() })
            val uvBuffer = VertexBuffer(render, 2, ByteBuffer.allocateDirect(uvs.size * 4).order(ByteOrder.nativeOrder()).asFloatBuffer().apply { put(uvs); rewind() })
            val indexBuffer = IndexBuffer(render, ByteBuffer.allocateDirect(indices.size * 4).order(ByteOrder.nativeOrder()).asIntBuffer().apply { put(indices); rewind() })

            textMesh = Mesh(
                render,
                Mesh.PrimitiveMode.TRIANGLES,
                indexBuffer,
                arrayOf(posBuffer, uvBuffer)
            )

            // Shaders stored in assets/shaders/
            textShader = Shader.createFromAssets(
                render,
                "shaders/text.vert",
                "shaders/text.frag",
                /*defines=*/null
            )

            createTextTexture("Hello AR")

            Log.d(TAG, "Text renderer initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize text renderer", e)
            throw e
        }
    }

    private fun createTextTexture(text: String) {
        try {
            // Configurações do texto
            var textSize = 48f
            val padding = 12
            val textColor = Color.WHITE
            val backgroundColor = Color.parseColor("#80000000") // Fundo semi-transparente preto
            val maxLineWidth2 = 200 // Largura máxima da linha em pixels
            
            // Criar paint para o texto
            val paint = Paint().apply {
                isAntiAlias = true
                textSize = textSize
                color = textColor
                typeface = Typeface.DEFAULT_BOLD
                textAlign = Paint.Align.CENTER
            }
            
            // Criar paint para o fundo
            val backgroundPaint = Paint().apply {
                isAntiAlias = true
                color = backgroundColor
                style = Paint.Style.FILL
            }
            
            // Quebrar texto em linhas
            val lines = breakTextIntoLines(text, paint, maxLineWidth2)
            
            // Calcular dimensões do texto com quebra de linha
            val lineHeight = paint.fontMetrics.let { it.bottom - it.top }
            val totalTextHeight = lineHeight * lines.size
            val maxLineWidth = lines.maxOfOrNull { paint.measureText(it) } ?: 0f
            
            // Calcular dimensões do bitmap (potência de 2 para melhor compatibilidade)
            val textWidth = maxLineWidth.toInt() + padding * 2
            val textHeight = totalTextHeight.toInt() + padding * 2
            
            // Arredondar para a próxima potência de 2
            val bitmapWidth = nextPowerOf2(textWidth)
            val bitmapHeight = nextPowerOf2(textHeight)
            
            // Criar bitmap
            val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            
            // Desenhar fundo transparente primeiro
            canvas.drawColor(Color.TRANSPARENT)
            
            // Calcular posição do fundo
            val backgroundLeft = (bitmapWidth - textWidth) / 2f
            val backgroundTop = (bitmapHeight - textHeight) / 2f
            val backgroundRight = backgroundLeft + textWidth
            val backgroundBottom = backgroundTop + textHeight
            
            // Desenhar fundo arredondado
            val cornerRadius = 12f
            val backgroundRect = android.graphics.RectF(backgroundLeft, backgroundTop, backgroundRight, backgroundBottom)
            canvas.drawRoundRect(backgroundRect, cornerRadius, cornerRadius, backgroundPaint)
            
            // Desenhar texto com quebra de linha
            val startY = backgroundTop + padding + paint.fontMetrics.let { -it.top }
            lines.forEachIndexed { index, line ->
                val x = bitmapWidth / 2f
                val y = startY + (lineHeight * index)
                canvas.drawText(line, x, y, paint)
            }
            
            // Converter bitmap para ByteBuffer
            val buffer = ByteBuffer.allocateDirect(bitmapWidth * bitmapHeight * 4)
            bitmap.copyPixelsToBuffer(buffer)
            buffer.rewind()
            
            // Criar textura usando o construtor padrão da classe Texture
            textTexture = Texture(
                render,
                Texture.Target.TEXTURE_2D,
                Texture.WrapMode.CLAMP_TO_EDGE,
                /*useMipmaps=*/ false
            )
            
            // Configurar dados da textura
            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textTexture.getTextureId())
            GLES20.glTexImage2D(
                GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA,
                bitmapWidth, bitmapHeight, 0,
                GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer
            )
            
            // Limpar bitmap
            bitmap.recycle()
            
            Log.d(TAG, "Text texture created successfully for: '$text'")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create text texture", e)
            // Fallback para textura padrão em caso de erro
            textTexture = Texture.createFromAsset(
                render,
                "models/54.png",
                Texture.WrapMode.CLAMP_TO_EDGE,
                Texture.ColorFormat.SRGB
            )
        }
    }
    
    private fun createTextTextureWithBackground(text: String, backgroundColor: Int) {
        try {
            // Configurações do texto
            var textSize = 20f
            val padding = 12
            val textColor = Color.WHITE
            val maxLineWidth2 = 200 // Largura máxima da linha em pixels
            
            // Criar paint para o texto
            val paint = Paint().apply {
                isAntiAlias = true
                textSize = textSize
                color = textColor
                typeface = Typeface.DEFAULT_BOLD
                textAlign = Paint.Align.CENTER
            }
            
            // Criar paint para o fundo
            val backgroundPaint = Paint().apply {
                isAntiAlias = true
                color = backgroundColor
                style = Paint.Style.FILL
            }
            
            // Quebrar texto em linhas
            val lines = breakTextIntoLines(text, paint, maxLineWidth2)
            
            // Calcular dimensões do texto com quebra de linha
            val lineHeight = paint.fontMetrics.let { it.bottom - it.top }
            val totalTextHeight = lineHeight * lines.size
            val maxLineWidth = lines.maxOfOrNull { paint.measureText(it) } ?: 0f
            
            // Calcular dimensões do bitmap (potência de 2 para melhor compatibilidade)
            val textWidth = maxLineWidth.toInt() + padding * 2
            val textHeight = totalTextHeight.toInt() + padding * 2
            
            // Arredondar para a próxima potência de 2
            val bitmapWidth = nextPowerOf2(textWidth)
            val bitmapHeight = nextPowerOf2(textHeight)
            
            // Criar bitmap
            val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            
            // Desenhar fundo transparente primeiro
            canvas.drawColor(Color.TRANSPARENT)
            
            // Calcular posição do fundo
            val backgroundLeft = (bitmapWidth - textWidth) / 2f
            val backgroundTop = (bitmapHeight - textHeight) / 2f
            val backgroundRight = backgroundLeft + textWidth
            val backgroundBottom = backgroundTop + textHeight
            
            // Desenhar fundo arredondado
            val cornerRadius = 12f
            val backgroundRect = android.graphics.RectF(backgroundLeft, backgroundTop, backgroundRight, backgroundBottom)
            canvas.drawRoundRect(backgroundRect, cornerRadius, cornerRadius, backgroundPaint)
            
            // Desenhar texto com quebra de linha
            val startY = backgroundTop + padding + paint.fontMetrics.let { -it.top }
            lines.forEachIndexed { index, line ->
                val x = bitmapWidth / 2f
                val y = startY + (lineHeight * index)
                canvas.drawText(line, x, y, paint)
            }
            
            // Converter bitmap para ByteBuffer
            val buffer = ByteBuffer.allocateDirect(bitmapWidth * bitmapHeight * 4)
            bitmap.copyPixelsToBuffer(buffer)
            buffer.rewind()
            
            // Criar textura usando o construtor padrão da classe Texture
            textTexture = Texture(
                render,
                Texture.Target.TEXTURE_2D,
                Texture.WrapMode.CLAMP_TO_EDGE,
                /*useMipmaps=*/ false
            )
            
            // Configurar dados da textura
            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textTexture.getTextureId())
            GLES20.glTexImage2D(
                GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA,
                bitmapWidth, bitmapHeight, 0,
                GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer
            )
            
            // Limpar bitmap
            bitmap.recycle()
            
            Log.d(TAG, "Text texture with background created successfully for: '$text'")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create text texture with background", e)
            // Fallback para textura padrão em caso de erro
            textTexture = Texture.createFromAsset(
                render,
                "models/54.png",
                Texture.WrapMode.CLAMP_TO_EDGE,
                Texture.ColorFormat.SRGB
            )
        }
    }
    
    private fun createTextTextureWithBackgroundAndWidth(text: String, backgroundColor: Int, maxLineWidth: Int) {
        try {
            // Configurações do texto
            var textSize = 48f
            val padding = 12
            val textColor = Color.WHITE
            
            // Criar paint para o texto
            val paint = Paint().apply {
                isAntiAlias = true
                textSize = textSize
                color = textColor
                typeface = Typeface.DEFAULT_BOLD
                textAlign = Paint.Align.CENTER
            }
            
            // Criar paint para o fundo
            val backgroundPaint = Paint().apply {
                isAntiAlias = true
                color = backgroundColor
                style = Paint.Style.FILL
            }
            
            // Quebrar texto em linhas
            val lines = breakTextIntoLines(text, paint, maxLineWidth)
            
            // Calcular dimensões do texto com quebra de linha
            val lineHeight = paint.fontMetrics.let { it.bottom - it.top }
            val totalTextHeight = lineHeight * lines.size
            val maxLineWidth = lines.maxOfOrNull { paint.measureText(it) } ?: 0f
            
            // Calcular dimensões do bitmap (potência de 2 para melhor compatibilidade)
            val textWidth = maxLineWidth.toInt() + padding * 2
            val textHeight = totalTextHeight.toInt() + padding * 2
            
            // Arredondar para a próxima potência de 2
            val bitmapWidth = nextPowerOf2(textWidth)
            val bitmapHeight = nextPowerOf2(textHeight)
            
            // Criar bitmap
            val bitmap = Bitmap.createBitmap(bitmapWidth, bitmapHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            
            // Desenhar fundo transparente primeiro
            canvas.drawColor(Color.TRANSPARENT)
            
            // Calcular posição do fundo
            val backgroundLeft = (bitmapWidth - textWidth) / 2f
            val backgroundTop = (bitmapHeight - textHeight) / 2f
            val backgroundRight = backgroundLeft + textWidth
            val backgroundBottom = backgroundTop + textHeight
            
            // Desenhar fundo arredondado
            val cornerRadius = 12f
            val backgroundRect = android.graphics.RectF(backgroundLeft, backgroundTop, backgroundRight, backgroundBottom)
            canvas.drawRoundRect(backgroundRect, cornerRadius, cornerRadius, backgroundPaint)
            
            // Desenhar texto com quebra de linha
            val startY = backgroundTop + padding + paint.fontMetrics.let { -it.top }
            lines.forEachIndexed { index, line ->
                val x = bitmapWidth / 2f
                val y = startY + (lineHeight * index)
                canvas.drawText(line, x, y, paint)
            }
            
            // Converter bitmap para ByteBuffer
            val buffer = ByteBuffer.allocateDirect(bitmapWidth * bitmapHeight * 4)
            bitmap.copyPixelsToBuffer(buffer)
            buffer.rewind()
            
            // Criar textura usando o construtor padrão da classe Texture
            textTexture = Texture(
                render,
                Texture.Target.TEXTURE_2D,
                Texture.WrapMode.CLAMP_TO_EDGE,
                /*useMipmaps=*/ false
            )
            
            // Configurar dados da textura
            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textTexture.getTextureId())
            GLES20.glTexImage2D(
                GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA,
                bitmapWidth, bitmapHeight, 0,
                GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer
            )
            
            // Limpar bitmap
            bitmap.recycle()
            
            Log.d(TAG, "Text texture with background and width created successfully for: '$text'")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create text texture with background and width", e)
            // Fallback para textura padrão em caso de erro
            textTexture = Texture.createFromAsset(
                render,
                "models/54.png",
                Texture.WrapMode.CLAMP_TO_EDGE,
                Texture.ColorFormat.SRGB
            )
        }
    }
    
    private fun nextPowerOf2(n: Int): Int {
        var power = 1
        while (power < n) {
            power *= 2
        }
        return power
    }
    
    private fun breakTextIntoLines(text: String, paint: Paint, maxWidth: Int): List<String> {
        val words = text.split(" ")
        val lines = mutableListOf<String>()
        var currentLine = ""
        
        for (word in words) {
            val testLine = if (currentLine.isEmpty()) word else "$currentLine $word"
            val testWidth = paint.measureText(testLine)
            
            if (testWidth <= maxWidth) {
                currentLine = testLine
            } else {
                if (currentLine.isNotEmpty()) {
                    lines.add(currentLine)
                }
                currentLine = word
            }
        }
        
        if (currentLine.isNotEmpty()) {
            lines.add(currentLine)
        }
        
        // Se não coube nenhuma palavra, quebra a palavra
        if (lines.isEmpty()) {
            var remainingText = text
            while (remainingText.isNotEmpty()) {
                var endIndex = remainingText.length
                while (endIndex > 0 && paint.measureText(remainingText.substring(0, endIndex)) > maxWidth) {
                    endIndex--
                }
                
                if (endIndex == 0) {
                    // Se não coube nem uma letra, força a quebra
                    endIndex = 1
                }
                
                lines.add(remainingText.substring(0, endIndex))
                remainingText = remainingText.substring(endIndex).trim()
            }
        }
        
        return lines
    }

    fun updateText(text: String) {
        try {
            // Limpar textura anterior se existir
            if (::textTexture.isInitialized) {
                textTexture.close()
            }
            
            // Criar nova textura com o novo texto
            createTextTexture(text)
            
            Log.d(TAG, "Text updated to: $text")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to update text", e)
        }
    }
    
    fun updateTextWithBackground(text: String, backgroundColor: Int = Color.parseColor("#80000000")) {
        try {
            // Limpar textura anterior se existir
            if (::textTexture.isInitialized) {
                textTexture.close()
            }
            
            // Criar nova textura com o novo texto e fundo personalizado
            createTextTextureWithBackground(text, backgroundColor)
            
            Log.d(TAG, "Text updated with background to: '$text'")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to update text with background", e)
        }
    }
    
    fun updateTextWithBackgroundAndWidth(text: String, backgroundColor: Int = Color.parseColor("#80000000"), maxLineWidth: Int = 200) {
        try {
            // Limpar textura anterior se existir
            if (::textTexture.isInitialized) {
                textTexture.close()
            }
            
            // Criar nova textura com o novo texto, fundo personalizado e largura máxima
            createTextTextureWithBackgroundAndWidth(text, backgroundColor, maxLineWidth)
            
            Log.d(TAG, "Text updated with background and width to: '$text'")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to update text with background and width", e)
        }
    }

    fun renderText(
        position: FloatArray,
        viewMatrix: FloatArray,
        projectionMatrix: FloatArray
    ) {
        try {
            val modelMatrix = FloatArray(16)
            Matrix.setIdentityM(modelMatrix, 0)
            Matrix.translateM(modelMatrix, 0, position[0], position[1], position[2])
            Matrix.scaleM(modelMatrix, 0, 0.5f, 0.5f, 0.5f)

            val modelViewMatrix = FloatArray(16)
            val modelViewProjectionMatrix = FloatArray(16)
            Matrix.multiplyMM(modelViewMatrix, 0, viewMatrix, 0, modelMatrix, 0)
            Matrix.multiplyMM(
                modelViewProjectionMatrix,
                0,
                projectionMatrix,
                0,
                modelViewMatrix,
                0
            )

            textShader.setMat4("u_ModelViewProjection", modelViewProjectionMatrix)
            textShader.setTexture("u_Texture", textTexture)
            render.draw(textMesh, textShader)
        } catch (e: Exception) {
            Log.e(TAG, "Error rendering text", e)
        }
    }

    override fun close() {
        try {
            if (::textTexture.isInitialized) {
                textTexture.close()
            }
            if (::textShader.isInitialized) {
                textShader.close()
            }
            if (::textMesh.isInitialized) {
                textMesh.close()
            }
            Log.d(TAG, "Text renderer resources cleaned up")
        } catch (e: Exception) {
            Log.e(TAG, "Error cleaning up text renderer resources", e)
        }
    }

    private companion object {
        private const val TAG = "TextRenderer"
    }
}
