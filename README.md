# CyberShield app

CyberShield

## Visão Geral

Este README reúne os comandos essenciais do Flutter CLI, desde a verificação do ambiente até a
geração de builds otimizados para produção, passando pelo gerenciamento de dependências, limpeza de
builds e criação de projetos.

## 1. Verificação do Ambiente

### `flutter doctor`

Valida a instalação do Flutter e de todas as dependências necessárias, sinalizando o que está
faltando ou configurado corretamente.

```bash
flutter doctor
````

## 2. Gerenciamento de Dependências

### `flutter pub get`

Obtém todas as dependências listadas no `pubspec.yaml` e bloqueia as versões no `pubspec.lock` para
reprodutibilidade.

```bash
flutter pub get
```

### `flutter pub add <nome_do_pacote>`

Adiciona um novo pacote que esteja no site `https://pub.dev/` ao `pubspec.yaml` e atualiza
automaticamente o `pubspec.lock`.

```bash
flutter pub add http
```

## 3. Limpeza de Builds

### `flutter clean`

Remove os diretórios de build e `.dart_tool`, garantindo que o próximo build seja executado do zero.

```bash
flutter clean
```

## 4. Builds e Execução

### `flutter build apk --release`

Gera um APK otimizado para produção, com tree shaking e sem ferramentas de depuração.

```bash
flutter build apk --release
```

### `flutter run --release`

Compila e executa o app no modo release na web e rode-o dentro de um servidor web (nginx, python e
etc).

```bash
flutter build web --release
```

```bash
python -m http.server 8000
```

## 5. Atualização do SDK

### `flutter upgrade`

Atualiza o Flutter SDK para a versão mais recente disponível no canal atual.

```bash
flutter upgrade
```

## 6. Criação de Projetos

### `flutter create <nome_do_projeto>`

Cria um novo projeto Flutter com estrutura básica e arquivos iniciais.

```bash
flutter create my_app
```

## 7. Outros Comandos Úteis

* **`flutter analyze`**: Analisa o código em busca de erros e avisos.
* **`flutter test`**: Executa testes automatizados.
* **`flutter pub outdated`**: Verifica pacotes desatualizados.
* **`flutter format .`**: Formata todo o código Dart segundo padrão oficial.
* **`flutter doctor --android-licenses`**: Aceita as licenças do Android SDK.
* **`flutter run -d all`**: Roda a aplicação em todos os dispositivos conectados.

## 8. Dicas e Boas Práticas

* Use o **Hot Reload** para acelerar o ciclo de desenvolvimento e visualizar mudanças
  instantaneamente.
* Separe lógica de UI e de dados seguindo padrões como **MVVM**, melhorando a manutenção e
  testabilidade.

```