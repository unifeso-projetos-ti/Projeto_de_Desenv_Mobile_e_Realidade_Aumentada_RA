# 🛍️ Lojinha do Zezé - Aplicação Mobile com Visualização 3D

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Descrição do Projeto

A **Lojinha do Zezé** é uma aplicação móvel desenvolvida em Flutter que oferece uma experiência inovadora de e-commerce com visualização 3D de produtos. O projeto implementa funcionalidades avançadas de renderização 3D e realidade aumentada, permitindo que os usuários visualizem produtos em três dimensões antes de realizar uma compra.

### 🎯 Objetivos Principais

- **Visualização 3D Interativa**: Renderização de modelos 3D (.obj) com texturas
- **Realidade Aumentada**: Visualização de produtos sobrepostos ao mundo real
- **Interface Responsiva**: Design adaptável para diferentes tamanhos de tela
- **Sistema de Favoritos**: Gerenciamento de produtos favoritos
- **Busca Inteligente**: Sistema de pesquisa de produtos

## 🚀 Funcionalidades

### ✅ Implementadas com Sucesso

- **🏠 Tela Inicial**: Listagem de produtos em grid responsivo
- **🔍 Busca**: Campo de pesquisa funcional
- **❤️ Favoritos**: Sistema de gerenciamento de produtos favoritos
- **⚙️ Configurações**: Tela de configurações do aplicativo
- **📱 Visualização 3D**: Renderização de modelos 3D com controles interativos
- **📷 Câmera**: Integração com câmera do dispositivo
- **👆 Controles Touch**: Gestos para interação com modelos 3D
- **🔍 Zoom e Rotação**: Controles de zoom in/out e rotação do modelo

### 🔄 Funcionalidades em Desenvolvimento

- **🛒 Carrinho de Compras**: Sistema de carrinho de compras
- **💳 Pagamento**: Integração com gateways de pagamento
- **👤 Perfil do Usuário**: Sistema de autenticação e perfil
- **📊 Histórico**: Histórico de compras e visualizações

## 🛠️ Tecnologias Utilizadas

### Plataforma Principal
- **Flutter 3.7.0**: Framework de desenvolvimento multiplataforma
- **Dart 3.0.0**: Linguagem de programação
- **Material Design**: Sistema de design do Google

### Bibliotecas Principais
```yaml
dependencies:
  flutter_cube: ^0.1.1          # Renderização 3D
  camera: ^0.11.0               # Acesso à câmera
  font_awesome_flutter: 10.8.0  # Ícones personalizados
  url_launcher: ^6.3.1          # Abertura de links externos
```

### Ferramentas de Desenvolvimento
- **Android Studio / VS Code**: IDEs para desenvolvimento
- **Git**: Controle de versão
- **GitHub**: Repositório remoto

## 📱 Compatibilidade

- **Android**: API Level 21+ (Android 5.0+)
- **Dispositivos**: Smartphones e tablets Android

## 🚀 Como Executar o Projeto

### Pré-requisitos

1. **Flutter SDK**: Versão 3.7.0 ou superior
   ```bash
   flutter --version
   ```

2. **Dart SDK**: Versão 3.0.0 ou superior
   ```bash
   dart --version
   ```

3. **IDE**: Android Studio ou VS Code com extensões Flutter/Dart

4. **Dispositivo/Emulador**: Android ou iOS

### Instalação e Configuração

#### 1. Clone o Repositório
```bash
git clone https://github.com/YannTorres/projeto_mobile_faculdade.git
cd projeto_mobile_faculdade
```

#### 2. Instale as Dependências
```bash
flutter pub get
```

#### 3. Verifique a Configuração
```bash
flutter doctor
```

#### 4. Execute o Projeto

**Para Android:**
```bash
flutter run
```

**Para Web:**
```bash
flutter run -d chrome
```

### Configurações Específicas

#### Android
1. Abra `android/app/build.gradle.kts`
2. Verifique se o `minSdkVersion` está configurado para 21
3. Certifique-se de que as permissões de câmera estão configuradas

## 📁 Estrutura do Projeto

