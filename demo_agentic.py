#!/usr/bin/env python3
"""Demo script showing the Agentic RAG capabilities with PydanticAI."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from src.document_processor import DocumentProcessor
from src.agentic_rag import AgenticRAG
from src.config import Config


def main():
    print("=" * 70)
    print("AGENTIC RAG DEMO - PydanticAI + Langchain")
    print("=" * 70)
    
    # Step 1: Process Documents
    print("\n📁 STEP 1: Processing Documents")
    print("-" * 70)
    
    processor = DocumentProcessor()
    results = processor.process_directory(Config.SAMPLE_DOCS_DIR)
    
    print(f"\n✅ Processed {len(results)} documents")
    print(f"✅ Total chunks indexed: {sum(r['chunks_stored'] for r in results)}")
    
    # Step 2: Initialize Agentic RAG
    print("\n\n🤖 STEP 2: Initializing Agentic RAG System")
    print("-" * 70)
    
    agentic_rag = AgenticRAG()
    
    # Step 3: Demo Queries
    print("\n\n💬 STEP 3: Agentic Query Examples")
    print("-" * 70)
    
    queries = [
        "What is the total amount in the ABC Consulting invoice?",
        "What charitable donations appear in the documents?",
        "Can you identify any tax-deductible education expenses?",
        "What rental income is shown in the documents?"
    ]
    
    for i, question in enumerate(queries, 1):
        print(f"\n{'='*70}")
        print(f"Query {i}: {question}")
        print('='*70)
        
        try:
            response = agentic_rag.query_sync(question)
            
            print(f"\n📝 Answer:")
            print(f"{response.answer}\n")
            
            if response.tax_categories:
                print(f"🏷️  Tax Categories: {', '.join(response.tax_categories)}")
            
            if response.sources:
                print(f"\n📚 Sources:")
                for source in response.sources[:3]:
                    print(f"  • {source}")
            
            print(f"\n✨ Confidence: {response.confidence}")
            
        except Exception as e:
            print(f"❌ Error: {e}")
            import traceback
            traceback.print_exc()
    
    # Summary
    print("\n\n" + "=" * 70)
    print("✨ DEMO COMPLETE")
    print("=" * 70)
    print("""
The Agentic RAG system demonstrated:
  ✅ Autonomous document search with semantic understanding
  ✅ Tool-based architecture for flexible information retrieval
  ✅ Tax category classification and identification
  ✅ Source citation and confidence scoring
  ✅ Integration with Ollama/OpenAI via PydanticAI
  
The agent uses tools to:
  1. search_documents - Find relevant document chunks
  2. classify_tax_category - Identify tax implications
  3. get_tax_category_info - Get detailed category information

For interactive chat:
  python main.py --process --chat
  
For basic RAG (non-agentic):
  python main.py --process --chat --basic
""")
    print("=" * 70)


if __name__ == "__main__":
    main()
