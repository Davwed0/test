#!/usr/bin/env python3
"""Main CLI interface for the RAG Chatbot."""

import sys
import argparse
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent))

from src.document_processor import DocumentProcessor
from src.rag_chatbot import RAGChatbot
from src.agentic_rag import AgenticRAG
from src.config import Config


def process_documents(directory: str = None):
    """Process and index documents."""
    print("=" * 60)
    print("Document Processing Mode")
    print("=" * 60)
    
    doc_dir = Path(directory) if directory else Config.SAMPLE_DOCS_DIR
    
    if not doc_dir.exists():
        print(f"Error: Directory not found: {doc_dir}")
        return
    
    processor = DocumentProcessor()
    results = processor.process_directory(doc_dir)
    
    print("\n" + "=" * 60)
    print("Processing Summary")
    print("=" * 60)
    print(f"Total files processed: {len(results)}")
    
    for result in results:
        print(f"\n{result['filename']}:")
        print(f"  - Summary: {result['summary']}")
        print(f"  - Sections: {result['sections_count']}")
        print(f"  - Chunks stored: {result['chunks_stored']}")
        if result['classifications']['deductions']:
            print(f"  - Top deductions: {[c[0] for c in result['classifications']['deductions'][:2]]}")
        if result['classifications']['income']:
            print(f"  - Top income: {[c[0] for c in result['classifications']['income'][:2]]}")
    
    # Show store info
    store_info = processor.get_store_info()
    print(f"\nVector Store Info:")
    print(f"  - Collection: {store_info['name']}")
    print(f"  - Total documents: {store_info['points_count']}")


def interactive_chat(use_agentic: bool = True):
    """Run interactive chat mode.
    
    Args:
        use_agentic: If True, use AgenticRAG, otherwise use basic RAGChatbot
    """
    print("=" * 60)
    mode = "Agentic RAG" if use_agentic else "Basic RAG"
    print(f"{mode} Chatbot - Interactive Mode")
    print("=" * 60)
    print("Ask questions about your tax documents.")
    print("Commands:")
    print("  - 'categories' - List tax categories")
    print("  - 'stats' - Show chatbot statistics")
    print("  - 'quit' or 'exit' - Exit the chatbot")
    print("=" * 60)
    
    if use_agentic:
        chatbot = AgenticRAG()
    else:
        chatbot = RAGChatbot()
    
    while True:
        try:
            question = input("\n🤖 You: ").strip()
            
            if not question:
                continue
            
            if question.lower() in ['quit', 'exit', 'q']:
                print("Goodbye!")
                break
            
            if question.lower() == 'categories':
                categories = chatbot.list_tax_categories()
                print("\n📋 Tax Categories:")
                print("\nDeductions:")
                for cat in categories['deductions']:
                    print(f"  - {cat}")
                print("\nIncome:")
                for cat in categories['income']:
                    print(f"  - {cat}")
                continue
            
            if question.lower() == 'stats':
                stats = chatbot.get_stats()
                print("\n📊 Chatbot Statistics:")
                print(f"  - Documents indexed: {stats['documents_indexed']}")
                print(f"  - Collection: {stats['collection_name']}")
                print(f"  - Deduction categories: {stats['deduction_categories']}")
                print(f"  - Income categories: {stats['income_categories']}")
                continue
            
            # Query the chatbot
            if use_agentic:
                response = chatbot.query_sync(question)
                print(f"\n🤖 Bot: {response.answer}")
                
                if response.tax_categories:
                    print(f"\n🏷️  Tax Categories: {', '.join(response.tax_categories)}")
                
                if response.sources:
                    print(f"\n📚 Sources:")
                    for i, source in enumerate(response.sources[:3], 1):
                        print(f"  {i}. {source}")
                
                print(f"\n✨ Confidence: {response.confidence}")
            else:
                response = chatbot.query(question, top_k=3)
                print(f"\n🤖 Bot: {response['answer']}")
                
                if response['sources']:
                    print(f"\n📚 Sources (Confidence: {response['confidence']:.2%}):")
                    for i, source in enumerate(response['sources'][:3], 1):
                        print(f"  {i}. {source['filename']} - {source['heading']}")
                        print(f"     Relevance: {source['relevance_score']:.2%}")
        
        except KeyboardInterrupt:
            print("\n\nGoodbye!")
            break
        except Exception as e:
            print(f"Error: {e}")
            import traceback
            traceback.print_exc()


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="RAG Chatbot for HK Tax Documents",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Process sample documents
  python main.py --process
  
  # Process custom directory
  python main.py --process --directory /path/to/docs
  
  # Start interactive chat
  python main.py --chat
  
  # Process and then chat
  python main.py --process --chat
        """
    )
    
    parser.add_argument(
        '--process',
        action='store_true',
        help='Process and index documents'
    )
    
    parser.add_argument(
        '--directory',
        type=str,
        help='Directory containing markdown documents (default: sample_documents)'
    )
    
    parser.add_argument(
        '--chat',
        action='store_true',
        help='Start interactive chat mode'
    )
    
    parser.add_argument(
        '--agentic',
        action='store_true',
        default=True,
        help='Use Agentic RAG with PydanticAI (default: True)'
    )
    
    parser.add_argument(
        '--basic',
        action='store_true',
        help='Use basic RAG instead of Agentic RAG'
    )
    
    args = parser.parse_args()
    
    # If no arguments provided, show help
    if not (args.process or args.chat):
        parser.print_help()
        return
    
    # Process documents if requested
    if args.process:
        process_documents(args.directory)
    
    # Start chat if requested
    if args.chat:
        print()  # Add spacing
        use_agentic = not args.basic  # Use agentic by default unless --basic is specified
        interactive_chat(use_agentic=use_agentic)


if __name__ == "__main__":
    main()
