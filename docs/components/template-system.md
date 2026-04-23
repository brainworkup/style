# Template System

The template system uses modular QMD files to compose neuropsychological reports. This enables reusability, maintainability, and flexibility across different report types.

## Template Structure

```text
style/templates/typst-report/
├── template.qmd                    # Main orchestrator
├── _quarto.yml                     # Template configuration
├── _variables.yml                  # Template variables
├── config.yml                       # Template config
├── _00-00_tests.qmd               # Tests section
├── _01-00_nse.qmd                 # NSE section
├── _01-01_behav_obs.qmd           # Behavioral observations
├── _02-05_memory.qmd              # Memory domain
├── _02-06_executive.qmd           # Executive function
├── _02-09_adhd.qmd                # ADHD assessment
├── _02-10_emotion.qmd             # Emotion/psychopathology
├── _03-00_dsm5_icd10_dx.qmd       # Diagnoses
├── _03-00_sirf.qmd                # SIRF summary
├── _03-00_sirf_text.qmd           # SIRF text
├── _03-01_recs.qmd                # Recommendations
├── _03-02_signature.qmd           # Signature
├── _03-03_appendix.qmd            # Appendix
├── _03-03a_informed_consent.qmd   # Informed consent
└── _03-03b_examiner_qualifications.qmd  # Qualifications
```

## Main Template (template.qmd)

The main template orchestrates all sections and sets up the R environment.

### YAML Frontmatter

```yaml
---
title: NEUROCOGNITIVE EXAMINATION
patient: Biggie
name: Smalls, Biggie
doe: "YYYY-MM-DD"
date_of_report: last-modified
---
```

### R Setup Chunk

Configures the R environment:

```r
library(dplyr)
library(readr)
library(here)
library(yaml)
library(neuro2)
neuro2::setup_neuro2()
```

Sets options for:

- LLM backend (Ollama)
- Temperature settings
- Caching behavior
- Font selection
- Figure defaults

### Typst Header Block

```typst
#let case_number = [{{< var case_number >}}]
#let name = [{{< var last_name >}}, {{< var first_name >}}]
#let doe = [{{< var date_of_report >}}]
#let patient = [{{< var patient >}}]
```

### Section Includes

Sections are included using Quarto's include mechanism:

```markdown
{{< include _00-00_tests.qmd >}}
{{< include _01-00_nse.qmd >}}
{{< include _01-01_behav_obs.qmd >}}
{{< include _domains_to_include.qmd >}}
{{< include _03-00_sirf.qmd >}}
{{< include _03-00_sirf_text.qmd >}}
{{< include _03-01_recs.qmd >}}
{{< include _03-02_signature.qmd >}}
{{< include _03-03_appendix.qmd >}}
```

## Section Naming Convention

Sections use a numbered prefix system: `XX-YY_sectionname.qmd`

- **XX**: Major section number (00-99)
- **YY**: Subsection number (00-99)
- **sectionname**: Descriptive name

### Major Sections

| Prefix | Category | Description |
| --- | --- | --- |
| 00 | Header | Tests, assessment battery |
| 01 | Interview | NSE, behavioral observations |
| 02 | Domains | Cognitive domain assessments |
| 03 | Conclusions | Diagnoses, recommendations, appendix |

## Section Components

### 00-00_tests.qmd

Lists all tests administered in the assessment battery.

Includes:

- Test names
- Test versions
- Administration dates
- Test scores (if available)

### 01-00_nse.qmd

Neuropsychological Status Exam (NSE) findings.

Includes:

- Mental status observations
- Behavioral observations during testing
- Test-taking behavior
- Effort and validity indicators

### 01-01_behav_obs.qmd

Detailed behavioral observations.

Includes:

- Patient presentation
- Affect and mood
- Speech and language
- Motor functioning
- Attention and concentration

### 02-XX Domain Sections

Cognitive domain assessments (memory, executive, ADHD, emotion, etc.).

Each domain section includes:

- Test results
- Interpretation
- Clinical significance
- Normative comparisons

### 03-00_dsm5_icd10_dx.qmd

Diagnostic formulations.

Includes:

- DSM-5 diagnoses
- ICD-10 codes
- Diagnostic criteria
- Rule-out considerations

### 03-00_sirf.qmd /_03-00_sirf_text.qmd

Summary of Impairments, Recommendations, and Findings.

Structured summary format with:

- Key findings
- Functional implications
- Summary of recommendations

### 03-01_recs.qmd

Detailed recommendations.

Includes:

- Treatment recommendations
- Academic/work accommodations
- Follow-up recommendations
- Referral recommendations

### 03-02_signature.qmd

Report signature and credentials.

### 03-03 Appendix Sections

Supplementary materials:

- Informed consent
- Examiner qualifications
- Additional documentation

## Variables System

Variables are defined in `_variables.yml` and used throughout templates:

```yaml
patient: Biggie
first_name: Biggie
last_name: Smalls
age: 18
dob: "XXXX-XX-XX"
doe: "2025-01-01"
case_number: "CASE-001"
```

### Variable Usage

In Quarto:

```markdown
{{< var patient >}}
```

In Typst:

```typst
#let patient = [{{< var patient >}}]
```

In R:

```r
patient <- Sys.getenv("PATIENT")
```

## Dynamic Section Inclusion

Sections can be included conditionally based on data availability:

```markdown
{{< include _domains_to_include.qmd >}}
```

The `_domains_to_include.qmd` file dynamically includes domain sections based on available test data.

## Configuration Files

### _quarto.yml

Template-specific Quarto configuration:

```yaml
project:
  type: default
  title: "typst-report"
  execute-dir: project

render:
  - template.qmd

metadata-files:
  - _variables.yml
```

### config.yml

Template configuration (mirrors global config):

```yaml
default:
  patient:
    name: Biggie
    age: 18
  processing:
    use_duckdb: yes
    parallel: yes
```

## Creating New Sections

1. Create new QMD file with appropriate prefix
2. Add section content with R code chunks
3. Use shared variables from `_variables.yml`
4. Add to `template.qmd` include list
5. Test rendering

## Section Best Practices

- Use numbered prefixes for ordering
- Keep sections focused and modular
- Use shared variables for consistency
- Include R code chunks for dynamic content
- Test sections independently before integration
- Document section dependencies
- Follow existing section patterns

## Troubleshooting

### Include Not Working

- Check file path is correct
- Verify file exists
- Check for syntax errors in included file
- Review Quarto render log

### Variables Not Substituted

- Verify variable defined in `_variables.yml`
- Check variable syntax in template
- Ensure variable name matches exactly
- Review Quarto variable scoping

### R Code Not Executing

- Check knitr options in setup chunk
- Verify R packages are installed
- Review R error messages
- Check cache settings
