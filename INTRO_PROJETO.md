# 🧭 Roteiro de Explicação da Aplicação Flutter

## 1. Introdução

Flutter é um framework da Google para o desenvolvimento de aplicações multiplataforma (Android, iOS, Web, Desktop) com uma única base de código.

**Objetivo da aplicação:**  
Descrever o propósito principal da aplicação (ex: gerenciamento de tarefas, e-commerce, etc).

---

## 2. Estrutura Geral do Projeto

```
lib/
├── core/
│   ├── models/
│   ├── network/
│   ├── repositories/
│   └── services/
├── di/
│   └── di.dart
├── routes/
│   └── app_router.dart
├── ui/
│   ├── theme/
│   ├── viewmodels/
│   └── views/
├── utils/
│   └── snackbar_utils.dart
└── main.dart
```

---

## 3. `main.dart`

- Ponto de entrada da aplicação.
- Inicia o app com `runApp()`.
- Define o tema e as rotas iniciais.

---

## 4. `core/`

Contém a lógica central da aplicação:

- `models/`: Representações dos dados usados na aplicação (ex: Usuário, Produto).
- `network/`: Configuração de cliente HTTP, interceptadores e chamadas de API.
- `repositories/`: Abstração das fontes de dados (API, banco de dados local, etc.).
- `services/`: Regras de negócio que consomem os repositórios.

---

## 5. `di/`

- Arquivo `di.dart` para configuração da **injeção de dependência**.
- Usualmente utiliza pacotes como `get_it` ou `injectable`.
- Facilita o gerenciamento e reaproveitamento de instâncias.

---

## 6. `routes/`

- `app_router.dart`: Configura as rotas da aplicação.
- Permite navegar entre telas usando nomes definidos.
- Pode ser implementado com navegação manual ou com pacotes como `auto_route`.

---

## 7. `ui/`

Responsável pela construção da interface com o usuário:

- `theme/`: Definições de cores, tipografias e estilos visuais do app.
- `viewmodels/`: Lógica de estado da UI, usado com padrões como MVVM.
- `views/`: Telas e widgets visuais que compõem o layout da aplicação.

---

## 8. `utils/`

- Contém classes auxiliares reutilizáveis.
- Exemplo: `snackbar_utils.dart` centraliza a exibição de mensagens SnackBar para o usuário.

---

## 9. Fluxo de Dados

1. A **UI** chama métodos do **ViewModel**.
2. O ViewModel aciona um **Service**.
3. O Service chama um **Repository**.
4. O Repository acessa a **API** ou banco local.
5. O resultado volta em cadeia até a UI.
6. A UI atualiza os widgets com os dados recebidos.

---

## 10. Boas Práticas Aplicadas

- Separação de responsabilidades (Clean Architecture).
- Injeção de dependência para gerenciamento de instâncias.
- Modularização de funcionalidades.
- Código escalável, reutilizável e testável.
