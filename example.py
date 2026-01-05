#!/usr/bin/env python3
"""
Example script showing all capabilities of the RAG chatbot.
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from src.document_processor import DocumentProcessor
from src.rag_chatbot import RAGChatbot
from src.config import Config


def main():
    print("=" * 70)
    print("AGENTIC RAG CHATBOT - COMPLETE EXAMPLE")
    print("=" * 70)
    
    # Step 1: Process Documents
    print("\n📁 STEP 1: Processing Documents")
    print("-" * 70)
    
    processor = DocumentProcessor()
    results = processor.process_directory(Config.SAMPLE_DOCS_DIR)
    
    print(f"\n✅ Processed {len(results)} documents")
    print(f"✅ Total chunks indexed: {sum(r['chunks_stored'] for r in results)}")
    
    # Step 2: Show Tax Classifications
    print("\n\n🏷️  STEP 2: Tax Category Classifications")
    print("-" * 70)
    
    for result in results:
        print(f"\n{result['filename']}:")
        if result['classifications']['deductions']:
            top_deductions = [cat for cat, _ in result['classifications']['deductions'][:2]]
            print(f"  Deductions: {', '.join(top_deductions)}")
        if result['classifications']['income']:
            top_income = [cat for cat, _ in result['classifications']['income'][:2]]
            print(f"  Income: {', '.join(top_income)}")
    
    # Step 3: Query with RAG
    print("\n\n💬 STEP 3: RAG Query Examples")
    print("-" * 70)
    
    # Use the same store from processor
    embedder = processor.embedder
    store = processor.store
    classifier = processor.classifier
    
    queries = [
        ("What is the total amount in the invoice?", "invoice"),
        ("Who is the landlord in the rental agreement?", "rental"),
        ("What were the education-related expenses?", "education"),
        ("Show me charitable donations", "donations"),
    ]
    
    for question, tag in queries:
        print(f"\n❓ {question}")
        
        query_embedding = embedder.generate_embedding(question)
        results = store.search(query_embedding.tolist(), limit=2)
        
        if results:
            top_result = results[0]
            doc = top_result['document']
            
            print(f"   📄 Source: {doc['filename']}")
            print(f"   📝 Section: {doc['heading']}")
            print(f"   🎯 Relevance: {top_result['score']:.1%}")
            
            # Show key information
            if doc.get('key_values'):
                relevant_keys = [
                    'Total Amount Due', 'Monthly Rent', 'Account Holder',
                    'Invoice Number', 'Property Address'
                ]
                kvs = {k: v for k, v in doc['key_values'].items() if k in relevant_keys}
                if kvs:
                    print(f"   🔑 Key Info:")
                    for k, v in list(kvs.items())[:2]:
                        print(f"      • {k}: {v}")
    
    # Step 4: Show Available Categories
    print("\n\n📊 STEP 4: Available Tax Categories")
    print("-" * 70)
    
    categories = classifier.get_category_descriptions()
    
    print("\nTax Deductions:")
    for cat_name in list(categories['deductions'].keys())[:4]:
        desc = categories['deductions'][cat_name]
        print(f"  • {cat_name}")
        if desc:
            print(f"    {desc[:80]}...")
    
    print("\nIncome Categories:")
    for cat_name in list(categories['income'].keys())[:3]:
        desc = categories['income'][cat_name]
        print(f"  • {cat_name}")
        if desc:
            print(f"    {desc[:80]}...")
    
    # Summary
    print("\n\n" + "=" * 70)
    print("✨ SUMMARY")
    print("=" * 70)
    print("""
This example demonstrated:
  ✅ Document processing and indexing
  ✅ Key-value extraction from markdown
  ✅ Tax category classification (HK specific)
  ✅ Vector embedding and similarity search
  ✅ RAG-based query answering
  ✅ Metadata storage and retrieval
  
For interactive chat, run:
  python main.py --process --chat
  
For quick demo:
  python demo.py
""")
    print("=" * 70)


if __name__ == "__main__":
    main()
