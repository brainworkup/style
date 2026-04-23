# ADR 002: MCP Server Integration for LLM Operations

## Status

Accepted

## Context

The Voice project requires AI-powered capabilities for:

- Extracting structured data from PDF psychological test reports
- Generating clinical interpretations from test scores
- Automating report section generation
- Processing natural language in clinical contexts

## Decision

Integrate **Model Context Protocol (MCP)** servers to provide AI capabilities through a standardized interface.

### Architecture

- MCP servers provide AI tools as standardized services
- Local LLM backend (Ollama) for privacy and control
- Configurable model selection via `config.yml`
- Structured tool interfaces for specific clinical tasks

### Rationale

**Why MCP**:

- Standardized protocol for AI tool integration
- Supports multiple AI providers (local and cloud)
- Clean separation between application logic and AI capabilities
- Easy to swap LLM backends without code changes
- Built-in tool discovery and management

**Why Local LLM (Ollama)**:

- Patient data privacy (no data leaves local environment)
- No API costs
- Customizable models for clinical terminology
- Offline capability
- Control over model versions

**Alternatives Considered**:

- **Direct API calls to OpenAI/Anthropic**: Privacy concerns, ongoing costs, network dependency
- **LangChain**: Over-engineering for our use case, unnecessary complexity
- **Custom LLM integration**: Reinventing the wheel, maintenance burden

## Consequences

- Positive: Privacy-preserving AI operations
- Positive: Flexible model switching
- Positive: Standardized tool interfaces
- Negative: Requires local GPU/CPU resources
- Negative: Initial setup complexity
- Negative: Model quality depends on local hardware

## Implementation

- MCP configuration in `config.yml` under `mcp` section
- Local Ollama backend at `http://localhost:11434/v1`
- Default model: `ollama/llama3.1`
- PDF extraction tool for psychological test reports
- Lookup table integration for clinical terminology

## References

- MCP specification: <https://modelcontextprotocol.io/>
- Ollama documentation: <https://ollama.com/>
