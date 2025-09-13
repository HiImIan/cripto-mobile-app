# 🪙 BrasilCripto

App Flutter para acompanhar criptomoedas em tempo real usando a API CoinGecko.

## 📱 Download APK

[![Download APK](https://img.shields.io/badge/📱%20Download%20APK-v1.0.0-blue?style=for-the-badge&logo=android)](https://drive.google.com/file/d/1CiUYUwB5y0nJAcyS1BDLNa0fYDC-IXOP/view?usp=drive_link)

**Android 6.0+ | ~15MB**

## ✨ Funcionalidades

- 🔍 **Busca de Criptomoedas** - Pesquise por nome ou símbolo
- ⭐ **Lista de Favoritos** - Salve suas cryptos preferidas localmente  
- 📊 **Detalhes Completos** - Preço, volume, gráficos e descrição
- 📈 **Dados em Tempo Real** - Integração com CoinGecko API
- 🇧🇷 **Valores em Reais** - Preços convertidos para BRL
- 🌙 **Tema Escuro/Claro** - Interface adaptável

## 🛠️ Tecnologias

- **Flutter** 3.8+ | **Dart** 3.8+
- **MVVM** - Arquitetura limpa e escalável
- **Provider** - Gerenciamento de estado
- **Dio** - Requisições HTTP otimizadas
- **SharedPreferences** - Persistência local
- **CoinGecko API** - Dados de criptomoedas

## 🚀 Como executar

```bash
# Clone o repositório
git clone https://github.com/SEU_USUARIO/brasilcripto.git
cd brasilcripto

# Instale as dependências
flutter pub get

# Execute o app
flutter run

# Build APK
flutter build apk --release
```

## 📋 Funcionalidades Implementadas

### ✅ Requisitos Atendidos
- [x] **Pesquisa** - Campo de busca por nome/símbolo
- [x] **Favoritos** - Adicionar/remover com persistência local
- [x] **Detalhes** - Tela completa com gráficos e informações
- [x] **API Integration** - CoinGecko com tratamento de erros
- [x] **Performance** - Lazy loading e cache de dados
- [x] **Segurança** - Validação de inputs e sanitização

## 🔧 Padrões Utilizados

- **Repository Pattern** - Abstração da camada de dados
- **Singleton** - Instância única do cliente HTTP
- **Factory** - Criação de objetos crypto
- **Observer** - Provider para mudanças de estado
- **SOLID Principles** - Código limpo e manutenível

## 🌐 API

**CoinGecko API** - Dados gratuitos e confiáveis
- Preços em tempo real
- Histórico de 7 dias
- Volume e market cap
- Informações detalhadas

## 🤝 Contribuindo

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request
   
---

**Desenvolvido com ❤️ Flutter | Dados por CoinGecko**
