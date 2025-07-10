# 🛋️ Shop AR - Aplicativo de Móveis com Realidade Aumentada

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![Model Viewer Plus](https://img.shields.io/badge/ModelViewer-1.9.3+-green.svg)](https://pub.dev/packages/model_viewer_plus)

## 📱 Descrição

O **Shop AR** é um aplicativo mobile desenvolvido em Flutter que permite aos usuários visualizar móveis em realidade aumentada (AR) antes de fazer uma compra. O app oferece uma experiência imersiva onde os clientes podem posicionar móveis virtuais em seus ambientes reais, facilitando a tomada de decisão na hora de decorar ou mobiliar espaços.

## ✨ Funcionalidades

### 🏠 **Tela Inicial**
- Interface moderna com gradiente visual
- Destaque para produtos em promoção
- Seção de novidades com cards interativos
- Navegação intuitiva para o catálogo

### 📚 **Catálogo de Produtos**
- Grid responsivo com produtos
- Informações detalhadas de cada móvel
- Preços e descrições completas
- Botão "Ver em AR" para cada produto

### 🔍 **Detalhes do Produto**
- Visualização em alta resolução
- Especificações técnicas detalhadas
- Sistema de abas (Descrição/Especificação)
- Integração direta com visualização AR

### 🥽 **Realidade Aumentada**
- Visualização 3D interativa de móveis
- Suporte completo a modelos GLB
- Controles de câmera e rotação automática
- Modo AR com Scene Viewer
- Interface responsiva e intuitiva

### 🔐 **Sistema de Login**
- Autenticação simples para demonstração
- Interface elegante com validação
- Transições suaves entre telas

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.7.2+** - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **Model Viewer Plus 1.9.3+** - Visualização 3D e AR para modelos GLB
- **Google Fonts 6.2.1+** - Tipografia personalizada
- **Vector Math 2.1.0+** - Matemática 3D para manipulação de modelos
- **Cupertino Icons 1.0.8+** - Ícones nativos do iOS

## 📋 Pré-requisitos

- Flutter SDK 3.7.2 ou superior
- Dart SDK 3.0 ou superior
- Android Studio / VS Code
- Dispositivo Android
- Google Play Services atualizado

## 🚀 Instalação

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/shop_ar.git
cd shop_ar
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Configure o dispositivo
- Conecte um dispositivo Android
- Ou configure um emulador (sem funcionalidade AR)

### 4. Execute o aplicativo
```bash
flutter run
```

## 📱 Como Usar

### Login
- **Email:** `admin@admin.com`
- **Senha:** `123456`

### Navegação
1. **Tela Inicial:** Visualize produtos em destaque e novidades
2. **Catálogo:** Acesse a lista completa de móveis
3. **Detalhes:** Toque em um produto para ver informações completas
4. **AR:** Use o botão "Ver em AR" para visualizar o móvel em realidade aumentada

### Realidade Aumentada
1. Toque no botão "Ver em AR" de qualquer produto
2. O modelo 3D será carregado em uma visualização interativa
3. Use os controles de câmera para explorar o modelo
4. Ative o modo AR para visualizar no seu ambiente real
5. Interaja com o modelo usando gestos de toque

## 📁 Estrutura do Projeto

```
shop_ar/
├── lib/
│   ├── Controllers/
│   │   └── login_controller.dart      # Lógica de autenticação
│   ├── Pages/
│   │   ├── ar_view_page.dart         # Visualização AR
│   │   ├── catalog_page.dart         # Catálogo de produtos
│   │   ├── home_page.dart            # Tela inicial
│   │   ├── login_page.dart           # Tela de login
│   │   ├── main_screen.dart          # Navegação principal
│   │   └── product_detail_page.dart  # Detalhes do produto
│   ├── app_colors.dart               # Paleta de cores
│   └── main.dart                     # Ponto de entrada
├── assets/
│   ├── images/                       # Imagens dos produtos
│   └── models/                       # Modelos 3D (GLB)
├── android/                          # Configurações Android
├── ios/                             # Configurações iOS
└── pubspec.yaml                     # Dependências do projeto
```

## 🎨 Design System

### Paleta de Cores
- **Primary:** `#8C5E3C` (Marrom principal)
- **Accent:** `#6A7BA2` (Azul)
- **Background:** `#F8F3ED` (Fundo claro)
- **Card:** `#C8B3A6` (Bege)

### Tipografia
- **Fonte Principal:** Poppins (Google Fonts)
- **Pesos:** Regular, Medium, Bold

## 📦 Produtos Disponíveis

| Produto | Preço | Modelo 3D |
|---------|-------|-----------|
| Cadeira Moderna | R$ 299,90 | ✅ |
| Sofá 3 Lugares | R$ 1.299,90 | ✅ |
| Armário Moderno | R$ 1.100,00 | ✅ |
| Mesa de Centro | R$ 350,00 | ✅ |
| Poltrona | R$ 2.300,00 | ✅ |

> **Nota:** Todos os produtos possuem modelos 3D em formato GLB para visualização AR

## 🔧 Configuração de Desenvolvimento

### Adicionando Novos Produtos
1. Adicione a imagem em `assets/images/`
2. Adicione o modelo 3D em `assets/models/` (formato GLB)
3. Atualize a lista de produtos em `catalog_page.dart`
4. Certifique-se de que o modelo GLB é compatível com Model Viewer Plus

### Plugins e Dependências
- **Model Viewer Plus:** Para visualização 3D e AR
- **Google Fonts:** Para tipografia personalizada
- **Vector Math:** Para manipulação matemática 3D
- **Cupertino Icons:** Para ícones nativos

### Personalizando Cores
Edite o arquivo `lib/app_colors.dart` para modificar a paleta de cores do aplicativo.

## 🐛 Solução de Problemas

### Visualização 3D/AR não funciona
- Verifique se o dispositivo suporta WebGL
- Certifique-se de que o Google Play Services está atualizado
- Teste em um dispositivo físico (emuladores podem ter limitações)
- Verifique se os modelos GLB estão no formato correto

### Erro de dependências
```bash
flutter clean
flutter pub get
```

### Problemas de compilação
```bash
flutter doctor
flutter pub deps
```

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request


⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!