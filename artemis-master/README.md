# Artemis – Rede Social em Realidade Aumentada
**Artemis** é um aplicativo mobile criado com [Flutter](https://flutter.dev/) que combina **Realidade Aumentada (AR)** usando o [`ar_flutter_plugin`](https://pub.dev/packages/ar_flutter_plugin) com uma base de dados **PostgreSQL** acessada via backend **Django**.  

A proposta do projeto é permitir que usuários compartilhem, visualizem e interajam com conteúdos digitais posicionados no mundo real através da câmera do celular.

---
## Como Rodar o Projeto

### 1. Pré-requisitos
- Flutter instalado (versão estável mais recente)
- Android Studio ou IDE configurada para desenvolvimento Android
- Dispositivo físico compatível com ARCore (Android)

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Executar o Aplicativo
Conecte seu dispositivo e execute:

```bash
flutter run
```

## Configuração do Backend (Django + PostgreSQL)
Este projeto utiliza Django com Django REST Framework para fornecer uma API REST que conecta o app Flutter ao banco de dados PostgreSQL.

### 1. Pré-requisitos

- Python 3.10+
- PostgreSQL instalado

### 2. Instalar as dependências
```bash
pip install -r requirements.txt
```

### 3. Rodar o servidor local
```bash
python manage.py runserver
```