```
lib/
├── assets/                    # Recursos do aplicativo
│   ├── 3d_models/            # Modelos 3D (.obj, .mtl)
│   │   ├── texturas/         # Texturas dos modelos
│   │   ├── model.obj         # Modelo 3D da roda
│   │   └── old_chair.obj     # Modelo 3D da cadeira
│   ├── cadeira.jpeg          # Imagem da cadeira
│   └── roda.jpg              # Imagem da roda
├── models/                    # Modelos de dados
│   ├── product.dart          # Modelo de produto
│   ├── favorites_manager.dart # Gerenciador de favoritos
│   └── user_account_manager.dart # Gerenciador de conta
├── screens/                   # Telas do aplicativo
│   ├── home_page.dart        # Página principal
│   ├── home_screen.dart      # Tela inicial
│   ├── search_screen.dart    # Tela de busca
│   ├── favorites_screen.dart # Tela de favoritos
│   ├── settings_screen.dart  # Tela de configurações
│   ├── product_details_screen.dart # Detalhes do produto
│   └── product_3d_view_screen.dart # Visualização 3D
├── widgets/                   # Widgets customizados
│   ├── custom_app_bar.dart   # Barra de aplicativo customizada
│   ├── custom_bottom_navegation_bar.dart # Navegação inferior
│   └── product_card.dart     # Card de produto
└── main.dart                 # Ponto de entrada do aplicativo
```

## 🎮 Como Usar

### Navegação Principal
1. **Tela Inicial**: Visualize todos os produtos disponíveis
2. **Busca**: Use o campo de pesquisa para encontrar produtos específicos
3. **Favoritos**: Adicione produtos aos favoritos para acesso rápido
4. **Configurações**: Acesse configurações do aplicativo

### Visualização 3D
1. **Selecione um Produto**: Toque em um produto na lista
2. **Visualização 3D**: Toque no botão de visualização 3D
3. **Controles Interativos**:
   - **Zoom**: Use gestos de pinça ou botões +/-
   - **Rotação**: Arraste o dedo na tela
   - **Movimento**: Toque e arraste para mover a câmera

## 🔧 Configuração de Desenvolvimento

### Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto (se necessário):
```env
API_BASE_URL=https://api.exemplo.com
CAMERA_PERMISSION=true
```

### Debug e Logs
```bash
# Executar em modo debug
flutter run --debug

# Executar em modo release
flutter run --release

# Ver logs em tempo real
flutter logs
```

## 🐛 Solução de Problemas

### Problemas Comuns

#### 1. Erro de Dependências
```bash
flutter clean
flutter pub get
```

#### 2. Problemas com Câmera
- Verifique permissões no dispositivo
- Teste em dispositivo físico (não emulador)

#### 3. Modelos 3D não Carregam
- Verifique se os arquivos .obj e .mtl estão na pasta correta
- Confirme se as texturas estão referenciadas corretamente

#### 4. Performance Lenta
- Teste em dispositivo com mais recursos
- Reduza a qualidade das texturas
- Otimize os modelos 3D

### Logs de Debug
```dart
// Adicione logs para debug
print('Carregando modelo: ${widget.modelPath}');
```

## 📊 Bibliotecas Testadas e Resultados

### ✅ Funcionaram
- **flutter_cube**: Renderização 3D estável
- **camera**: Acesso à câmera funcional
- **font_awesome_flutter**: Ícones personalizados
- **url_launcher**: Abertura de links

### ❌ Não Funcionaram
- **model_viewer_plus**: Incompatibilidade com Flutter 3.7.0
- **ar_core**: Problemas de configuração Android

## 🤝 Contribuição

### Como Contribuir
1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Padrões de Código
- Use Dart/Flutter linting
- Siga as convenções de nomenclatura
- Documente funções complexas
- Mantenha a estrutura modular

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe

- **Equipe de Desenvolvimento** - Colaboradores
- **Yann Torres**
- **Luiz Felipe Medeiros**
- **Lucas Tucunduva**
- **Raphael Loureiro**
- **Thaynara Damazio**
- **Thamirys Pinheiro**
- **Eduardo Guarilha**

## 📞 Suporte

Para suporte e dúvidas:
- Abra uma [Issue](https://github.com/YannTorres/projeto_mobile_faculdade/issues)
- Entre em contato com a equipe de desenvolvimento

## 🔄 Changelog

### v1.0.0 (2024)
- ✅ Implementação inicial do projeto
- ✅ Visualização 3D funcional
- ✅ Sistema de favoritos
- ✅ Interface responsiva
- ✅ Integração com câmera

---

**⭐ Se este projeto foi útil, considere dar uma estrela no repositório!**
