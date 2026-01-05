"""Configuration module for the RAG chatbot."""

import os
from pathlib import Path
from typing import Optional
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


class Config:
    """Configuration class for the RAG chatbot."""
    
    # Qdrant settings
    QDRANT_HOST: str = os.getenv("QDRANT_HOST", "localhost")
    QDRANT_PORT: int = int(os.getenv("QDRANT_PORT", "6333"))
    QDRANT_COLLECTION_NAME: str = os.getenv("QDRANT_COLLECTION_NAME", "tax_documents")
    QDRANT_USE_MEMORY: bool = os.getenv("QDRANT_USE_MEMORY", "true").lower() == "true"
    
    # Embedding settings
    EMBEDDING_MODEL: str = os.getenv("EMBEDDING_MODEL", "all-MiniLM-L6-v2")
    EMBEDDING_DIMENSION: int = 384  # for all-MiniLM-L6-v2
    
    # LLM settings (optional - for advanced answer generation)
    OPENAI_API_KEY: Optional[str] = os.getenv("OPENAI_API_KEY")
    OLLAMA_BASE_URL: str = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
    OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "llama3.2")
    
    # Document processing
    CHUNK_SIZE: int = 1000
    CHUNK_OVERLAP: int = 200
    
    # Paths
    BASE_DIR: Path = Path(__file__).parent.parent
    SAMPLE_DOCS_DIR: Path = BASE_DIR / "sample_documents"
    TAX_CATEGORIES_FILE: Path = BASE_DIR / "hk_tax_categories.md"
    
    @classmethod
    def validate(cls) -> bool:
        """Validate configuration."""
        if not cls.SAMPLE_DOCS_DIR.exists():
            print(f"Warning: Sample documents directory not found: {cls.SAMPLE_DOCS_DIR}")
        if not cls.TAX_CATEGORIES_FILE.exists():
            print(f"Warning: Tax categories file not found: {cls.TAX_CATEGORIES_FILE}")
        return True


# Validate config on import
Config.validate()
