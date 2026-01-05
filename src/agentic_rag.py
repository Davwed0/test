"""Agentic RAG system using PydanticAI and Langchain."""

from typing import List, Dict, Optional
from pydantic import BaseModel, Field
from pydantic_ai import Agent, RunContext
from pydantic_ai.models.openai import OpenAIModel
from pydantic_ai.models.ollama import OllamaModel
from langchain_qdrant import QdrantVectorStore
from langchain_core.documents import Document
from langchain.text_splitter import MarkdownHeaderTextSplitter
from qdrant_client import QdrantClient

from src.embeddings import EmbeddingGenerator
from src.qdrant_store import QdrantStore
from src.tax_classifier import TaxCategoryClassifier
from src.config import Config


class DocumentSearchResult(BaseModel):
    """Model for document search results."""
    content: str = Field(description="The content of the document chunk")
    filename: str = Field(description="The source filename")
    heading: str = Field(description="The section heading")
    relevance_score: float = Field(description="The relevance score")
    key_values: Dict[str, str] = Field(default_factory=dict, description="Extracted key-value pairs")
    deduction_categories: List[str] = Field(default_factory=list, description="Tax deduction categories")
    income_categories: List[str] = Field(default_factory=list, description="Income categories")


class TaxQueryResponse(BaseModel):
    """Model for the agent's response."""
    answer: str = Field(description="The detailed answer to the user's question")
    sources: List[str] = Field(description="List of source documents used")
    tax_categories: List[str] = Field(default_factory=list, description="Relevant tax categories identified")
    confidence: str = Field(description="Confidence level: high, medium, or low")


class AgenticDeps(BaseModel):
    """Dependencies for the agentic RAG system."""
    embedder: EmbeddingGenerator
    store: QdrantStore
    classifier: TaxCategoryClassifier


