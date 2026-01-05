"""RAG Chatbot Agent for querying tax documents."""

from typing import List, Dict, Optional
from src.embeddings import EmbeddingGenerator
from src.qdrant_store import QdrantStore
from src.tax_classifier import TaxCategoryClassifier
from src.config import Config


class RAGChatbot:
    """RAG-based chatbot for querying tax documents."""
    
    def __init__(self):
        """Initialize the RAG chatbot."""
        print("Initializing RAG Chatbot...")
        self.embedder = EmbeddingGenerator()
        self.store = QdrantStore(embedding_dim=self.embedder.get_embedding_dimension())
        self.classifier = TaxCategoryClassifier()
        print("RAG Chatbot initialized successfully")
    
    def query(
        self,
        question: str,
        top_k: int = 5,
        filter_by_category: Optional[str] = None
    ) -> Dict:
        """
        Query the chatbot with a question.
        
        Args:
            question: User's question
            top_k: Number of top results to retrieve
            filter_by_category: Optional category filter
            
        Returns:
            Dictionary with answer and sources
        """
        print(f"\nQuery: {question}")
        
        # Generate query embedding
        query_embedding = self.embedder.generate_embedding(question)
        
        # Search in vector store
        filter_dict = None
        if filter_by_category:
            # Can filter by category if needed
            pass
        
        results = self.store.search(
            query_vector=query_embedding.tolist(),
            limit=top_k,
            filter_dict=filter_dict
        )
        
        if not results:
            return {
                "answer": "I couldn't find any relevant information in the documents.",
                "sources": [],
                "confidence": 0.0
            }
        
        # Build context from retrieved documents
        context = self._build_context(results)
        
        # Generate answer (simple extraction for now, can be enhanced with LLM)
        answer = self._generate_answer(question, context, results)
        
        # Extract sources
        sources = self._extract_sources(results)
        
        return {
            "answer": answer,
            "sources": sources,
            "confidence": results[0]["score"] if results else 0.0,
            "retrieved_chunks": len(results)
        }
    
    def _build_context(self, results: List[Dict]) -> str:
        """Build context from search results."""
        context_parts = []
        
        for i, result in enumerate(results, 1):
            doc = result["document"]
            score = result["score"]
            
            context_part = f"[Source {i}] {doc.get('heading', 'Document')}\n"
            context_part += f"{doc['content'][:500]}\n"  # First 500 chars
            context_part += f"(Relevance: {score:.2f})\n"
            
            context_parts.append(context_part)
        
        return "\n".join(context_parts)
    
    def _generate_answer(self, question: str, context: str, results: List[Dict]) -> str:
        """
        Generate answer from context.
        For now, this is a simple extraction. Can be enhanced with LLM.
        """
        # Get the most relevant document
        if not results:
            return "No relevant information found."
        
        top_result = results[0]
        doc = top_result["document"]
        
        # Build a structured answer
        answer_parts = []
        
        # Add main information
        answer_parts.append(f"Based on {doc['filename']}:\n")
        
        # Add relevant content
        content = doc['content'][:800]  # Limit length
        answer_parts.append(content)
        
        # Add key values if relevant
        if doc.get('key_values'):
            important_keys = ['Invoice Number', 'Total Amount Due', 'Monthly Rent', 
                            'Account Holder', 'Date', 'Payment Due Date']
            relevant_kvs = {k: v for k, v in doc['key_values'].items() if k in important_keys}
            
            if relevant_kvs:
                answer_parts.append("\n\nKey Information:")
                for key, value in list(relevant_kvs.items())[:5]:
                    answer_parts.append(f"- {key}: {value}")
        
        # Add tax categories if available
        deductions = doc.get('deduction_categories', [])
        income_cats = doc.get('income_categories', [])
        
        if deductions or income_cats:
            answer_parts.append("\n\nTax Classification:")
            if deductions:
                answer_parts.append(f"- Potential Deductions: {', '.join(deductions[:3])}")
            if income_cats:
                answer_parts.append(f"- Income Categories: {', '.join(income_cats[:3])}")
        
        return "\n".join(answer_parts)
    
    def _extract_sources(self, results: List[Dict]) -> List[Dict]:
        """Extract source information from results."""
        sources = []
        
        for result in results:
            doc = result["document"]
            source_info = {
                "filename": doc.get("filename", "Unknown"),
                "heading": doc.get("heading", ""),
                "summary": doc.get("summary", ""),
                "relevance_score": result["score"]
            }
            sources.append(source_info)
        
        return sources
    
    def list_tax_categories(self) -> Dict[str, List[str]]:
        """List all available tax categories."""
        descriptions = self.classifier.get_category_descriptions()
        
        return {
            "deductions": list(descriptions["deductions"].keys()),
            "income": list(descriptions["income"].keys())
        }
    
    def get_category_info(self, category_name: str) -> Optional[str]:
        """Get information about a specific tax category."""
        descriptions = self.classifier.get_category_descriptions()
        
        # Search in both deductions and income
        for cat_type in ["deductions", "income"]:
            if category_name in descriptions[cat_type]:
                return descriptions[cat_type][category_name]
        
        return None
    
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
