# 🚀 Guia de Instalação - Lojinha do Zezé

## 📋 Pré-requisitos

### 1. Flutter SDK
- **Versão**: 3.7.0 ou superior
- **Download**: https://docs.flutter.dev/get-started/install

```bash
# Verificar versão do Flutter
flutter --version
```

### 2. Dart SDK
- **Versão**: 3.0.0 ou superior
- **Incluído**: Vem junto com o Flutter

```bash
# Verificar versão do Dart
dart --version
```

### 3. IDE
- **Android Studio** (recomendado)
- **VS Code** com extensões Flutter/Dart

### 4. Dispositivo/Emulador
- **Android**: API Level 21+ (Android 5.0+)
- **Dispositivo físico** (recomendado para testar câmera)

## 🔧 Instalação Passo a Passo

### Passo 1: Clone do Repositório

```bash
# Clone o repositório
git clone https://github.com/YannTorres/projeto_mobile_faculdade.git

# Entre na pasta do projeto
cd projeto_mobile_faculdade
```

### Passo 2: Verificação do Ambiente

```bash
# Verificar se tudo está configurado corretamente
flutter doctor
```

**Resolva qualquer problema indicado pelo `flutter doctor` antes de continuar.**

### Passo 3: Instalação de Dependências

```bash
# Instalar todas as dependências do projeto
flutter pub get
```

### Passo 4: Configurações Específicas por Plataforma

#### Para Android:

1. **Verificar build.gradle.kts**:
   ```kotlin
   // android/app/build.gradle.kts
   android {
       compileSdkVersion 34
       defaultConfig {
           minSdkVersion 21  // Importante para compatibilidade
           targetSdkVersion 34
       }
   }
   ```

2. **Permissões já configuradas** no `AndroidManifest.xml`:
   - Câmera
   - Internet
   - Armazenamento



### Passo 5: Execução do Projeto

#### Primeira Execução:

```bash
# Listar dispositivos disponíveis
flutter devices

# Executar no dispositivo/emulador desejado
flutter run
```

#### Comandos Úteis:

```bash
# Executar em modo debug
flutter run --debug

# Executar em modo release
flutter run --release

# Executar em dispositivo específico
flutter run -d <device-id>

# Hot reload (durante desenvolvimento)
# Pressione 'r' no terminal
```

## 🐛 Solução de Problemas Comuns

### 1. Erro: "No supported devices connected"

**Solução:**
```bash
# Verificar dispositivos
flutter devices

# Se não houver dispositivos:
# - Conecte um dispositivo físico via USB
# - Ou inicie um emulador Android
# - Ou inicie o iOS Simulator
```

### 2. Erro: "Dependencies failed to resolve"

**Solução:**
```bash
# Limpar cache
flutter clean

# Reinstalar dependências
flutter pub get

# Verificar pubspec.yaml
flutter pub deps
```

### 3. Erro: "Camera permission denied"

**Solução:**
- **Android**: Vá em Configurações > Apps > Lojinha do Zezé > Permissões > Câmera

### 4. Erro: "3D models not loading"

**Solução:**
```bash
# Verificar se os arquivos estão na pasta correta
ls lib/assets/3d_models/

# Verificar estrutura:
# lib/assets/3d_models/
# ├── model.obj
# ├── model.mtl
# ├── old_chair.obj
# ├── old_chair.mtl
# └── texturas/
```

### 5. Performance Lenta

**Soluções:**
- Teste em dispositivo físico (não emulador)
- Reduza a qualidade das texturas
- Feche outros aplicativos
- Reinicie o dispositivo

## 📱 Testando Funcionalidades

### 1. Navegação Básica
- ✅ Tela inicial com produtos
- ✅ Busca de produtos
- ✅ Sistema de favoritos
- ✅ Configurações

### 2. Visualização 3D
- ✅ Carregamento de modelos 3D
- ✅ Controles de zoom (+/-)
- ✅ Rotação do modelo
- ✅ Movimento da câmera

### 3. Câmera e AR
- ✅ Acesso à câmera
- ✅ Feed da câmera em tempo real
- ✅ Modelo 3D sobreposto
- ✅ Controles touch

## 🔍 Verificação de Instalação

### Checklist de Verificação:

- [ ] Flutter SDK instalado e configurado
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] Dispositivo/emulador conectado
- [ ] Aplicativo executa sem erros
- [ ] Tela inicial carrega corretamente
- [ ] Produtos são exibidos
- [ ] Visualização 3D funciona
- [ ] Câmera funciona (em dispositivo físico)
- [ ] Controles touch respondem

### Comandos de Verificação:

```bash
# Verificar ambiente
flutter doctor -v

# Verificar dependências
flutter pub deps

# Verificar dispositivos
flutter devices

# Testar build
flutter build apk --debug
```

## 📞 Suporte

### Se encontrar problemas:

1. **Verifique os logs**:
   ```bash
   flutter logs
   ```

2. **Abra uma issue** no GitHub:
   https://github.com/YannTorres/projeto_mobile_faculdade/issues

3. **Consulte a documentação**:
   - [README.md](README.md)
   - [LICOES_APRENDIDAS.md](LICOES_APRENDIDAS.md)
   - [REDMINE_PROJECT_INFO.md](REDMINE_PROJECT_INFO.md)

### Recursos Úteis:

- **Flutter Documentation**: https://docs.flutter.dev/
- **Dart Documentation**: https://dart.dev/guides
- **Flutter Community**: https://flutter.dev/community

---

**✅ Se chegou até aqui, o projeto está instalado e funcionando corretamente!**

**🎉 Parabéns! Você pode agora explorar a Lojinha do Zezé com todas as suas funcionalidades 3D e AR.** 