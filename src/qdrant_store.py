"""Qdrant vector database integration."""

from typing import List, Dict, Optional
from qdrant_client import QdrantClient
from qdrant_client.models import (
    Distance, VectorParams, PointStruct,
    Filter, FieldCondition, MatchValue
)
import uuid
from src.config import Config


class QdrantStore:
    """Qdrant vector store for document embeddings."""
    
    def __init__(self, collection_name: str = None, embedding_dim: int = None):
        """
        Initialize Qdrant client and collection.
        
        Args:
            collection_name: Name of the collection
            embedding_dim: Dimension of embeddings
        """
        self.collection_name = collection_name or Config.QDRANT_COLLECTION_NAME
        self.embedding_dim = embedding_dim or Config.EMBEDDING_DIMENSION
        
        # Use in-memory Qdrant for simplicity (can be changed to remote)
        if Config.QDRANT_USE_MEMORY:
            print("Initializing Qdrant in-memory mode")
            self.client = QdrantClient(":memory:")
        else:
            print(f"Connecting to Qdrant at {Config.QDRANT_HOST}:{Config.QDRANT_PORT}")
            self.client = QdrantClient(
                host=Config.QDRANT_HOST,
                port=Config.QDRANT_PORT
            )
        
        self._create_collection()
    
    def _create_collection(self):
        """Create collection if it doesn't exist."""
        collections = self.client.get_collections().collections
        collection_names = [col.name for col in collections]
        
        if self.collection_name not in collection_names:
            print(f"Creating collection: {self.collection_name}")
            self.client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(
                    size=self.embedding_dim,
                    distance=Distance.COSINE
                )
            )
        else:
            print(f"Collection {self.collection_name} already exists")
    
    def add_documents(self, documents: List[Dict], embeddings: List[List[float]]):
        """
        Add documents with embeddings to the collection.
        
        Args:
            documents: List of document dictionaries with metadata
            embeddings: List of embedding vectors
        """
        points = []
        
        for doc, embedding in zip(documents, embeddings):
            point_id = str(uuid.uuid4())
            
            point = PointStruct(
                id=point_id,
                vector=embedding,
                payload=doc
            )
            points.append(point)
        
        self.client.upsert(
            collection_name=self.collection_name,
            points=points
        )
        
        print(f"Added {len(points)} documents to collection")
    
    def search(
        self,
        query_vector: List[float],
        limit: int = 5,
        filter_dict: Optional[Dict] = None
    ) -> List[Dict]:
        """
        Search for similar documents.
        
        Args:
            query_vector: Query embedding vector
            limit: Number of results to return
            filter_dict: Optional filter conditions
            
        Returns:
            List of search results with documents and scores
        """
        search_filter = None
        if filter_dict:
            # Build filter from dictionary
            conditions = []
            for key, value in filter_dict.items():
                conditions.append(
                    FieldCondition(
                        key=key,
                        match=MatchValue(value=value)
                    )
                )
            if conditions:
                search_filter = Filter(must=conditions)
        
        # Use query_points for the new API
        results = self.client.query_points(
            collection_name=self.collection_name,
            query=query_vector,
            limit=limit,
            query_filter=search_filter
        )
        
        # Handle response format
        points = results.points if hasattr(results, 'points') else results
        
        return [
            {
                "id": point.id,
                "score": point.score,
                "document": point.payload
            }
            for point in points
        ]
    
    def delete_collection(self):
        """Delete the collection."""
        self.client.delete_collection(collection_name=self.collection_name)
        print(f"Deleted collection: {self.collection_name}")
    
    def get_collection_info(self) -> Dict:
        """Get information about the collection."""
        info = self.client.get_collection(collection_name=self.collection_name)
        return {
            "name": self.collection_name,
            "vectors_count": getattr(info, 'vectors_count', info.points_count),
            "points_count": info.points_count
        }
