# Luria Voice — Style

Quarto custom formats and Typst layouts for neuropsychological evaluation reports. This repository is the **rendering layer**: it turns modular `.qmd` manuscripts into PDFs via [Quarto](https://quarto.org/) and [Typst](https://typst.app/), with separate variants for pediatric, adult, and forensic reports.

## What lives here

| Path | Purpose |
|------|---------|
| `_extensions/brainworkup/` | Three sibling extensions — **neurotyp-pediatric**, **neurotyp-adult**, **neurotyp-forensic** — each with `_extension.yml`, `typst-template.typ`, and `typst-show.typ` |
| `templates/typst-report/` | Reference report project: `template.qmd`, `_quarto.yml`, `_variables.yml`, `config.yml`, and numbered section partials |
| `template.qmd` | Top-level entry example (expects section `.qmd` files alongside it, as in the template bundle) |
| `_quarto.yml` | Shared Quarto project defaults (figures, knitr, editor) |
| `docs/` | Architecture notes, ADRs, and workflows |

Each extension targets different typography, paper size, and heading treatment; they intentionally stay separate rather than one format with heavy conditionals.

## Prerequisites

- **Quarto** ≥ 1.4
- **R** (this project pins the R path in `_quarto.yml`; adjust if yours differs)
- **Typst** (bundled with Quarto or installed for Quarto’s Typst backend)
- **Python** ≥ 3.13 is declared in `pyproject.toml` for tooling; the extensions themselves are Quarto/Typst

Report bodies assume your R package and data pipeline (e.g. clinical scoring and optional local LLM options in setup chunks) are configured the way your team uses them.

## Choosing a format

Rendered format ids:

- `neurotyp-pediatric-typst` — default in `templates/typst-report/_quarto.yml`
- `neurotyp-adult-typst`
- `neurotyp-forensic-typst`

From a directory that contains both `template.qmd` and the included section files:

```fish
quarto render template.qmd --to neurotyp-pediatric-typst
quarto render template.qmd --to neurotyp-adult-typst
quarto render template.qmd --to neurotyp-forensic-typst
```

Preview while editing:

```fish
quarto preview template.qmd
```

**Project layout:** Quarto resolves `_extensions` from the project root (the directory that contains your `_quarto.yml`). If you work only inside `templates/typst-report/`, ensure that folder can see the vendored extensions (for example by opening the repo root as the Quarto project, or by linking `_extensions` into the template directory).

**Generated includes:** The sample `template.qmd` includes partials such as `_domains_to_include.qmd` that may be produced or customized by your case pipeline. Without those files, `quarto render` will stop at the missing include — add or generate them for a full build.

## Documentation

- `docs/components/overview.md` — high-level map
- `docs/components/quarto-extensions.md` — per-extension fonts, paper, and options
- `docs/workflows/report-generation.md` — end-to-end report workflow (may reference sibling repos in the full Luria Voice tree)
- `docs/adr/` — decisions (Quarto + Typst, modular template structure, MCP/LLM notes)

## Relationship to the rest of Luria Voice

In the full **Luria Voice** monorepo, **style** (this layer) works with **brand** (shared `brand` spec for theming) and **soul** (local style-learning / drafting tooling). This `style` checkout is useful on its own for maintaining Quarto extensions and the `.qmd`/Typst report skeleton.
