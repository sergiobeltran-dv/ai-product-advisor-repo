# Backend Application

This directory will contain the backend application code for the AI Product Advisor.

## Planned Structure

```
backend/
├── function-app/              # Azure Functions (API endpoints)
│   ├── functions/
│   │   ├── chat/             # Chat endpoint
│   │   ├── search/           # Search endpoint
│   │   └── health/           # Health check
│   ├── requirements.txt
│   ├── host.json
│   └── local.settings.json
├── shared/                    # Shared utilities
│   ├── ai_services/          # OpenAI, Search clients
│   ├── data_access/          # Cosmos DB, Redis clients
│   └── utils/
└── tests/                     # Unit and integration tests
```

## Technology Stack

- **Runtime**: Python 3.11
- **Framework**: Azure Functions
- **AI Services**: 
  - Azure OpenAI (GPT-4, GPT-3.5, Embeddings)
  - Azure AI Search (RAG pattern)
- **Data Storage**:
  - Cosmos DB (chat history, audit logs)
  - Redis Cache (semantic cache)
  - Storage Account (document storage)

## Development Setup

_To be documented when backend development begins_

```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
func start
```

## Environment Variables

Required environment variables (stored in Azure App Configuration or Function App Settings):

```
AZURE_OPENAI_ENDPOINT=
AZURE_OPENAI_KEY=           # Or use Managed Identity
AZURE_SEARCH_ENDPOINT=
AZURE_SEARCH_KEY=           # Or use Managed Identity
COSMOS_DB_ENDPOINT=
COSMOS_DB_KEY=              # Or use Managed Identity
REDIS_HOST=
REDIS_KEY=                  # Or use Managed Identity
```

## Deployment

Deployment is handled via Azure DevOps pipelines in `.azuredevops/pipelines/`

```bash
# Manual deployment (if needed)
func azure functionapp publish <function-app-name>
```

## Testing

```bash
# Run unit tests
pytest tests/unit

# Run integration tests
pytest tests/integration
```

## API Endpoints

_To be documented_

- `POST /api/chat` - Chat endpoint
- `GET /api/search` - Search endpoint
- `GET /api/health` - Health check

## Contributing

_Team guidelines to be added_

