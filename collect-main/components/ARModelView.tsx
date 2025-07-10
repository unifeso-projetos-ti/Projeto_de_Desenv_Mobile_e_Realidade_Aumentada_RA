import React, { useRef, useEffect, useState } from "react";
import { View, Text, StyleSheet, Dimensions, PanResponder } from "react-native";
import { GLView } from "expo-gl";
import { Renderer } from "expo-three";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

interface ARModelViewProps {
  modelUrl: string;
}

const { width, height } = Dimensions.get("window");

export default function ARModelView({ modelUrl }: ARModelViewProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  const rotation = useRef({ x: 0, y: 0 });
  const modelRef = useRef<THREE.Group | null>(null);
  const sceneRef = useRef<THREE.Scene | null>(null);
  const cameraRef = useRef<THREE.PerspectiveCamera | null>(null);
  const rendererRef = useRef<any>(null);

  const clamp = (value: number, min: number, max: number) =>
    Math.max(min, Math.min(max, value));

  const panResponder = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      onMoveShouldSetPanResponder: () => true,
      onPanResponderMove: (_, gestureState) => {
        const deltaX = gestureState.dx * 0.005;
        const deltaY = gestureState.dy * 0.005;

        rotation.current.y = clamp(rotation.current.y + deltaX, -Math.PI, Math.PI);
        rotation.current.x = clamp(rotation.current.x + deltaY, -Math.PI, Math.PI);
      },
    })
  ).current;

  const loadModel = (scene: THREE.Scene) => {
    setIsLoading(true);
    setError(null);

    // Remove old model if exists
    if (modelRef.current) {
      scene.remove(modelRef.current);
      modelRef.current = null;
    }

    const loader = new GLTFLoader();
    loader.load(
      modelUrl,
      (gltf: any) => {
        const model = gltf.scene;
        const box = new THREE.Box3().setFromObject(model);
        const size = box.getSize(new THREE.Vector3()).length();
        const center = box.getCenter(new THREE.Vector3());

        // Center the model
        model.position.sub(center);
        
        // Scale for AR (smaller scale for better AR experience)
        model.scale.setScalar(1.5 / size);
        
        // Position for AR (closer to camera)
        model.position.z = -2.5;

        scene.add(model);
        modelRef.current = model;
        setIsLoading(false);
      },
      undefined,
      (error: any) => {
        console.error("Erro ao carregar modelo GLB:", error);
        setError("Erro ao carregar modelo 3D");
        setIsLoading(false);
      }
    );
  };

  useEffect(() => {
    // Reload model when URL changes
    if (sceneRef.current) {
      loadModel(sceneRef.current);
    }
  }, [modelUrl]);

  if (error) {
    return (
      <View style={styles.container}>
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>{error}</Text>
        </View>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <GLView
        style={styles.glView}
        {...panResponder.panHandlers}
        onContextCreate={async (gl) => {
          const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;

          // Create scene with AR-optimized settings
          const scene = new THREE.Scene();
          sceneRef.current = scene;

          // AR-optimized camera settings
          const camera = new THREE.PerspectiveCamera(60, width / height, 0.1, 1000);
          camera.position.set(0, 0, 3);
          cameraRef.current = camera;

          const renderer: any = new Renderer({ gl });
          renderer.setSize(width, height);
          renderer.setClearColor(0x000000, 0); // Transparent background for AR
          rendererRef.current = renderer;

          // AR-optimized lighting
          const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
          scene.add(ambientLight);

          const directionalLight = new THREE.DirectionalLight(0xffffff, 1.2);
          directionalLight.position.set(2, 2, 5);
          scene.add(directionalLight);

          // Add subtle fill light for better AR visibility
          const fillLight = new THREE.DirectionalLight(0xffffff, 0.4);
          fillLight.position.set(-2, -2, -5);
          scene.add(fillLight);

          // Load initial model
          loadModel(scene);

          const render = () => {
            requestAnimationFrame(render);

            if (modelRef.current) {
              modelRef.current.rotation.y = rotation.current.y;
              modelRef.current.rotation.x = rotation.current.x;
            }

            renderer.render(scene, camera);
            gl.endFrameEXP();
          };

          render();
        }}
      />
      
      {/* AR Status Indicator */}
      <View style={styles.arIndicator}>
        <Text style={styles.arIndicatorText}>AR Ativo</Text>
        <Text style={styles.arInstructionText}>Toque e arraste para rotacionar</Text>
      </View>

      {/* Loading Indicator */}
      {isLoading && (
        <View style={styles.loadingContainer}>
          <Text style={styles.loadingText}>Carregando modelo AR...</Text>
        </View>
      )}

      {/* AR Environment Overlay */}
      <View style={styles.arOverlay} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    width: "100%",
    height: 400,
    position: "relative",
  },
  glView: {
    flex: 1,
  },
  arOverlay: {
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: "rgba(0, 0, 0, 0.05)",
    pointerEvents: "none",
  },
  arIndicator: {
    position: "absolute",
    top: 20,
    left: 20,
    backgroundColor: "rgba(0, 0, 0, 0.8)",
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: "#00ff00",
  },
  arIndicatorText: {
    color: "#00ff00",
    fontSize: 12,
    fontWeight: "bold",
  },
  arInstructionText: {
    color: "#fff",
    fontSize: 10,
    marginTop: 2,
  },
  loadingContainer: {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: [{ translateX: -50 }, { translateY: -50 }],
    backgroundColor: "rgba(0, 0, 0, 0.8)",
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 10,
  },
  loadingText: {
    color: "#fff",
    fontSize: 14,
    textAlign: "center",
  },
  errorContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "rgba(255, 0, 0, 0.1)",
    borderRadius: 10,
    margin: 20,
  },
  errorText: {
    color: "#ff0000",
    fontSize: 16,
    textAlign: "center",
    padding: 20,
  },
}); 