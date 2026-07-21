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

**Deploy infra (Bicep)**
- Use Azure CLI to deploy templates in `templates/bicep` (example):

```powershell
az deployment group create -g <resource-group> --template-file templates/bicep/main.bicep --parameters @templates/parameters/main.dev.bicepparam
```

Keep it short: see the code folders for implementation details and tweak parameters before deploying.

If you want, I can expand this README with examples, env vars, or CI/CD steps.