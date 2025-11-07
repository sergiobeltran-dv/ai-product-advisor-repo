# Backend Setup Guide

This guide will help you set up and run the AI Product Advisor backend API locally and connect it to your frontend.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Connecting Frontend to Backend](#connecting-frontend-to-backend)
- [API Endpoints](#api-endpoints)
- [Environment Variables](#environment-variables)
- [Development](#development)
- [Deployment](#deployment)

## Prerequisites

- Python 3.11 or higher
- pip (Python package manager)
- Git

## Quick Start

### 1. Install Dependencies

```bash
# Navigate to backend directory
cd backend

# Create virtual environment (recommended)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install requirements
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
# Copy example environment file
cp .env.example .env

# Edit .env file if needed (optional for local development)
```

### 3. Start the Server

```bash
# Run the development server
python app.py
```

The API will be available at:
- **API Server**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/api/health

## Connecting Frontend to Backend

### Option 1: React (Create React App / Vite)

#### Install Axios

```bash
cd frontend
npm install axios
```

#### Create API Service

Create `frontend/src/services/api.js`:

```javascript
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Chat API
export const sendChatMessage = async (message, conversationId = null) => {
  const response = await api.post('/api/chat', {
    message,
    conversation_id: conversationId,
  });
  return response.data;
};

// Search API
export const searchProducts = async (query, limit = 10) => {
  const response = await api.post('/api/search', {
    query,
    limit,
  });
  return response.data;
};

// Get Product Details
export const getProduct = async (productId) => {
  const response = await api.get(`/api/products/${productId}`);
  return response.data;
};

// Health Check
export const checkHealth = async () => {
  const response = await api.get('/api/health');
  return response.data;
};

export default api;
```

#### Example React Component

```javascript
import React, { useState } from 'react';
import { sendChatMessage, searchProducts } from './services/api';

function App() {
  const [message, setMessage] = useState('');
  const [response, setResponse] = useState('');
  const [products, setProducts] = useState([]);

  const handleChat = async () => {
    try {
      const result = await sendChatMessage(message);
      setResponse(result.response);
    } catch (error) {
      console.error('Chat error:', error);
    }
  };

  const handleSearch = async () => {
    try {
      const result = await searchProducts(message);
      setProducts(result.products);
    } catch (error) {
      console.error('Search error:', error);
    }
  };

  return (
    <div>
      <input
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        placeholder="Enter message or search query"
      />
      <button onClick={handleChat}>Send Chat</button>
      <button onClick={handleSearch}>Search Products</button>

      {response && <div>Response: {response}</div>}

      {products.length > 0 && (
        <div>
          <h3>Products:</h3>
          {products.map(p => (
            <div key={p.id}>{p.name} - ${p.price}</div>
          ))}
        </div>
      )}
    </div>
  );
}

export default App;
```

#### Environment Variables (Frontend)

Create `frontend/.env.local`:

```env
REACT_APP_API_URL=http://localhost:8000
# Or for Vite:
VITE_API_URL=http://localhost:8000
```

### Option 2: Using Fetch API (No Dependencies)

```javascript
// frontend/src/services/api.js
const API_BASE_URL = 'http://localhost:8000';

export const sendChatMessage = async (message, conversationId = null) => {
  const response = await fetch(`${API_BASE_URL}/api/chat`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message,
      conversation_id: conversationId,
    }),
  });

  if (!response.ok) {
    throw new Error('Chat request failed');
  }

  return await response.json();
};

export const searchProducts = async (query, limit = 10) => {
  const response = await fetch(`${API_BASE_URL}/api/search`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query, limit }),
  });

  if (!response.ok) {
    throw new Error('Search request failed');
  }

  return await response.json();
};
```

### Option 3: Using Frontend Proxy (Development)

If you're using Vite, configure proxy in `vite.config.ts`:

```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      }
    }
  }
})
```

Then in your frontend, you can use relative URLs:

```javascript
// No need to specify full URL
const response = await fetch('/api/chat', {
  method: 'POST',
  // ...
});
```

## API Endpoints

### Health Check

**GET** `/api/health`

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-07T10:30:00Z",
  "version": "0.1.0",
  "services": {
    "api": "healthy",
    "openai": "not_configured",
    "search": "not_configured",
    "cosmos_db": "not_configured"
  }
}
```

### Chat

**POST** `/api/chat`

**Request:**
```json
{
  "message": "I need an oscilloscope for high-frequency testing",
  "conversation_id": "conv_12345" // optional
}
```

**Response:**
```json
{
  "response": "I recommend the Tektronix MSO64...",
  "conversation_id": "conv_12345",
  "timestamp": "2024-01-07T10:30:00Z"
}
```

### Search Products

**POST** `/api/search`

**Request:**
```json
{
  "query": "oscilloscope",
  "limit": 10
}
```

**Response:**
```json
{
  "products": [
    {
      "id": "PROD-001",
      "name": "Oscilloscope - Tektronix MSO64",
      "category": "Test Equipment",
      "description": "6 Series Mixed Signal Oscilloscope...",
      "price": 15000.00,
      "availability": "In Stock"
    }
  ],
  "total": 1,
  "query": "oscilloscope"
}
```

### Get Product Details

**GET** `/api/products/{product_id}`

**Response:**
```json
{
  "id": "PROD-001",
  "name": "Oscilloscope - Tektronix MSO64",
  "category": "Test Equipment",
  "description": "6 Series Mixed Signal Oscilloscope...",
  "price": 15000.00,
  "availability": "In Stock"
}
```

## Environment Variables

The backend uses environment variables for configuration. Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

### Local Development

For local development, you don't need to configure Azure services. The API will work with mock data.

### Production Configuration

When deploying to Azure, configure these environment variables:

- `AZURE_OPENAI_ENDPOINT` - Your Azure OpenAI endpoint
- `AZURE_OPENAI_KEY` - Azure OpenAI API key
- `AZURE_SEARCH_ENDPOINT` - Azure AI Search endpoint
- `AZURE_SEARCH_KEY` - Azure AI Search API key
- `COSMOS_DB_ENDPOINT` - Cosmos DB endpoint
- `COSMOS_DB_KEY` - Cosmos DB key

## Development

### Interactive API Documentation

FastAPI automatically generates interactive API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Running Tests

```bash
# Install dev dependencies
pip install pytest pytest-asyncio

# Run tests
pytest
```

### Code Formatting

```bash
# Install formatting tools
pip install black flake8

# Format code
black .

# Lint code
flake8 .
```

## Deployment

### Azure Functions Deployment

To deploy this API to Azure Functions:

1. **Convert to Azure Functions structure** (future task)
2. **Configure Application Settings** in Azure Portal
3. **Deploy using Azure DevOps pipeline** (configured in `.azuredevops/`)

### Docker Deployment (Alternative)

Create `Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "app.py"]
```

Build and run:

```bash
docker build -t ai-product-advisor-api .
docker run -p 8000:8000 ai-product-advisor-api
```

## Troubleshooting

### CORS Errors

If you see CORS errors in the browser console:

1. Make sure your frontend URL is in the `allow_origins` list in `app.py`
2. Or add it to the `CORS_ORIGINS` environment variable

### Port Already in Use

If port 8000 is already in use:

```bash
# Change port in .env file
PORT=8001

# Or run directly with different port
PORT=8001 python app.py
```

### Module Not Found Errors

Make sure you've activated the virtual environment and installed dependencies:

```bash
# Activate venv
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

## Next Steps

1. **Integrate Azure OpenAI** - Replace mock responses with actual AI chat
2. **Add Azure AI Search** - Implement semantic product search
3. **Implement Cosmos DB** - Store conversation history
4. **Add Redis Cache** - Cache common queries
5. **Add Authentication** - Implement Azure AD B2C
6. **Add Logging** - Integrate with Application Insights

## Support

For issues or questions:
- Check the interactive docs at `/docs`
- Review the health check at `/api/health`
- Check backend logs in the console
