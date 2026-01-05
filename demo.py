#!/usr/bin/env python3
"""Test script to demo the RAG chatbot with integrated processing."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from src.document_processor import DocumentProcessor
from src.config import Config

# Process documents
print("=" * 60)
print("Processing Documents...")
print("=" * 60)

processor = DocumentProcessor()
results = processor.process_directory(Config.SAMPLE_DOCS_DIR)

print("\n" + "=" * 60)
print("Documents Indexed Successfully!")
print("=" * 60)
print(f"Total documents: {len(results)}")
print(f"Total chunks: {sum(r['chunks_stored'] for r in results)}")

# Now use the same processor's store to query
print("\n" + "=" * 60)
print("Testing Queries...")
print("=" * 60)

# Get embedder from processor
embedder = processor.embedder
store = processor.store

# Test queries
queries = [
    "What is the invoice amount for ABC Consulting?",
    "What is the monthly rent?",
    "What charitable donations were made?",
    "Show me education expenses"
]

for question in queries:
    print(f"\n❓ Question: {question}")
    
    # Generate query embedding
    query_embedding = embedder.generate_embedding(question)
    
    # Search
    results = store.search(query_embedding.tolist(), limit=3)
    
    if results:
        print(f"✅ Found {len(results)} relevant documents:")
        for i, result in enumerate(results[:2], 1):
            doc = result['document']
            print(f"\n  {i}. {doc['filename']} - {doc['heading']}")
            print(f"     Score: {result['score']:.2%}")
            content = doc['content'][:200].replace('\n', ' ')
            print(f"     Content: {content}...")
            
            # Show key values if available
            if doc.get('key_values'):
                kvs = list(doc['key_values'].items())[:3]
                if kvs:
                    print(f"     Key Info: {', '.join([f'{k}: {v}' for k, v in kvs])}")
    else:
        print("❌ No relevant documents found")

print("\n" + "=" * 60)
print("Demo Complete!")
print("=" * 60)
