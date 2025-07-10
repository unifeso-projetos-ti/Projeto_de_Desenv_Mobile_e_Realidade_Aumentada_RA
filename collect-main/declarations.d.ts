declare module '@react-native-community/slider';

/// <reference types="nativewind/types" />

declare module 'expo-three' {
    export class Renderer {
      constructor(options: { gl: any });
      setSize(width: number, height: number): void;
      render(scene: any, camera: any): void;
    }
  }