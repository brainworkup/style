# ADR 003: Modular Template Structure for Report Sections

## Status

Accepted

## Context

Neuropsychological reports require:

- Consistent structure across report types
- Reusable sections (tests, behavioral observations, domains)
- Flexible inclusion based on available data
- Easy maintenance and updates
- Support for multiple report variants (pediatric, adult, forensic)

## Decision

Implement a **modular template system** with separate QMD files for each report section, assembled via Quarto's include mechanism.

### Architecture

- Main `template.qmd` as the orchestrator
- Individual section files (e.g., `_01-00_nse.qmd`, `_02-05_memory.qmd`)
- Numbered prefix system for section ordering
- Dynamic inclusion based on data availability
- Shared variables via `_variables.yml`

### Rationale

**Why Modular**:

- **Reusability**: Same section can be used across multiple report types
- **Maintainability**: Changes to a section only affect that section
- **Flexibility**: Easy to add/remove sections without touching main template
- **Collaboration**: Multiple team members can work on different sections simultaneously
- **Testing**: Individual sections can be tested independently

**Why Numbered Prefixes**:

- Clear ordering (00-00, 01-00, 02-05, etc.)
- First two digits: major section (00=header, 01=interview, 02=domains, 03=conclusions)
- Last two digits: subsection ordering
- Easy to insert new sections without renumbering everything

**Alternatives Considered**:

- **Monolithic template**: Hard to maintain, difficult to collaborate
- **Conditional sections in one file**: Still large, hard to navigate
- **Separate projects per report type**: Code duplication, maintenance nightmare

## Consequences

- Positive: Easy to maintain and update individual sections
- Positive: Reusable across report types
- Positive: Clear structure and organization
- Negative: More files to manage
- Negative: Need to understand include mechanism
- Negative: Variable naming must be consistent across sections

## Implementation

- Main template: `style/templates/typst-report/template.qmd`
- Section files prefixed with numbering system
- Quarto includes: `{{< include _01-00_nse.qmd >}}`
- Dynamic domain inclusion: `{{< include _domains_to_include.qmd >}}`
- Shared variables in `_variables.yml`

## Section Organization

- `00-00`: Tests and assessment battery
- `01-00`: Neuropsychological Status Exam (NSE)
- `01-01`: Behavioral observations
- `02-XX`: Cognitive domains (memory, executive, ADHD, emotion, etc.)
- `03-00`: DSM-5/ICD-10 diagnoses
- `03-00`: SIRF (Summary of Impairments, Recommendations, and Findings)
- `03-01`: Recommendations
- `03-02`: Signature
- `03-03`: Appendix and consent forms

## References

- Quarto includes: <https://quarto.org/docs/projects/code-execution.html#execution-options>
