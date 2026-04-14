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
├── SKILL.md                    # AI instructions for CV generation
├── LICENSE                     # Apache 2.0 License
├── SECURITY.md                 # Security vulnerability reporting
├── Makefile                    # Build shortcuts
├── data/
│   ├── master.json             # Single source of truth — all CV data
│   ├── source/                 # Raw CV files from GDrive (gitignored)
│   └── additional/             # Supplementary files (certificates, projects)
├── templates/
│   ├── cv-latex.tex            # LaTeX template (ATS-friendly)
│   └── cv-markdown.md          # Markdown template
├── output/
│   ├── general/                # General CV (PDF)
│   └── targeted/               # Job-specific CVs (gitignored)
├── scripts/
│   ├── build.sh                # Compile LaTeX → PDF
│   └── zenodo/                 # Research deposit scripts
└── .github/                    # GitHub Actions CI/CD
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

### List All Generated CVs

```bash
make list
```

### Clean Build Artifacts

```bash
make clean
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make general` | Build general CV PDF |
| `make cv JOB=name` | Build targeted CV for specific job |
| `make build` | Alias for general |
| `make list` | List all generated targeted CVs |
| `make clean` | Remove build artifacts |
| `make install-deps` | Install TeX Live dependencies |
| `make help` | Show help |

## Dependencies

- **TeX Live** with XeLaTeX: `sudo apt install texlive-xetex texlive-fonts-recommended`
- **Fonts**: Liberation Serif, Liberation Sans (usually pre-installed)

Or simply run: `make install-deps`

## Data Source

All CV data is in `data/master.json`. This is the **single source of truth**. The AI skill reads this file to generate tailored CVs.

### Updating Your CV

1. Edit `data/master.json` with new experience, skills, or certifications
2. Run `make general` to regenerate the general CV
3. Or provide a job description to generate a targeted CV

## Generated CVs

This system has generated targeted CVs for:

- Software Engineer — Dexa Group
- IT Cloud Engineer — TAFS
- IT Staff — Indofood
- Service Desk Engineer
- IT Quality Assurance — GDPS
- IT Developer Specialist — OTG
- DevOps Engineer
- IT Support — Vista Jaya Raya
- Full Stack Developer — Japfa
- IT Graduate Program — Sampoerna

See all: `make list`

## Security & Integrity

- CV generation strictly uses `data/master.json` as the single source of truth.
- Do not check secrets (`data/source/`, targeted outputs, or `.env`) into GitHub.
- Report vulnerabilities via GitHub Issue with label `security` or email `sc@vspatabuga.io`.
- Maintain transparency: no fabricated metrics, no inflated roles.

## License

Apache License 2.0 © 2026 Virgiawan Sagarmata Patabuga.
