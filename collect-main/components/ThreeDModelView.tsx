// ThreeDModelView.tsx
import React, { useRef, useEffect } from "react";
import { View, PanResponder } from "react-native";
import { GLView } from "expo-gl";
import { Renderer } from "expo-three";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
interface ThreeDModelViewProps {
  modelUrl: string;
}
type Props = {
  modelUrl: string;
};

export default function ThreeDModelView({ modelUrl }: Props) {
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

  useEffect(() => {
    // If the model URL changes, reload the model in the scene
    if (!sceneRef.current || !modelRef.current) return;

    // Remove old model
    if (modelRef.current) {
      sceneRef.current.remove(modelRef.current);
      modelRef.current = null;
    }

    // Load new model
    const loader = new GLTFLoader();
    loader.load(
      modelUrl,
      (gltf: any) => {
        const model = gltf.scene;
        const box = new THREE.Box3().setFromObject(model);
        const size = box.getSize(new THREE.Vector3()).length();
        const center = box.getCenter(new THREE.Vector3());

        model.position.sub(center);
        model.scale.setScalar(2 / size);

        sceneRef.current!.add(model);
        modelRef.current = model;
      },
      undefined,
      (error: any) => {
        console.error("Erro ao carregar modelo GLB:", error);
      }
    );
  }, [modelUrl]);

  return (
    <View style={{ width: "100%", height: 300 }}>
      <GLView
        style={{ flex: 1 }}
        {...panResponder.panHandlers}
        onContextCreate={async (gl) => {
          const { drawingBufferWidth: width, drawingBufferHeight: height } = gl;

          const scene = new THREE.Scene();
          sceneRef.current = scene;

          const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
          camera.position.set(0, 0, 2);
          cameraRef.current = camera;

          const renderer: any = new Renderer({ gl });
          renderer.setSize(width, height);
          rendererRef.current = renderer;

          const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
          scene.add(ambientLight);

          const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
          directionalLight.position.set(2, 2, 5);
          scene.add(directionalLight);

          // Load initial model
          const loader = new GLTFLoader();
          loader.load(
            modelUrl,
            (gltf: any) => {
              const model = gltf.scene;
              const box = new THREE.Box3().setFromObject(model);
              const size = box.getSize(new THREE.Vector3()).length();
              const center = box.getCenter(new THREE.Vector3());

              model.position.sub(center);
              model.scale.setScalar(2 / size);

              scene.add(model);
              modelRef.current = model;
            },
            undefined,
            (error: any) => {
              console.error("Erro ao carregar modelo GLB:", error);
            }
          );

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
    </View>
  );
}
