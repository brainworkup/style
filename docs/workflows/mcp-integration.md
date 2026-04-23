# MCP Integration Workflow

This document describes the Model Context Protocol (MCP) integration for AI-powered operations in the Voice Style system.

## Overview

MCP provides a standardized interface for integrating AI capabilities (LLMs) into the report generation workflow. The system uses local LLMs via Ollama for privacy and control.

## Architecture

```text
┌─────────────────┐
│  Voice Style    │
│  Application    │
└────────┬────────┘
         │
         │ MCP Protocol
         │
┌────────┴────────┐
│  MCP Server     │
│  (Local)        │
└────────┬────────┘
         │
         │ HTTP API
         │
┌────────┴────────┐
│  Ollama         │
│  (LLM Backend)  │
└─────────────────┘
```

## Configuration

### MCP Settings in config.yml

```yaml
mcp:
  pdf_path: "data/raw/pdf/wisc5.pdf"
  tree_path: "results/wisc5_report_structure.json"
  llm_base_url: "http://localhost:11434/v1"
  llm_model: "ollama/llama3.1"
  lookup_table: "~/Dropbox/neuropsych_lookup_table.csv"
```

### Configuration Parameters

- **pdf_path**: Path to raw psychological test PDF
- **tree_path**: Output path for structured JSON data
- **llm_base_url**: Ollama API endpoint
- **llm_model**: Model to use for inference
- **lookup_table**: CSV file with clinical terminology mappings

## MCP Tools

### PDF Extraction Tool

**Purpose**: Extract structured data from psychological test PDFs

**Input**:

- PDF file path
- Test type (e.g., WISC-V, WAIS-IV)

**Process**:

1. Read PDF content
2. Parse test scores and subtest scores
3. Extract demographic information
4. Apply clinical terminology mappings
5. Structure data as JSON

**Output**:

```json
{
  "patient": {
    "name": "Biggie Smalls",
    "age": 18,
    "dob": "XXXX-XX-XX"
  },
  "tests": [
    {
      "name": "WISC-V",
      "subtests": [
        {
          "name": "Block Design",
          "raw_score": 45,
          "scaled_score": 12,
          "percentile": 75
        }
      ]
    }
  ]
}
```

### Clinical Interpretation Tool

**Purpose**: Generate clinical interpretations from test scores

**Input**:

- Structured test data (JSON)
- Domain-specific context

**Process**:

1. Analyze score patterns
2. Compare to normative data
3. Identify strengths and weaknesses
4. Generate interpretive text
5. Apply clinical templates

**Output**:

- Markdown-formatted interpretation
- Domain-specific summaries
- Clinical significance statements

### Lookup Table Integration

**Purpose**: Map test scores to clinical terminology

**Input**:

- Raw test scores
- Test type

**Process**:

1. Query lookup table (CSV)
2. Map scores to descriptive ranges
3. Apply clinical labels
4. Handle edge cases

**Output**:

- Standardized terminology
- Consistent descriptions
- Clinical labels

## Workflow Integration

### Step 1: Initialize MCP Client

```python
from mcp import Client

client = Client(
    base_url="http://localhost:11434/v1",
    model="ollama/llama3.1"
)
```

### Step 2: Invoke PDF Extraction

```python
result = client.call_tool(
    "extract_pdf_data",
    {
        "pdf_path": "data/raw/pdf/wisc5.pdf",
        "output_path": "results/wisc5_report_structure.json"
    }
)
```

### Step 3: Process Structured Data

```python
import json

with open("results/wisc5_report_structure.json") as f:
    data = json.load(f)

# Process data for R/neuro2
```

### Step 4: Generate Interpretations

```python
interpretation = client.call_tool(
    "generate_interpretation",
    {
        "test_data": data,
        "domain": "memory"
    }
)
```

## Error Handling

### Connection Errors

```python
try:
    client = Client(base_url="http://localhost:11434/v1")
except ConnectionError:
    print("Ollama not running. Start with: ollama serve")
```

### Model Errors

```python
try:
    result = client.call_tool("extract_pdf_data", params)
except ModelError as e:
    print(f"Model error: {e}")
    print("Ensure model is downloaded: ollama pull llama3.1")
```

### Data Validation

```python
# Validate extracted data
if "tests" not in data:
    raise ValueError("No tests found in extracted data")

if not data["tests"]:
    raise ValueError("Empty test data")
```

## Performance Considerations

### Model Selection

- **llama3.1**: Good balance of speed and quality
- **llama3.1:70b**: Higher quality, slower
- **mistral**: Faster, good for simple tasks

### Caching

Cache extraction results to avoid re-processing:

```python
import os

output_path = "results/wisc5_report_structure.json"
if os.path.exists(output_path):
    with open(output_path) as f:
        data = json.load(f)
else:
    data = extract_pdf_data(pdf_path)
```

### Batch Processing

Process multiple PDFs in parallel:

```python
from concurrent.futures import ThreadPoolExecutor

pdfs = ["pdf1.pdf", "pdf2.pdf", "pdf3.pdf"]

with ThreadPoolExecutor(max_workers=3) as executor:


    results = executor.map(extract_pdf_data, pdfs)
```

## Security and Privacy

### Local Processing

All LLM operations run locally via Ollama:

- No data leaves the local machine
- No API calls to external services
- Full control over model versions

### Data Sanitization

Sanitize patient data before processing:

- Remove PHI where possible
- Use anonymized identifiers
- Store sensitive data securely

### Access Control

Restrict access to MCP server:

- Localhost only by default
- No external network access
- User-level permissions

## Troubleshooting

### Ollama Not Running

```bash
# Start Ollama
ollama serve

# Check status
ollama list
```

### Model Not Downloaded

```bash
# Download model
ollama pull llama3.1

# List available models
ollama list
```

### Connection Refused

- Verify Ollama is running
- Check port (default: 11434)
- Verify firewall settings
- Check base_url in config.yml

### Slow Performance

- Use smaller model for simple tasks
- Enable GPU acceleration if available
- Cache extraction results
- Process data in batches

## Testing

### Unit Tests

```python
def test_pdf_extraction():
    result = extract_pdf_data("test.pdf")
    assert "tests" in result
    assert len(result["tests"]) > 0
```

### Integration Tests

```python
def test_full_workflow():
    data = extract_pdf_data("test.pdf")
    interpretation = generate_interpretation(data)
    assert len(interpretation) > 0
```

### Manual Testing

```bash
# Test extraction
python soul/extract_pdf_data.py

# Verify output
cat results/wisc5_report_structure.json
```

## Future Enhancements

### Additional MCP Tools

- **Symptom Checker**: Analyze symptom patterns
- **Recommendation Generator**: Suggest interventions
- **Quality Checker**: Validate report completeness

### Model Fine-Tuning

- Fine-tune models on clinical data
- Custom models for specific domains
- Domain-specific terminology

### Multi-Modal Support

- Process image-based test reports
- Handle scanned documents
- OCR integration

## References

- MCP Specification: <https://modelcontextprotocol.io/>
- Ollama Documentation: <https://ollama.com/>
- LLaMA 3.1: <https://llama.meta.com/>
