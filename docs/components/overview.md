# Component Overview

The Voice Style system is a modular neuropsychological report generation framework built on Quarto and Typst. This document provides an overview of all major components and their relationships.

## System Architecture

```text
voice/
├── style/                    # Main style package
│   ├── _extensions/         # Quarto extensions
│   │   └── brainworkup/     # Custom report formats
│   │       ├── neurotyp-adult/
│   │       ├── neurotyp-forensic/
│   │       └── neurotyp-pediatric/
│   └── templates/           # Report templates
│       └── typst-report/    # Typst-based templates
├── config.yml               # Global configuration
├── _quarto.yml              # Quarto project config
├── _variables.yml           # Template variables
└── soul/                    # Processing scripts
```

## Core Components

### 1. Quarto Extensions (`style/_extensions/brainworkup/`)

Custom Quarto format extensions for different report types:

- **neurotyp-pediatric**: Pediatric neuropsychological reports
  - Template: `typst-template.typ`
  - Show rules: `typst-show.typ`
  - Font: Equity B
  - Paper size: A4

- **neurotyp-adult**: Adult neuropsychological reports
  - Template: `typst-template.typ`
  - Show rules: `typst-show.typ`
  - Font: IBM Plex Serif
  - Paper size: US Letter

- **neurotyp-forensic**: Forensic neuropsychological reports
  - Template: `typst-template.typ`
  - Show rules: `typst-show.typ`
  - Font: TeX Gyre Termes
  - Paper size: US Letter

### 2. Template System (`style/templates/typst-report/`)

Modular report templates with reusable sections:

- **template.qmd**: Main orchestrator template
- **Section files**: Individual report sections (numbered prefix system)
- **_quarto.yml**: Template-specific Quarto configuration
- **_variables.yml**: Template variables
- **config.yml**: Template configuration

#### Section Organization

| Prefix | Section | Description |
| --- | --- | --- |
| 00-00 | Tests | Assessment battery and test list |
| 01-00 | NSE | Neuropsychological Status Exam |
| 01-01 | Behav Obs | Behavioral observations |
| 02-XX | Domains | Cognitive domain assessments |
| 03-00 | Diagnoses | DSM-5/ICD-10 diagnoses |
| 03-00 | SIRF | Summary, Impairments, Recommendations, Findings |
| 03-01 | Recs | Recommendations |
| 03-02 | Signature | Report signature |
| 03-03 | Appendix | Appendix and consent forms |

### 3. Configuration System

- **config.yml**: Global project configuration
  - Patient information
  - Data paths
  - Processing options
  - MCP/LLM settings

- **_quarto.yml**: Quarto project configuration
  - Render settings
  - Format definitions
  - Execution options
  - Figure settings

- **_variables.yml**: Template variables
  - Patient demographics
  - Report metadata
  - Dynamic content

### 4. Processing Scripts (`soul/`)

Python scripts for data processing and AI operations:

- **extract_pdf_data.py**: PDF data extraction
- **extract_pdf_data_enhanced.py**: Enhanced PDF extraction
- **neuro_report_style_agent.py**: Report style agent
- **main.py**: Main processing entry point

## Data Flow

```text
Raw PDF (psychological test reports)
    ↓
MCP LLM Extraction (soul/extract_pdf_data.py)
    ↓
Structured Data (JSON/CSV)
    ↓
Quarto Template (template.qmd)
    ↓
R Code Execution (knitr)
    ↓
Typst Rendering
    ↓
Final Report (PDF)
```

## Integration Points

### MCP Integration

- Local LLM backend (Ollama)
- PDF extraction tools
- Clinical interpretation generation
- Lookup table integration

### R Integration

- neuro2 package for neuropsychological data processing
- ggplot2 for data visualization
- dplyr for data manipulation
- knitr for code execution

### Typst Integration

- Custom templates for each report type
- Show rules for consistent styling
- Font management
- Page layout control

## Component Dependencies

```text
template.qmd
    ├── _variables.yml (variables)
    ├── config.yml (configuration)
    ├── neuro2 R package (data processing)
    ├── Quarto extensions (formatting)
    │   ├── neurotyp-pediatric
    │   ├── neurotyp-adult
    │   └── neurotyp-forensic
    └── Section files (content)
        ├── _00-00_tests.qmd
        ├── _01-00_nse.qmd
        ├── _01-01_behav_obs.qmd
        ├── _02-XX_domain.qmd
        └── _03-XX_conclusions.qmd
```

## Extension Points

### Adding New Report Types

1. Create new extension in `style/_extensions/brainworkup/`
2. Define `_extension.yml` with format configuration
3. Create `typst-template.typ` and `typst-show.typ`
4. Add format definition in `_quarto.yml`

### Adding New Sections

1. Create new QMD file with appropriate prefix
2. Add to `template.qmd` include list
3. Use shared variables from `_variables.yml`
4. Follow existing section patterns

### Customizing Processing

1. Modify scripts in `soul/`
2. Update MCP configuration in `config.yml`
3. Add new tools to MCP server
4. Update lookup tables as needed
