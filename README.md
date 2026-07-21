# git-autodilab
Lightweight workspace with an ASP.NET Core Cosmos DB API, an Azure Functions worker, and Bicep infra templates.

**What it contains:**
- `sounak-cosmos-api`: ASP.NET Core Web API (Cosmos DB-backed) exposing test-case read endpoints.
- `sounak_update_testcase`: .NET Azure Functions isolated worker (uses Event Hubs / HttpClient policies).
- `templates/bicep`: Bicep modules and parameter files to deploy infra (Function App, Storage, Cosmos DB, Event Hub, etc.).

**Quick start (local)**
- Prereqs: .NET 10 SDK, Azure CLI (for infra), Azure Functions Core Tools (for functions).
- Run the API:

```powershell
cd sounak-cosmos-api
dotnet restore
dotnet run
```

- Run the Functions app (recommended with Functions Core Tools):

```powershell
cd sounak_update_testcase
func start
```

Configuration: update `sounak-cosmos-api/appsettings.json` or set environment variables for Cosmos DB connection; update `sounak_update_testcase/local.settings.json` for function-local settings.

**Deploy infra (GitHub Actions)**
- The repo uses GitHub Actions workflows in `.github/workflows/` for deployment.
- Key workflows:
  - `deploy-bicep-pipeline.yml` — deploys the main Bicep infra.
  - `deploy-cosmosbicep-pipeline.yml` — deploys Cosmos DB resources and updates Function App settings.
  - `deploy-eventhub-pipeline.yml` — deploys Event Hub resources and updates Function App settings.
- All workflows are set up for `workflow_dispatch`, so they can be triggered manually from the GitHub Actions UI.

**Workflow requirements**
- Repository variables required for OIDC login: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`.
- Resource group and parameter values are configured in `templates/bicep` and the `.dev.bicepparam` files.

Keep it short: see the code folders for implementation details and tweak parameters before deploying.