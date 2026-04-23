# Quarto Extensions

Quarto extensions provide custom format definitions for different neuropsychological report types. Each extension defines Typst templates, show rules, and formatting specifications.

## Extension Structure

```text
style/_extensions/brainworkup/
├── neurotyp-adult/
│   ├── _extension.yml
│   ├── typst-show.typ
│   └── typst-template.typ
├── neurotyp-forensic/
│   ├── _extension.yml
│   ├── typst-show.typ
│   └── typst-template.typ
└── neurotyp-pediatric/
    ├── _extension.yml
    ├── typst-show.typ
    └── typst-template.typ
```

## Extension Configuration

Each extension is defined by `_extension.yml`:

```yaml
title: Neurotyp-Pediatric Neuropsychological Report Template using Typst in Quarto
author: Joey Trampush, PhD
version: 0.1.9999
quarto-required: ">=1.4.0"
contributes:
  formats:
    typst:
      template-partials:
        - typst-template.typ
        - typst-show.typ
```

### Configuration Fields

- **title**: Extension name and description
- **author**: Extension author
- **version**: Semantic version
- **quarto-required**: Minimum Quarto version
- **contributes.formats**: Format contributions (Typst)
- **template-partials**: Typst template files

## neurotyp-pediatric

Pediatric neuropsychological report format.

### Specifications

- **Font**: Equity B
- **Paper size**: A4
- **Font size**: 11.5pt
- **Heading font**: Source Sans 3
- **Number sections**: No
- **Citation style**: APA

### Pediatric Use Case

For pediatric patients (typically under 18 years old) requiring:

- Developmental considerations
- Age-appropriate norms
- Educational implications
- Family-focused recommendations

## neurotyp-adult

Adult neuropsychological report format.

### Adult Specifications

- **Font**: IBM Plex Serif
- **Paper size**: US Letter
- **Font size**: 11.5pt
- **Heading font**: IBM Plex Sans
- **Number sections**: No
- **Citation style**: APA

### Adult Use Case

For adult patients (18+ years) requiring:

- Work-related assessments
- Disability evaluations
- Cognitive aging assessments
- Neurological condition evaluations

## neurotyp-forensic

Forensic neuropsychological report format.

### Forensic Specifications

- **Font**: TeX Gyre Termes
- **Paper size**: US Letter
- **Font size**: 12pt
- **Heading font**: IBM Plex Sans
- **Number sections**: No
- **Citation style**: APA

### Forensic Use Case

For forensic evaluations requiring:

- Legal standards adherence
- Detailed methodology documentation
- Comprehensive disclaimer sections
- Expert witness testimony preparation

## Typst Templates

### typst-template.typ

Defines the document structure, page layout, and global settings.

Key elements:

- Page geometry (margins, headers, footers)
- Document metadata
- Font definitions
- Section styling
- Table of contents (if needed)

### typst-show.typ

Defines show rules for content styling.

Key elements:

- Heading styles
- Paragraph spacing
- List formatting
- Table styling
- Figure captions
- Block quotes
- Code blocks

## Format Selection in Quarto

Formats are selected in the template's `_quarto.yml`:

```yaml
format:
  neurotyp-pediatric-typst:
    keep-typ: true
    keep-md: true
    papersize: "a4"
    font: "Equity B"
    heading-family: "Source Sans 3"
    fontsize: 11.5pt
    # ... additional settings
```

## Creating New Extensions

To create a new report type extension:

1. Create directory: `style/_extensions/brainworkup/new-report-type/`
2. Create `_extension.yml` with format definition
3. Create `typst-template.typ` with document structure
4. Create `typst-show.typ` with styling rules
5. Add format to template's `_quarto.yml`
6. Test with sample data

## Extension Versioning

Extensions use semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes

Current version: 0.1.9999 (development)

## Troubleshooting

### Extension Not Found

- Verify extension path in `_quarto.yml`
- Check `_extension.yml` syntax
- Ensure Quarto version requirement met

### Typst Compilation Errors

- Check `typst-template.typ` syntax
- Verify font availability
- Check show rule definitions
- Review Typst error messages

### Format Not Applied

- Verify format name in `_quarto.yml`
- Check extension is loaded
- Ensure template-partials are correct
- Review Quarto render output
