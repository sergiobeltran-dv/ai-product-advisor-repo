"""
AI Product Advisor - Minimal Backend API
FastAPI application for product search and chat functionality
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI(
    title="AI Product Advisor API",
    description="Backend API for ElectroRent AI Product Advisor",
    version="0.1.0"
)

# CORS middleware - configure for your frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",      # React dev server
        "http://localhost:5173",      # Vite dev server
        "http://localhost:8080",      # Alternative dev server
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================================
# Request/Response Models
# ============================================================================

class ChatMessage(BaseModel):
    message: str
    conversation_id: Optional[str] = None


class ChatResponse(BaseModel):
    response: str
    conversation_id: str
    timestamp: str


class ProductSearchRequest(BaseModel):
    query: str
    limit: int = 10


class Product(BaseModel):
    id: str
    name: str
    category: str
    description: str
    price: float
    availability: str


class ProductSearchResponse(BaseModel):
    products: List[Product]
    total: int
    query: str


class HealthResponse(BaseModel):
    status: str
    timestamp: str
    version: str
    services: dict


# ============================================================================
# API Endpoints
# ============================================================================

@app.get("/", tags=["Root"])
async def root():
    """Root endpoint with API information"""
    return {
        "name": "AI Product Advisor API",
        "version": "0.1.0",
        "status": "running",
        "docs": "/docs",
        "health": "/api/health"
    }


@app.get("/api/health", response_model=HealthResponse, tags=["Health"])
async def health_check():
    """
    Health check endpoint
    Returns the status of the API and connected services
    """
    return HealthResponse(
        status="healthy",
        timestamp=datetime.utcnow().isoformat(),
        version="0.1.0",
        services={
            "api": "healthy",
            "openai": "not_configured" if not os.getenv("AZURE_OPENAI_ENDPOINT") else "configured",
            "search": "not_configured" if not os.getenv("AZURE_SEARCH_ENDPOINT") else "configured",
            "cosmos_db": "not_configured" if not os.getenv("COSMOS_DB_ENDPOINT") else "configured"
        }
    )


@app.post("/api/chat", response_model=ChatResponse, tags=["Chat"])
async def chat(message: ChatMessage):
    """
    Chat endpoint - Send a message and get AI response

    In production, this will:
    - Use Azure OpenAI for chat completion
    - Store conversation history in Cosmos DB
    - Use semantic cache (Redis) for common queries
    """

    # TODO: Integrate with Azure OpenAI
    # For now, return a mock response

    if not message.message:
        raise HTTPException(status_code=400, detail="Message cannot be empty")

    # Mock conversation ID
    conversation_id = message.conversation_id or f"conv_{datetime.utcnow().timestamp()}"

    # Mock AI response
    mock_response = (
        f"Thank you for your inquiry about '{message.message}'. "
        "This is a placeholder response. In production, this will be powered by "
        "Azure OpenAI with access to ElectroRent's product catalog."
    )

    return ChatResponse(
        response=mock_response,
        conversation_id=conversation_id,
        timestamp=datetime.utcnow().isoformat()
    )


@app.post("/api/search", response_model=ProductSearchResponse, tags=["Search"])
async def search_products(search: ProductSearchRequest):
    """
    Product search endpoint

    In production, this will:
    - Use Azure AI Search with semantic search
    - Return relevant products from the catalog
    - Use embeddings for semantic similarity
    """

    if not search.query:
        raise HTTPException(status_code=400, detail="Search query cannot be empty")

    # Mock product data
    mock_products = [
        Product(
            id="PROD-001",
            name="Oscilloscope - Tektronix MSO64",
            category="Test Equipment",
            description="6 Series Mixed Signal Oscilloscope, 1 GHz, 4 channels",
            price=15000.00,
            availability="In Stock"
        ),
        Product(
            id="PROD-002",
            name="Spectrum Analyzer - Keysight N9020B",
            category="RF Equipment",
            description="MXA Signal Analyzer, 50 GHz, Real-time spectrum analysis",
            price=45000.00,
            availability="Available in 2 weeks"
        ),
        Product(
            id="PROD-003",
            name="Power Supply - Keithley 2280S",
            category="Power Equipment",
            description="Programmable DC Power Supply, 60V, 3.2A, USB/LAN interfaces",
            price=2500.00,
            availability="In Stock"
        )
    ]

    # Filter products based on query (simple substring match for demo)
    filtered_products = [
        p for p in mock_products
        if search.query.lower() in p.name.lower() or
           search.query.lower() in p.description.lower()
    ]

    # If no matches, return all products
    if not filtered_products:
        filtered_products = mock_products

    # Limit results
    filtered_products = filtered_products[:search.limit]

    return ProductSearchResponse(
        products=filtered_products,
        total=len(filtered_products),
        query=search.query
    )


@app.get("/api/products/{product_id}", response_model=Product, tags=["Products"])
async def get_product(product_id: str):
    """
    Get product details by ID

    In production, this will query the product database
    """

    # Mock product lookup
    mock_product = Product(
        id=product_id,
        name="Oscilloscope - Tektronix MSO64",
        category="Test Equipment",
        description="6 Series Mixed Signal Oscilloscope, 1 GHz, 4 channels. "
                   "Includes advanced triggering, protocol analysis, and spectrum view.",
        price=15000.00,
        availability="In Stock"
    )

    return mock_product


# ============================================================================
# Development Server
# ============================================================================

if __name__ == "__main__":
    import uvicorn

    port = int(os.getenv("PORT", "8000"))

    print("\n" + "="*60)
    print("🚀 AI Product Advisor API Starting...")
    print("="*60)
    print(f"📍 Server: http://localhost:{port}")
    print(f"📚 API Docs: http://localhost:{port}/docs")
    print(f"🏥 Health Check: http://localhost:{port}/api/health")
    print("="*60 + "\n")

    uvicorn.run(
        "app:app",
        host="0.0.0.0",
        port=port,
        reload=True,  # Auto-reload on code changes
        log_level="info"
    )
