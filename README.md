# VSP CV

CV production system for Virgiawan Sagarmata Patabuga. Generates professional, factual CVs tailored to specific job postings.

## Philosophy

- **Factual only** — all data from `data/master.json`
- **No overclaim** — never add skills, inflate roles, or fabricate metrics
- **Tailored** — select relevant experience for each job
- **Clean output** — professional LaTeX and Markdown formats

## Structure

```
vsp-cv/
├── SKILL.md                    # Instructions for AI-assisted CV generation
├── data/
│   ├── master.json             # Single source of truth — all CV data
│   └── source/                 # Raw CV files from GDrive (gitignored)
├── templates/
│   ├── cv-latex.tex            # LaTeX template (clean, ATS-friendly)
│   └── cv-markdown.md          # Markdown template
├── output/
│   ├── general/                # General CV (PDF)
│   └── targeted/               # Job-specific CVs (gitignored)
├── scripts/
│   └── build.sh                # Compile LaTeX → PDF
└── Makefile                    # Command shortcuts
```

## Quick Start

### Generate General CV

```bash
make general
```

### Generate Job-Specific CV

```bash
make cv JOB="cloud-engineer"
```

### Build PDF from Template

```bash
make build TEMPLATE=cv-latex.tex OUTPUT=cv-general
```

### Clean Build Artifacts

```bash
make clean
```

## Dependencies

- **TeX Live** with XeLaTeX: `sudo apt install texlive-xetex texlive-fonts-recommended`
- **Fonts**: Liberation Serif, Liberation Sans (usually pre-installed)

## Data Source

All CV data is in `data/master.json`. This is the **single source of truth**. The AI skill reads this file to generate tailored CVs.

### Updating Your CV

1. Edit `data/master.json` with new experience, skills, or certifications
2. Run `make general` to regenerate the general CV
3. Or provide a job description to generate a targeted CV

## Rules

When generating CVs:
1. Only use data from `data/master.json`
2. Never add skills not listed in master data
3. Never inflate roles or change dates
4. Never fabricate metrics
5. Highlight relevant experience for the target job
6. Omit irrelevant items (but don't delete from master)
