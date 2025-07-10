# Lições Aprendidas - Projeto Mobile Faculdade

## Resumo Executivo

Este documento apresenta as lições aprendidas durante o desenvolvimento do projeto "Lojinha do Zezé", uma aplicação móvel desenvolvida em Flutter que implementa funcionalidades de visualização 3D e realidade aumentada para produtos de e-commerce.

## Tecnologias e Plataformas Utilizadas

### Plataforma Principal
- **Flutter**: Framework de desenvolvimento multiplataforma da Google
- **Dart**: Linguagem de programação utilizada pelo Flutter
- **Android Studio / VS Code**: IDEs utilizados para desenvolvimento
- **Git**: Controle de versão

### Bibliotecas que Funcionaram
- **flutter_cube**: Biblioteca para renderização de modelos 3D (.obj e .mtl)
- **camera**: Plugin para acesso à câmera do dispositivo
- **font_awesome_flutter**: Ícones personalizados
- **url_launcher**: Abertura de links externos

## O que Deu Certo

### 1. Arquitetura e Estrutura do Projeto
- **Organização modular**: Separação clara entre screens, widgets, models e assets
- **Padrão StatefulWidget**: Implementação adequada para gerenciamento de estado
- **Navegação eficiente**: Uso de IndexedStack para manter estado das páginas
- **Componentes reutilizáveis**: Criação de widgets customizados (ProductCard, CustomAppBar)

### 2. Funcionalidades Implementadas com Sucesso
- **Visualização 3D**: Renderização de modelos .obj com texturas
- **Controles interativos**: Zoom, rotação e movimento do modelo 3D
- **Interface responsiva**: Layout adaptável com GridView
- **Sistema de favoritos**: Gerenciamento de produtos favoritos
- **Busca de produtos**: Campo de pesquisa funcional

### 3. Gestão de Assets
- **Organização de modelos 3D**: Estrutura adequada para arquivos .obj e .mtl
- **Texturas**: Implementação correta de mapas de textura (Albedo, Normal, Metallic, etc.)
- **Imagens**: Assets organizados por categoria

## O que Deu Errado

### 1. Bibliotecas de Realidade Aumentada
**Problemas identificados:**
- **model_viewer_plus**: Incompatibilidade com versões mais recentes do Flutter
- **ar_core**: Dependências complexas e problemas de configuração no Android

**Lições aprendidas:**
- Sempre verificar compatibilidade de versões antes de implementar
- Testar bibliotecas em dispositivos físicos, não apenas emuladores
- Manter backup de versões funcionais das dependências

### 2. Desafios Técnicos
- **Performance**: Renderização 3D pode ser lenta em dispositivos menos potentes
- **Compatibilidade**: Diferentes comportamentos entre versões do Android
- **Tamanho do app**: Modelos 3D aumentam significativamente o tamanho do aplicativo

## Estratégias de Contingência Implementadas

### 1. Alternativa para Realidade Aumentada
Devido aos problemas com bibliotecas nativas de AR, optamos por:
- **Visualização 3D sobreposta**: Combinação de feed da câmera com modelo 3D
- **Controles touch**: Implementação de gestos para interação com o modelo
- **Flutter Cube**: Biblioteca mais estável para renderização 3D

### 2. Otimizações de Performance
- **Lazy loading**: Carregamento sob demanda dos modelos 3D
- **Compressão de texturas**: Redução do tamanho dos arquivos de textura
- **Cache de modelos**: Armazenamento local para carregamento mais rápido

## Lições para Trabalho em Equipe

### 1. Comunicação e Documentação
- **Documentação de decisões**: Registro de escolhas técnicas e suas justificativas
- **Compartilhamento de conhecimento**: Sessões de code review e pair programming
- **Versionamento**: Uso adequado de branches e commits descritivos

### 2. Gestão de Dependências
- **Teste precoce**: Validação de bibliotecas no início do projeto
- **Planos de contingência**: Alternativas preparadas para tecnologias problemáticas
- **Monitoramento de atualizações**: Acompanhamento de mudanças nas dependências

### 3. Desenvolvimento Iterativo
- **MVP primeiro**: Implementação de funcionalidades básicas antes de recursos avançados
- **Testes contínuos**: Validação em diferentes dispositivos e versões
- **Feedback rápido**: Ciclos curtos de desenvolvimento e teste

## Recomendações para Projetos Futuros

### 1. Escolha de Tecnologias
- **Pesquisa extensiva**: Avaliar múltiplas opções antes de decidir
- **Prototipagem**: Criar POCs para validar funcionalidades críticas
- **Comunidade**: Verificar suporte e documentação das bibliotecas

### 2. Arquitetura
- **Modularidade**: Manter separação clara de responsabilidades
- **Testabilidade**: Estruturar código para facilitar testes
- **Escalabilidade**: Planejar crescimento futuro do projeto

### 3. Gestão de Projeto
- **Cronograma realista**: Considerar tempo para resolução de problemas técnicos
- **Recursos adequados**: Alocar tempo para pesquisa e experimentação
- **Comunicação clara**: Estabelecer canais eficientes de comunicação na equipe

## Conclusão

O projeto demonstrou a importância de uma abordagem pragmática no desenvolvimento mobile. Apesar dos desafios com bibliotecas de realidade aumentada, conseguimos entregar uma solução funcional e inovadora. As lições aprendidas serão valiosas para projetos futuros, especialmente no que diz respeito à escolha de tecnologias e gestão de dependências.

A experiência reforçou a necessidade de flexibilidade e adaptabilidade no desenvolvimento de software, onde soluções alternativas podem ser tão eficazes quanto as abordagens inicialmente planejadas. 