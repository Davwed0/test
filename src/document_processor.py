"""Document processor for processing and storing markdown documents."""

from typing import List, Dict
from pathlib import Path
from src.markdown_parser import MarkdownParser
from src.embeddings import EmbeddingGenerator
from src.qdrant_store import QdrantStore
from src.tax_classifier import TaxCategoryClassifier
from src.config import Config


class DocumentProcessor:
    """Process markdown documents and store in vector database."""
    
    def __init__(self):
        """Initialize the document processor."""
        print("Initializing Document Processor...")
        self.parser = MarkdownParser()
        self.embedder = EmbeddingGenerator()
        self.store = QdrantStore(embedding_dim=self.embedder.get_embedding_dimension())
        self.classifier = TaxCategoryClassifier()
        print("Document Processor initialized successfully")
    
    def process_file(self, file_path: Path) -> Dict:
        """
        Process a single markdown file.
        
        Args:
            file_path: Path to the markdown file
            
        Returns:
            Dictionary with processing results
        """
        print(f"\nProcessing file: {file_path.name}")
        
        # Parse the document
        parsed_doc = self.parser.parse_file(file_path)
        
        # Generate summary
        summary = self.parser.generate_summary(parsed_doc)
        print(f"Summary: {summary}")
        
        # Classify into tax categories
        classifications = self.classifier.classify_document(
            parsed_doc["full_content"],
            parsed_doc["key_values"]
        )
        
        # Prepare documents for embedding
        documents_to_embed = []
        
        # Create document for each section
        for section in parsed_doc["sections"]:
            if section["content"].strip():
                doc = {
                    "filename": file_path.name,
                    "source": str(file_path),
                    "heading": section["heading"],
                    "level": section["level"],
                    "content": section["content"].strip(),
                    "summary": summary,
                    "key_values": parsed_doc["key_values"],
                    "deduction_categories": [cat[0] for cat in classifications["deductions"][:3]],
                    "income_categories": [cat[0] for cat in classifications["income"][:3]],
                    "type": "section"
                }
                documents_to_embed.append(doc)
        
        # Also create a document for the full content
        full_doc = {
            "filename": file_path.name,
            "source": str(file_path),
            "heading": parsed_doc["sections"][0]["heading"] if parsed_doc["sections"] else "Document",
            "level": 0,
            "content": parsed_doc["full_content"][:1000],  # First 1000 chars
            "summary": summary,
            "key_values": parsed_doc["key_values"],
            "deduction_categories": [cat[0] for cat in classifications["deductions"][:3]],
            "income_categories": [cat[0] for cat in classifications["income"][:3]],
            "type": "full_document"
        }
        documents_to_embed.append(full_doc)
        
        # Generate embeddings
        texts_to_embed = [doc["content"] for doc in documents_to_embed]
        embeddings = self.embedder.generate_embeddings(texts_to_embed)
        
        # Store in Qdrant
        self.store.add_documents(documents_to_embed, embeddings.tolist())
        
        print(f"Stored {len(documents_to_embed)} chunks for {file_path.name}")
        print(f"Deduction categories: {[cat[0] for cat in classifications['deductions'][:3]]}")
        print(f"Income categories: {[cat[0] for cat in classifications['income'][:3]]}")
        
        return {
            "filename": file_path.name,
            "summary": summary,
            "sections_count": len(parsed_doc["sections"]),
            "key_values": parsed_doc["key_values"],
            "classifications": classifications,
            "chunks_stored": len(documents_to_embed)
        }
    
    def process_directory(self, directory: Path) -> List[Dict]:
        """
        Process all markdown files in a directory.
        
        Args:
            directory: Path to directory
            
        Returns:
            List of processing results
        """
        results = []
        
        markdown_files = list(directory.glob("*.md"))
        
        if not markdown_files:
            print(f"No markdown files found in {directory}")
            return results
        
        print(f"\nFound {len(markdown_files)} markdown files")
        
        for file_path in markdown_files:
            try:
                result = self.process_file(file_path)
                results.append(result)
            except Exception as e:
                print(f"Error processing {file_path.name}: {e}")
        
        return results
    
    def get_store_info(self) -> Dict:
        """Get information about the vector store."""
        return self.store.get_collection_info()
