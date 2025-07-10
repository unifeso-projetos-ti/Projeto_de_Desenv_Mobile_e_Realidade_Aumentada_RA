# Guia de Implementação AR

Este guia explica como usar os componentes AR implementados no projeto.

## Componentes AR Criados

### 1. ARModelView.tsx
Componente básico de AR que renderiza modelos 3D com otimizações para realidade aumentada.

**Características:**
- Renderização otimizada para AR
- Controles de rotação por toque
- Indicadores visuais de AR
- Tratamento de erros
- Loading states

**Uso:**
```tsx
import ARModelView from "@/components/ARModelView";

<ARModelView modelUrl="https://exemplo.com/modelo.glb" />
```

### 2. RealARModelView.tsx
Componente avançado de AR com detecção de ambiente e funcionalidades expandidas.

**Características:**
- Detecção de ambiente de execução
- Interface adaptativa
- Melhor tratamento de erros
- Preparado para AR real futuro

**Uso:**
```tsx
import RealARModelView from "@/components/RealARModelView";

<RealARModelView modelUrl="https://exemplo.com/modelo.glb" />
```

## Diferenças do ThreeDModelView.tsx

### Otimizações para AR:

1. **Iluminação Melhorada:**
   - Luz ambiente mais intensa (0.8 vs 0.6)
   - Luz direcional mais forte (1.2 vs 1.0)
   - Luz de preenchimento adicional para melhor visibilidade

2. **Configurações de Câmera:**
   - FOV reduzido (60° vs 75°) para melhor perspectiva AR
   - Posicionamento otimizado para AR

3. **Renderização:**
   - Fundo transparente para AR
   - Escala menor dos modelos (1.5 vs 2.0)
   - Posicionamento mais próximo da câmera

4. **Interface:**
   - Indicadores visuais de AR
   - Estados de loading
   - Tratamento de erros
   - Overlay de ambiente AR

## Implementação no Home.tsx

O componente principal usa a seguinte lógica:

```tsx
{isAR ? (
  isRunningInExpo ? (
    <View style={styles.expoMessage}>
      <Text>AR real disponível apenas na versão instalada</Text>
    </View>
  ) : (
    <ARModelView modelUrl={selectedModel.url} />
  )
) : (
  <ThreeDModelView modelUrl={selectedModel.url} />
)}
```

## Estrutura de Dados

Os modelos são carregados do arquivo `assets/models/models-mockdb.ts`:

```typescript
interface Model {
  name: string;
  url: string;
  slug: string;
}
```

## Funcionalidades Implementadas

✅ **Renderização AR Otimizada** - Baseada no ThreeDModelView  
✅ **Controles de Rotação** - Toque e arraste para rotacionar  
✅ **Indicadores Visuais** - Status AR e instruções  
✅ **Estados de Loading** - Feedback visual durante carregamento  
✅ **Tratamento de Erros** - Fallbacks para falhas de carregamento  
✅ **Interface Adaptativa** - Diferentes comportamentos por ambiente  

## Próximos Passos para AR Real

Para implementar AR real com câmera:

1. **Instalar expo-camera:**
   ```bash
   npm install expo-camera
   ```

2. **Solicitar permissões:**
   ```tsx
   const { status } = await Camera.requestCameraPermissionsAsync();
   ```

3. **Integrar feed da câmera:**
   ```tsx
   <Camera style={styles.camera}>
     <GLView style={styles.glView} />
   </Camera>
   ```

4. **Implementar detecção de superfícies:**
   - Usar ARCore (Android) ou ARKit (iOS)
   - Detectar planos e superfícies
   - Posicionar modelos automaticamente

## Dependências Utilizadas

- `expo-gl`: Renderização OpenGL
- `expo-three`: Integração com Three.js
- `three`: Biblioteca 3D
- `@types/three`: Tipos TypeScript

## Limitações Atuais

1. **AR Simulado**: Implementação atual é uma simulação
2. **Sem Câmera**: Não usa feed da câmera real
3. **Sem Detecção de Superfícies**: Modelos não se posicionam automaticamente
4. **Expo Go**: AR real requer instalação nativa

## Exemplo de Uso Completo

```tsx
import React, { useState } from "react";
import { View, Text } from "react-native";
import ARModelView from "@/components/ARModelView";

export default function ARExample() {
  const [modelUrl, setModelUrl] = useState("https://exemplo.com/modelo.glb");

  return (
    <View style={{ flex: 1 }}>
      <Text>Visualização AR</Text>
      <ARModelView modelUrl={modelUrl} />
    </View>
  );
}
```

## Troubleshooting

### Erro de Carregamento de Modelo:
- Verifique se a URL do modelo é válida
- Confirme se o formato é GLB/GLTF
- Verifique a conectividade de rede

### Performance Lenta:
- Reduza a complexidade dos modelos
- Otimize texturas e geometrias
- Use modelos com LOD (Level of Detail)

### Problemas de Renderização:
- Verifique se expo-gl está funcionando
- Confirme compatibilidade com o dispositivo
- Teste em diferentes dispositivos 