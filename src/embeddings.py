"""Embedding generation module using sentence transformers."""

from typing import List, Union
import numpy as np
import hashlib
from src.config import Config


class SimpleEmbedding:
    """Simple TF-IDF-like embedding that doesn't require external downloads."""
    
    def __init__(self, dim=384):
        self.dim = dim
        self.vocab = {}
    
    def _tokenize(self, text):
        """Simple tokenization."""
        import re
        words = re.findall(r'\b\w+\b', text.lower())
        return words
    
    def _hash_word(self, word):
        """Hash a word to a position in the embedding."""
        hash_val = int(hashlib.md5(word.encode()).hexdigest(), 16)
        return hash_val % self.dim
    
    def encode(self, texts, convert_to_numpy=True):
        """Encode texts to embeddings."""
        if isinstance(texts, str):
            texts = [texts]
        
        embeddings = []
        for text in texts:
            words = self._tokenize(text)
            embedding = np.zeros(self.dim)
            
            # Count-based embedding with hashing
            word_counts = {}
            for word in words:
                word_counts[word] = word_counts.get(word, 0) + 1
            
            # Distribute word counts across embedding dimensions
            for word, count in word_counts.items():
                idx = self._hash_word(word)
                # Also use adjacent positions for better distribution
                embedding[idx] += count
                embedding[(idx + 1) % self.dim] += count * 0.5
                embedding[(idx - 1) % self.dim] += count * 0.5
            
            # Normalize
            norm = np.linalg.norm(embedding)
            if norm > 0:
                embedding = embedding / norm
            
            embeddings.append(embedding)
        
        result = np.array(embeddings)
        return result if len(texts) > 1 else result[0]
    
    def get_sentence_embedding_dimension(self):
        """Get embedding dimension."""
        return self.dim


class EmbeddingGenerator:
    """Generate embeddings for text."""
    
    def __init__(self, model_name: str = None):
        """
        Initialize the embedding generator.
        
        Args:
            model_name: Name of the sentence transformer model (ignored in simple mode)
        """
        self.model_name = model_name or Config.EMBEDDING_MODEL
        print(f"Initializing embedding model: {self.model_name}")
        print("Using simple embedding (no external downloads required)")
        self.model = SimpleEmbedding(dim=384)
        self.embedding_dim = 384
        self.use_simple = True
        print(f"Model initialized. Embedding dimension: {self.embedding_dim}")
    
    def generate_embedding(self, text: str) -> np.ndarray:
        """
        Generate embedding for a single text.
        
        Args:
            text: Input text
            
        Returns:
            Numpy array of embeddings
        """
        embedding = self.model.encode(text, convert_to_numpy=True)
        return embedding
    
    def generate_embeddings(self, texts: List[str]) -> np.ndarray:
        """
        Generate embeddings for multiple texts.
        
        Args:
            texts: List of input texts
            
        Returns:
            Numpy array of embeddings
        """
        embeddings = self.model.encode(texts, convert_to_numpy=True)
        return embeddings
    
    def get_embedding_dimension(self) -> int:
        """Get the dimension of embeddings."""
        return self.embedding_dim

    
    def generate_embedding(self, text: str) -> np.ndarray:
        """
        Generate embedding for a single text.
        
        Args:
            text: Input text
            
        Returns:
            Numpy array of embeddings
        """
        embedding = self.model.encode(text, convert_to_numpy=True)
        return embedding
    
    def generate_embeddings(self, texts: List[str]) -> np.ndarray:
        """
        Generate embeddings for multiple texts.
        
        Args:
            texts: List of input texts
            
        Returns:
            Numpy array of embeddings
        """
        embeddings = self.model.encode(texts, convert_to_numpy=True)
        return embeddings
    
    def get_embedding_dimension(self) -> int:
        """Get the dimension of embeddings."""
        return self.embedding_dim
