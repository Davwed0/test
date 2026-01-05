# Agentic RAG Chatbot for HK Tax Documents

An intelligent **Agentic RAG** (Retrieval-Augmented Generation) chatbot powered by **PydanticAI** and **Langchain** that processes markdown documents (invoices, credit statements, rental agreements, etc.), extracts key values, and provides intelligent query capabilities with Hong Kong tax category classification.

## Features

- 🤖 **Agentic Architecture**: Autonomous agent with tool-based reasoning using PydanticAI
- 📄 **Markdown Document Processing**: Splits content by headings (#) for granular information retrieval
- 🔍 **Key-Value Extraction**: Automatically extracts structured data from documents
- 🧠 **Vector Embeddings**: Uses sentence transformers for semantic search
- 💾 **Qdrant Integration**: Stores embeddings with metadata (filename, summary, source)
- 🏷️ **Tax Classification**: Classifies extracted values into HK tax deduction and income categories
- 💬 **Interactive Chatbot**: Query documents using natural language
- 🎯 **RAG Architecture**: Retrieves relevant context before generating answers
- 🔧 **Tool-Based Agent**: Uses search, classification, and retrieval tools autonomously

## Hong Kong Tax Categories

The system classifies documents into the following categories:

### Tax Deductions
- Charitable Donations
- Home Loan Interest
- Elderly Residential Care Expenses
- Mandatory Provident Fund (MPF)
- Personal Allowances
- Self-Education Expenses

### Income Categories
- Salaries Income
- Rental Income
- Business Profits
- Investment Income
- Other Income

## Installation

1. **Clone the repository**:
```bash
git clone https://github.com/Davwed0/test.git
cd test
```

2. **Install dependencies**:
```bash
pip install -r requirements.txt
```

3. **Configure environment** (optional):
```bash
cp .env.example .env
# Edit .env with your settings
```

**Note:** The system includes a simple built-in embedding model that works without internet access. For production use with better semantic search, you can enable sentence-transformers by ensuring internet access to huggingface.co.

**LLM Integration (Required for Agentic Mode):** Configure an LLM provider for the agentic features:
- **Ollama** (recommended for local use): Set `OLLAMA_BASE_URL` and `OLLAMA_MODEL` in `.env`
- **OpenAI**: Set `OPENAI_API_KEY` in `.env`

## Quick Start

### Agentic RAG Demo (Recommended)

Experience the full agentic capabilities with PydanticAI:

```bash
python demo_agentic.py
```

This demonstrates:
1. Autonomous document search and retrieval
2. Tool-based reasoning for tax classification
3. LLM-powered answer generation with sources
4. Multi-step agentic workflows

### Using the Basic Demo Script

For a simpler demo without LLM:

```bash
python demo.py
```

This will:
1. Process all sample documents
2. Build the vector index
3. Run example queries showing:
   - Document retrieval
   - Key-value extraction
   - Tax category classification

### Process Documents

Process markdown documents from the sample_documents directory:

```bash
python main.py --process
```

Process documents from a custom directory:

```bash
python main.py --process --directory /path/to/your/documents
```

### Interactive Chat (Agentic Mode - Default)

Start the interactive agentic chatbot with PydanticAI:

```bash
python main.py --process --chat
```

Or use basic RAG mode (without agent/LLM):

```bash
python main.py --process --chat --basic
```

### Process and Chat

Process documents and then start chat in one command:

```bash
python main.py --process --chat
```

## Example Queries

Once in chat mode, you can ask questions like:

- "What is the invoice amount for ABC Consulting?"
- "Show me the rental agreement details"
- "What charitable donations were made?"
- "What are the education expenses?"
- "Which expenses can be tax deductible?"
- "What is the monthly rent?"

## Project Structure

```
.
├── README.md                          # This file
├── requirements.txt                   # Python dependencies (with PydanticAI & Langchain)
├── .env.example                       # Environment configuration template
├── main.py                           # CLI entry point (supports agentic & basic modes)
├── demo_agentic.py                   # Agentic RAG demo with PydanticAI
├── demo.py                           # Basic RAG demo
├── example.py                        # Comprehensive example
├── hk_tax_categories.md              # HK tax category definitions
├── sample_documents/                 # Sample markdown documents
│   ├── invoice_001.md
│   ├── rental_agreement_001.md
│   └── credit_statement_001.md
└── src/                              # Source code
    ├── __init__.py
    ├── config.py                     # Configuration management
    ├── markdown_parser.py            # Markdown parsing and splitting
    ├── embeddings.py                 # Embedding generation
    ├── qdrant_store.py              # Qdrant vector store integration
    ├── tax_classifier.py            # HK tax category classifier
    ├── document_processor.py        # Document processing pipeline
    ├── agentic_rag.py               # Agentic RAG with PydanticAI (NEW)
    └── rag_chatbot.py               # Basic RAG chatbot
```

## Architecture

### Agentic RAG System (PydanticAI + Langchain)

The system uses an **agentic architecture** where an LLM-powered agent autonomously uses tools to answer queries:

#### Agent Tools

1. **search_documents** - Semantic search for relevant document chunks
2. **classify_tax_category** - Classify content into HK tax categories
3. **get_tax_category_info** - Retrieve detailed tax category information

#### Agentic Query Flow

1. **User Query** → Agent receives question
2. **Reasoning** → Agent decides which tools to use
3. **Tool Execution** → Agent calls search_documents, classify_tax_category, etc.
4. **Context Integration** → Agent synthesizes information from multiple sources
5. **Answer Generation** → Agent produces structured response with sources and confidence

### Document Processing Pipeline

1. **Parse Markdown**: Split documents by headings and extract structure
2. **Extract Key-Values**: Identify key-value pairs (e.g., "Invoice Number: INV-001")
3. **Generate Summary**: Create document summaries from headings and key data
4. **Classify Categories**: Match content to HK tax categories using keyword analysis
5. **Generate Embeddings**: Create vector embeddings using sentence transformers
6. **Store in Qdrant**: Save embeddings with metadata for retrieval

### Basic RAG Query Flow (Non-Agentic)

1. **User Query**: User asks a question in natural language
2. **Query Embedding**: Convert question to vector embedding
3. **Semantic Search**: Find most relevant document chunks in Qdrant
4. **Context Building**: Assemble relevant context from retrieved chunks
5. **Answer Generation**: Generate answer with sources and tax classifications

## Configuration

Edit `.env` file to customize:

```env
# Qdrant Configuration
QDRANT_HOST=localhost
QDRANT_PORT=6333
QDRANT_COLLECTION_NAME=tax_documents
QDRANT_USE_MEMORY=true  # Use in-memory mode (no server required)

# Embedding Model
EMBEDDING_MODEL=all-MiniLM-L6-v2

# LLM Configuration (optional, for advanced answer generation)
# Choose either OpenAI or Ollama

# OpenAI
OPENAI_API_KEY=your_key_here

# Ollama (recommended for local use)
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2
```

## Sample Documents

The project includes three sample documents:

1. **invoice_001.md**: Business consulting invoice
2. **rental_agreement_001.md**: Residential property rental agreement
3. **credit_statement_001.md**: Credit card statement with various expenses

These demonstrate different document types and tax-relevant information.

## Adding Your Own Documents

1. Create markdown files with clear headings (`#`, `##`, `###`)
2. Use bold key-value format: `**Key**: Value`
3. Place files in `sample_documents/` or your custom directory
4. Run `python main.py --process --directory your_directory`

## Dependencies

- `qdrant-client`: Vector database client
- `sentence-transformers`: Embedding generation
- `langchain`: LLM framework (for future enhancements)
- `python-dotenv`: Environment configuration
- `pyyaml`: YAML parsing
- `pydantic`: Data validation

## Future Enhancements

- [ ] Integration with OpenAI GPT for better answer generation
- [ ] PDF document support
- [ ] Multi-language support (Traditional Chinese)
- [ ] Export functionality for tax reports
- [ ] Web interface using Streamlit/Gradio
- [ ] Advanced filtering by date ranges
- [ ] OCR support for scanned documents

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.