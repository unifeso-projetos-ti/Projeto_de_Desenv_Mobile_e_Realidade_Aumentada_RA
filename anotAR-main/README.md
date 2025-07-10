# 🚀 anotAR - Aplicativo de Realidade Aumentada

<div align="center">

![ARCore](https://img.shields.io/badge/ARCore-1.48.0-blue?style=for-the-badge&logo=google)
![Kotlin](https://img.shields.io/badge/Kotlin-1.9.0-purple?style=for-the-badge&logo=kotlin)
![Android](https://img.shields.io/badge/Android-API%2024+-green?style=for-the-badge&logo=android)
![Academic](https://img.shields.io/badge/Academic%20Project-🎓-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-Apache%202.0-red?style=for-the-badge)

**Transforme o mundo ao seu redor com anotações em Realidade Aumentada!**

[📱 Download](#-como-usar) • [🔧 Configuração](#-configuração) • [📚 Documentação](#-funcionalidades)

</div>

---

## ✨ Sobre o Projeto

O **anotAR** é um aplicativo Android inovador que utiliza a tecnologia de Realidade Aumentada (AR) para permitir que você adicione anotações virtuais ao mundo real. Desenvolvido com ARCore da Google, o app oferece uma experiência imersiva e interativa.

> **🎓 Projeto Acadêmico**: Este projeto foi desenvolvido como parte da disciplina de **Desenvolvimento Mobile com Realidade Aumentada** da faculdade, demonstrando a aplicação prática dos conceitos de AR em um contexto educacional.

> **📚 Baseado no Exemplo Oficial**: Este projeto é uma extensão do exemplo "Hello AR Kotlin" oficial do Google ARCore, disponível no [repositório oficial do ARCore](https://github.com/google-ar/arcore-android-sdk/tree/master/samples/hello_ar_kotlin). O exemplo original demonstra os conceitos básicos de ARCore, e o anotAR adiciona funcionalidades específicas para anotações em realidade aumentada.

### 🎯 Principais Características

- **🔄 Detecção de Superfícies**: Identifica automaticamente planos e superfícies no ambiente
- **📝 Anotações Virtuais**: Adicione texto e objetos 3D ao mundo real
- **🎨 Renderização Avançada**: Gráficos 3D de alta qualidade com shaders personalizados
- **⚡ Instant Placement**: Colocação instantânea de objetos sem necessidade de superfícies detectadas
- **🌍 Suporte a Profundidade**: Adaptação automática dos objetos ao ambiente real
- **📱 Interface Intuitiva**: Design moderno e fácil de usar

### 🔄 Modificações do Exemplo Original

| Funcionalidade Original | Modificação no anotAR |
|-------------------------|----------------------|
| **Placement de objetos 3D** | **Sistema de anotações de texto** |
| **Modelos 3D estáticos** | **Editor de texto integrado** |
| **Interface básica** | **Interface customizada para anotações** |
| **Renderização simples** | **Renderização otimizada para texto** |

### 🎓 Contexto Acadêmico

Este projeto foi desenvolvido para a disciplina **"Desenvolvimento Mobile com Realidade Aumentada"** e demonstra:

- **📖 Aprendizado Prático**: Aplicação dos conceitos teóricos de AR em um projeto real
- **🔬 Experimentação**: Exploração das capacidades do ARCore em diferentes cenários
- **💡 Inovação**: Extensão de um exemplo básico para uma aplicação mais complexa
- **📊 Avaliação**: Demonstração de competências em desenvolvimento mobile com AR

**Objetivos de Aprendizado Alcançados:**
- ✅ Compreensão dos fundamentos de ARCore
- ✅ Implementação de detecção de superfícies
- ✅ Desenvolvimento de interface para AR
- ✅ Integração de entrada de usuário em contexto AR
- ✅ Otimização de performance em aplicações AR

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **ARCore** | 1.48.0 | Framework de Realidade Aumentada da Google |
| **Kotlin** | 1.9.0 | Linguagem de programação principal |
| **Android SDK** | API 24+ | Plataforma de desenvolvimento |
| **OpenGL ES** | 2.0+ | Renderização gráfica 3D |
| **Material Design** | 1.1.0 | Componentes de interface |

---

## 📋 Pré-requisitos

### 📱 Dispositivo
- Android 7.0 (API 24) ou superior
- Câmera traseira funcional
- Suporte a ARCore (verificar [compatibilidade](https://developers.google.com/ar/discover/supported-devices))

### 🛠️ Desenvolvimento
- Android Studio Arctic Fox ou superior
- JDK 17
- Gradle 8.0+
- Google Play Services for AR instalado

---

## ⚙️ Configuração

### 1. Clone o Repositório
```bash
git clone https://github.com/seu-usuario/anotAR.git
cd anotAR
```

### 2. Configure o Android Studio
1. Abra o projeto no Android Studio
2. Sincronize o Gradle (File → Sync Project with Gradle Files)
3. Aguarde o download das dependências

### 3. Configure o Dispositivo
1. Ative o **Modo Desenvolvedor** no seu Android
2. Ative a **Depuração USB**
3. Conecte o dispositivo via USB
4. Instale o **Google Play Services for AR** (se necessário)

### 4. Execute o Projeto
```bash
# Via terminal
./gradlew assembleDebug
./gradlew installDebug

# Ou via Android Studio
# Clique em "Run" (▶️)
```

---

## 🎮 Como Usar

### 📱 Primeira Execução
1. **Permissões**: Conceda acesso à câmera quando solicitado
2. **Calibração**: Mova o dispositivo lentamente para calibrar o AR
3. **Detecção**: Aguarde a detecção de superfícies (indicado por pontos)

### 🎯 Funcionalidades Principais

#### 🔍 Detecção de Superfícies
- Mova o dispositivo para detectar planos
- Superfícies válidas são destacadas visualmente
- Toque em uma superfície para posicionar objetos

#### 📝 Adicionando Anotações
1. **Toque** em uma superfície detectada
2. **Digite** sua anotação no diálogo que aparece
3. **Confirme** para criar a anotação virtual

#### ⚙️ Configurações Avançadas
- **Profundidade**: Ative para melhor integração com o ambiente
- **Instant Placement**: Coloque objetos sem superfícies detectadas
- **Visualização de Profundidade**: Veja o mapa de profundidade em tempo real

---

## 🏗️ Arquitetura do Projeto

```
anotAR/
├── 📁 app/
│   ├── 📁 src/main/
│   │   ├── 📁 java/com/google/ar/core/examples/kotlin/helloar/
│   │   │   ├── 🎯 HelloArActivity.kt          # Atividade principal
│   │   │   ├── 🎨 HelloArRenderer.kt          # Renderização 3D
│   │   │   ├── 📱 HelloArView.kt              # Interface do usuário
│   │   │   └── ✏️ TextRenderer.kt              # Renderização de texto
│   │   ├── 📁 assets/
│   │   │   ├── 📁 models/                     # Modelos 3D
│   │   │   └── 📁 shaders/                    # Shaders OpenGL
│   │   └── 📁 res/                            # Recursos Android
│   └── 📄 build.gradle                        # Configuração do build
└── 📄 README.md                               # Este arquivo
```

---

## 🔧 Funcionalidades Técnicas

### 🎨 Sistema de Renderização
- **OpenGL ES 2.0**: Renderização gráfica de alta performance
- **Shaders Personalizados**: Efeitos visuais avançados
- **Texturas**: Suporte a múltiplos formatos de imagem
- **Modelos 3D**: Carregamento de arquivos OBJ e GLB

### 📊 Detecção e Rastreamento
- **SLAM**: Simultaneous Localization and Mapping
- **Detecção de Planos**: Identificação automática de superfícies
- **Rastreamento de Movimento**: Seguimento preciso da câmera
- **Estimativa de Luz**: Iluminação ambiental realista

### 🔄 Gerenciamento de Sessão
- **Ciclo de Vida**: Gerenciamento automático da sessão AR
- **Tratamento de Erros**: Recuperação robusta de falhas
- **Permissões**: Gerenciamento automático de permissões
- **Compatibilidade**: Verificação de suporte do dispositivo

---

## 🐛 Solução de Problemas

### ❌ Problemas Comuns

| Problema | Solução |
|----------|---------|
| **"Camera not available"** | Reinicie o app e verifique permissões |
| **"This device does not support AR"** | Verifique compatibilidade com ARCore |
| **Objetos não aparecem** | Calibre o dispositivo movendo-o lentamente |
| **App trava** | Feche outros apps e reinicie o dispositivo |

### 🔧 Debug
```bash
# Logs detalhados
adb logcat | grep "HelloArActivity"

# Verificar permissões
adb shell dumpsys package com.google.ar.core.examples.kotlin.helloar
```

---

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Siga estes passos:

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### 📝 Padrões de Código
- Use **Kotlin** para novos arquivos
- Siga as **convenções de nomenclatura** do Android
- Adicione **comentários** para código complexo
- Teste em **múltiplos dispositivos**

---

## 📄 Licença

Este projeto está licenciado sob a **Apache License 2.0** - veja o arquivo [LICENSE](LICENSE) para detalhes.

```
Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```


<div align="center">

**⭐ Se este projeto te ajudou, considere dar uma estrela!**

[⬆️ Voltar ao topo](#-anotar---aplicativo-de-realidade-aumentada)

</div> 