class AgenticRAG:
    """Agentic RAG system using PydanticAI for HK tax documents."""
    
    def __init__(self):
        """Initialize the Agentic RAG system."""
        print("Initializing Agentic RAG with PydanticAI...")
        
        # Initialize core components
        self.embedder = EmbeddingGenerator()
        self.store = QdrantStore(embedding_dim=self.embedder.get_embedding_dimension())
        self.classifier = TaxCategoryClassifier()
        
        # Initialize LLM based on configuration
        self.model = self._initialize_model()
        
        # Create the agent with tools
        self.agent = Agent(
            model=self.model,
            deps_type=AgenticDeps,
            result_type=TaxQueryResponse,
            system_prompt=self._get_system_prompt()
        )
        
        # Register tools
        self._register_tools()
        
        print("Agentic RAG initialized successfully")
    
    def _initialize_model(self):
        """Initialize the LLM model based on configuration."""
        if Config.OPENAI_API_KEY:
            print(f"Using OpenAI model")
            return OpenAIModel('gpt-4o-mini', api_key=Config.OPENAI_API_KEY)
        else:
            print(f"Using Ollama model: {Config.OLLAMA_MODEL}")
            return OllamaModel(
                model_name=Config.OLLAMA_MODEL,
                base_url=Config.OLLAMA_BASE_URL
            )
    
    def _get_system_prompt(self) -> str:
        """Get the system prompt for the agent."""
        return """You are an expert Hong Kong tax consultant assistant with access to a knowledge base of tax documents.

Your role is to:
1. Search and retrieve relevant information from tax documents (invoices, rental agreements, credit statements, etc.)
2. Classify transactions and expenses into HK tax categories
3. Provide accurate, detailed answers about tax deductions and income categories
4. Cite sources and explain your reasoning

Available tax categories:
- Deductions: Charitable Donations, Home Loan Interest, Elderly Care, MPF, Personal Allowances, Self-Education
- Income: Salaries, Rental Income, Business Profits, Investment Income, Other Income

When answering:
- Always search documents first using the search_documents tool
- Identify relevant tax categories using classify_tax_category tool
- Provide specific details from the documents (amounts, dates, names)
- Cite the source documents you used
- Be precise about tax implications and categories
"""
    
    def _register_tools(self):
        """Register tools for the agent."""
        
        @self.agent.tool
        async def search_documents(
            ctx: RunContext[AgenticDeps],
            query: str,
            top_k: int = 5
        ) -> List[DocumentSearchResult]:
            """Search for relevant documents in the knowledge base.
            
            Args:
                query: The search query
                top_k: Number of top results to return (default: 5)
                
            Returns:
                List of relevant document chunks with metadata
            """
            # Generate query embedding
            query_embedding = ctx.deps.embedder.generate_embedding(query)
            
            # Search in vector store
            results = ctx.deps.store.search(
                query_vector=query_embedding.tolist(),
                limit=top_k
            )
            
            # Convert to DocumentSearchResult
            search_results = []
            for result in results:
                doc = result["document"]
                search_results.append(DocumentSearchResult(
                    content=doc.get('content', '')[:1000],  # Limit content length
                    filename=doc.get('filename', 'Unknown'),
                    heading=doc.get('heading', ''),
                    relevance_score=result['score'],
                    key_values=doc.get('key_values', {}),
                    deduction_categories=doc.get('deduction_categories', []),
                    income_categories=doc.get('income_categories', [])
                ))
            
            return search_results
        
        @self.agent.tool
        async def classify_tax_category(
            ctx: RunContext[AgenticDeps],
            content: str
        ) -> Dict[str, List[str]]:
            """Classify content into HK tax categories.
            
            Args:
                content: The text content to classify
                
            Returns:
                Dictionary with deduction and income categories
            """
            classifications = ctx.deps.classifier.classify_document(content, {})
            
            return {
                "deductions": [cat for cat, _ in classifications['deductions'][:5]],
                "income": [cat for cat, _ in classifications['income'][:5]]
            }
        
        @self.agent.tool
        async def get_tax_category_info(
            ctx: RunContext[AgenticDeps],
            category_name: str
        ) -> Optional[str]:
            """Get detailed information about a specific tax category.
            
            Args:
                category_name: Name of the tax category
                
            Returns:
                Description of the tax category or None if not found
            """
            descriptions = ctx.deps.classifier.get_category_descriptions()
            
            # Search in both deductions and income
            for cat_type in ["deductions", "income"]:
                if category_name in descriptions[cat_type]:
                    return descriptions[cat_type][category_name]
            
            return None
    
    async def query(self, question: str) -> TaxQueryResponse:
        """Query the agentic RAG system.
        
        Args:
            question: User's question
            
        Returns:
            TaxQueryResponse with answer, sources, and metadata
        """
        print(f"\n🤖 Processing query: {question}")
        
        # Create dependencies
        deps = AgenticDeps(
            embedder=self.embedder,
            store=self.store,
            classifier=self.classifier
        )
        
        # Run the agent
        result = await self.agent.run(question, deps=deps)
        
        return result.data
    
    def query_sync(self, question: str) -> TaxQueryResponse:
        """Synchronous wrapper for query method.
        
        Args:
            question: User's question
            
        Returns:
            TaxQueryResponse with answer, sources, and metadata
        """
        import asyncio
        return asyncio.run(self.query(question))
    
    def list_tax_categories(self) -> Dict[str, List[str]]:
        """List all available tax categories."""
        descriptions = self.classifier.get_category_descriptions()
        
        return {
            "deductions": list(descriptions["deductions"].keys()),
            "income": list(descriptions["income"].keys())
        }
    
    def get_stats(self) -> Dict:
        """Get chatbot statistics."""
        store_info = self.store.get_collection_info()
        categories = self.list_tax_categories()
        
        return {
            "documents_indexed": store_info.get("points_count", 0),
            "collection_name": store_info.get("name", ""),
            "deduction_categories": len(categories["deductions"]),
            "income_categories": len(categories["income"])
        }
