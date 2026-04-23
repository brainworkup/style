# ADR 001: Choose Quarto + Typst for Report Generation

## Status

Accepted

## Context

The Voice project requires generating professional neuropsychological evaluation reports with:

- Complex document structure (multiple sections, headers, tables)
- Professional typography and formatting
- Reproducible builds
- Support for multiple report types (pediatric, adult, forensic)
- Integration with R code execution for data visualization
- Version control and collaboration support

## Decision

We selected **Quarto** as the document generation framework with **Typst** as the typesetting engine.

### Rationale

**Quarto**:

- Built on top of Pandemic/Pandoc with enhanced features
- Native support for R code chunks via knitr
- Excellent for scientific and technical writing
- Supports multiple output formats (PDF, HTML, Word, etc.)
- Strong integration with R ecosystem (ggplot2, dplyr, etc.)
- YAML-based configuration for reproducible builds
- Active community and long-term support

**Typst**:

- Modern typesetting system (LaTeX alternative)
- Faster compilation than LaTeX
- More intuitive syntax
- Better error messages
- Native Unicode support
- Growing ecosystem and community

**Alternatives Considered**:

- **LaTeX**: Powerful but steep learning curve, slow compilation, complex error messages
- **Pandoc alone**: Less structured, harder to maintain complex templates
- **Word templates**: Not reproducible, no code execution, poor version control

## Consequences

- Positive: Professional output with reproducible builds
- Positive: Easy to maintain and version control
- Positive: Strong community support
- Negative: Learning curve for team members unfamiliar with Quarto/Typst
- Negative: Typst ecosystem is newer than LaTeX (fewer packages)

## Implementation

- Created Quarto extensions in `style/_extensions/brainworkup/`
- Implemented Typst templates for pediatric, adult, and forensic reports
- Configured Quarto project in `style/templates/typst-report/_quarto.yml`
- Set up variable substitution system via `_variables.yml`

## References

- Quarto documentation: <https://quarto.org/>
- Typst documentation: <https://typst.app/docs/>
