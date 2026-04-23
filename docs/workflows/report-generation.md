# Report Generation Workflow

This document describes the end-to-end workflow for generating neuropsychological reports using the Voice Style system.

## Overview

The report generation process transforms raw psychological test data (PDFs) into professionally formatted neuropsychological reports through a multi-stage pipeline.

## Prerequisites

### System Requirements

- **Quarto**: >=1.4.0
- **R**: >=4.0 with required packages (neuro2, dplyr, ggplot2, etc.)
- **Typst**: Latest version
- **Ollama**: For local LLM operations
- **Python**: >=3.13 (for processing scripts)

### Configuration

1. Set up `config.yml` with patient information and paths
2. Configure MCP settings in `config.yml` (LLM backend, model, etc.)
3. Set template variables in `_variables.yml`
4. Select appropriate Quarto extension (pediatric/adult/forensic)

## Workflow Steps

### Step 1: Data Preparation

**Input**: Raw psychological test reports (PDFs)

**Process**:

1. Place PDF files in `data/raw/pdf/` directory
2. Update `config.yml` with PDF path:

   ```yaml
   mcp:
     pdf_path: "data/raw/pdf/wisc5.pdf"
   ```

3. Ensure lookup table is accessible:

   ```yaml
   mcp:
     lookup_table: "~/Dropbox/neuropsych_lookup_table.csv"
   ```

**Output**: Structured data ready for extraction

### Step 2: PDF Data Extraction

**Input**: Raw PDF files

**Process** (via MCP LLM):

1. Run extraction script:

   ```bash
   python soul/extract_pdf_data.py
   ```

2. MCP server invokes LLM to parse PDF
3. Extract structured test scores and metadata
4. Apply clinical terminology via lookup table
5. Save results to `results/wisc5_report_structure.json`

**Output**: JSON file with structured test data

**Configuration**:

```yaml
mcp:
  llm_base_url: "http://localhost:11434/v1"
  llm_model: "ollama/llama3.1"
```

### Step 3: Data Processing

**Input**: Structured JSON data

**Process** (via R/neuro2):

1. Load JSON data into R environment
2. Apply age-appropriate norms
3. Calculate standard scores and percentiles
4. Generate data visualizations
5. Create summary tables

**Output**: Processed data frames, plots, and tables

**Configuration**:

```yaml
processing:
  use_duckdb: yes
  parallel: yes
  verbose: yes
  age_group: ""
```

### Step 4: Template Rendering

**Input**: Processed data + template files

**Process**:

1. Quarto loads `template.qmd`
2. Executes R setup chunk
3. Substitutes variables from `_variables.yml`
4. Includes section files in order
5. Executes R code chunks in each section
6. Generates Typst markup

**Output**: Intermediate Typst file (.typ)

**Configuration**:

```yaml
output:
  generate_qmd: yes
  generate_plots: yes
  generate_tables: yes
```

### Step 5: Typst Compilation

**Input**: Typst markup file

**Process**:

1. Typst compiler reads .typ file
2. Applies template from selected extension
3. Applies show rules for styling
4. Generates PDF output

**Output**: Final neuropsychological report (PDF)

**Configuration**:

```yaml
report:
  template: template.qmd
  format: neurotyp-pediatric-typst
  output_dir: output
```

## Detailed Workflow Diagram

```text
┌─────────────────┐
│  Raw PDF Data    │
│  (test reports) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  MCP LLM        │
│  Extraction     │
│  (Ollama)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Structured     │
│  JSON Data      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  R Processing   │
│  (neuro2)       │
│  - Norms        │
│  - Scores       │
│  - Plots        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Quarto         │
│  Template       │
│  Rendering      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Typst          │
│  Compilation    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Final Report   │
│  (PDF)          │
└─────────────────┘
```

## Command-Line Execution

### Full Pipeline

```bash
# From project root
cd style/templates/typst-report
quarto render template.qmd
```

### Step-by-Step

```bash
# Step 1: Extract PDF data
python soul/extract_pdf_data.py

# Step 2: Render report
cd style/templates/typst-report
quarto render template.qmd --to neurotyp-pediatric-typst
```

### With Specific Format

```bash
# Pediatric report
quarto render template.qmd --to neurotyp-pediatric-typst

# Adult report
quarto render template.qmd --to neurotyp-adult-typst

# Forensic report
quarto render template.qmd --to neurotyp-forensic-typst
```

## Troubleshooting

### PDF Extraction Fails

- Verify Ollama is running: `ollama list`
- Check PDF path in `config.yml`
- Review MCP server logs
- Ensure LLM model is downloaded

### R Code Errors

- Verify R packages installed: `R -e "library(neuro2)"`
- Check R version compatibility
- Review R error messages in Quarto output
- Clear cache: `quarto clean`

### Typst Compilation Errors

- Check Typst installation: `typst --version`
- Verify extension files exist
- Review Typst error messages
- Check font availability

### Missing Variables

- Verify `_variables.yml` is complete
- Check variable names match template usage
- Ensure YAML syntax is correct
- Review Quarto variable substitution

## Performance Optimization

### Caching

Enable R chunk caching for faster re-renders:

```r
knitr::opts_chunk$set(cache = TRUE, autodep = TRUE)
```

### Parallel Processing

Enable parallel data processing:

```yaml
processing:
  parallel: yes
```

### Skip Existing Assets

Skip regenerating plots/tables if they exist:

```r
options(neuro2.skip_if_exists = TRUE)
```

## Output Locations

- **PDF Report**: `output/` directory (configured in `config.yml`)
- **Intermediate Files**: `.quarto/` directory (Quarto cache)
- **JSON Data**: `results/` directory
- **Plots**: Generated inline in report
- **Tables**: Generated inline in report

## Quality Assurance

### Pre-Generation Checks

1. Verify PDF data is complete
2. Check patient information accuracy
3. Confirm test battery matches assessment
4. Validate lookup table entries

### Post-Generation Checks

1. Review PDF for formatting issues
2. Verify all sections included
3. Check table/figure rendering
4. Validate diagnostic codes
5. Confirm signature block
6. Review recommendations completeness

## Integration Points

### MCP Server Integration

The workflow integrates with MCP servers for:

- PDF data extraction
- Clinical interpretation generation
- Natural language processing

### R Package Integration

The workflow uses R packages:

- **neuro2**: Neuropsychological data processing
- **dplyr**: Data manipulation
- **ggplot2**: Data visualization
- **knitr**: Code execution

### External Tools

- **Ollama**: Local LLM backend
- **Typst**: Typesetting engine
- **Quarto**: Document generation framework
