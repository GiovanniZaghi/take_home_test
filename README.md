# Take Home Test — Flutter

Aplicativo Flutter para encurtamento de URLs, desenvolvido como desafio técnico.

---

## Arquitetura

O projeto segue os princípios da **Clean Architecture**, dividida em três camadas bem definidas:

```
lib/
├── data/          # Fontes de dados, modelos, datasources e configuração HTTP
├── domain/        # Entidades, repositórios (contrato), casos de uso e falhas
└── presentation/  # Cubit, páginas e widgets
```

### Camadas

**Domain**
Camada mais interna e independente de frameworks. Define os contratos (`TakeHomeRepository`, `CreateAliasUseCase`), as entidades de negócio (`AliasEntity`) e o modelo de falha (`GenericFailure`). Nenhuma dependência externa.

**Data**
Implementa os contratos definidos no domain. Contém os modelos de resposta (`AliasModel`), os datasources (`TakeHomeDatasourceImpl`) e o repositório (`TakeHomeRepositoryImpl`). Também concentra toda a configuração de rede (`Networking`, `NetworkingImpl`, `HttpClient`).

**Presentation**
Gerencia estado via **Cubit** (flutter_bloc). A `TakeHomeCubit` recebe o caso de uso por injeção de dependência e expõe estados tipados para a UI.

### Injeção de dependência

Utiliza **flutter_modular**, que centraliza os binds em `TakeHomeBinds` e organiza as rotas em `TakeHomeRoutes`. O grafo de dependências segue a direção `Cubit → UseCase → Repository → Datasource → Networking`.

### Tratamento de erros

Adota **fpdart** com o tipo `Either<GenericFailure, T>` para representar sucesso e falha de forma explícita, sem depender de exceções para controle de fluxo nas camadas de domínio e apresentação.

---

## Por que Dio e não o pacote http?

| Critério | `http` | `Dio` |
|---|---|---|
| Interceptors | Não nativo | Nativo — usado para logging |
| Headers por requisição | Manual a cada chamada | Via `Options(headers: ...)` |
| Timeout global | Configuração manual | `BaseOptions` centralizado |
| Tratamento de erros | Exceções genéricas | `DioException` tipado com resposta, status e tipo de erro |
| Multipart / upload | Trabalhoso | Suporte nativo |

O `http` é suficiente para casos simples, mas o Dio entrega interceptors, configuração centralizada de timeout, headers por requisição e erros tipados sem boilerplate adicional — o que torna a camada de rede mais fácil de manter e estender.

---

## Como rodar

1. Copie o arquivo de variáveis de ambiente:
   ```bash
   cp .env.example .env
   ```
2. Preencha `BASE_URL` no `.env`.
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o app:
   ```bash
   flutter run
   ```
