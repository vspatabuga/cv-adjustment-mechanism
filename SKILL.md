# CV Producer Skill

## Purpose
Generate professional, factual CVs tailored to specific job postings. **Never overclaim, overproud, or overkill.** Only use data from `data/master.json`.

## Data Source
All CV data comes from **`data/master.json`** — single source of truth. Never invent facts.

## Hard Rules (NON-NEGOTIABLE)

1. **ONLY use data from `data/master.json`** — no external assumptions
2. **NEVER add skills** not listed in the master data
3. **NEVER inflate roles** — use exact job titles from master data
4. **NEVER change dates** — use exact start/end dates from master data
5. **NEVER fabricate metrics** — only use numbers explicitly stated in master data
6. **NEVER claim expertise** unless the master data supports it
7. **DO highlight relevant experience** — select what matches the job
8. **DO reorder sections** — put most relevant first
9. **DO adjust profile summary** — tailor to the job while staying factual
10. **DO omit irrelevant items** — skip what doesn't match the job

## ATS Best Practices (2026 Standard)

### Formatting Rules
- **Single-column layout only** — no tables, no multi-column
- **No icons, graphics, or images** — ATS cannot parse them
- **Standard fonts only** — Times New Roman, Arial, Calibri
- **Standard section headings** — "Experience", "Education", "Skills" (not creative names)
- **Consistent date format** — "Oct 2025 -- Present" or "Jan 2022 - Aug 2022"
- **Bullet points** — use standard `\begin{itemize}` or `- ` in Markdown
- **File format** — PDF (text-based) or .docx (preferred by most ATS)

### Section Order (2026 Standard for Fresh Graduate / Early Career)

```
1. HEADER          (name + contact info)
2. PROFILE         (3-4 lines, keyword-rich, concrete)
3. TECHNICAL SKILLS (grouped by category, curated not exhaustive)
4. EXPERIENCE      (reverse chronological, most relevant first)
5. TRAINING        (relevant training programs, reverse chronological)
6. PROJECTS        (only those that strengthen the job match)
7. EDUCATION       (degree, institution, dates)
8. CERTIFICATIONS  (all relevant certifications)
9. LANGUAGES       (optional, include if relevant)
```

**Why this order:** For fresh graduates, skills and projects are the strongest evidence. Experience comes before Training because the candidate has real work history. Training can be omitted if certifications are sufficient.

### Profile Summary Rules (2026 Standard)
- **Max 3-4 lines** — recruiters scan in 6 seconds
- **Concrete, not buzzwords** — "engineers want signals, not fluff"
- **Keyword-rich** — match terms from job description
- **No "seeking to"** — outdated, focus on value delivered
- **Structure:** Who you are + core experience + key certifications

### Bullet Point Formula (Action + What + How + Result)

**Good:**
> "Managed Linux server infrastructure in Proxmox VE environment, ensuring uptime and security for academic systems"

**Better (with metrics):**
> "Deployed containerized services on resource-constrained environments (GCP e2-micro, 1GB RAM) with memory limits as low as 50MB"

**Rules:**
- Start with **action verb** (Designed, Built, Deployed, Managed, etc.)
- Include **specific technologies** used
- Include **numbers/metrics** if available from master data
- Keep each bullet to **1-2 lines**
- Maximum **3-5 bullets per role**
- **Focus on outcomes, not tasks** — "what changed" not "what I did"

### Skills Selection Rules
- **Max 6-9 categories** — recruiters don't read exhaustive lists
- **Curated, not exhaustive** — "be specific, not exhaustive" (CVailor 2026)
- **Use job posting terms** — "PostgreSQL" not just "SQL"
- **Group logically** — Cloud, Infrastructure, Networking, Programming, etc.
- **Never use skill bars or ratings** — ATS cannot parse them

### Experience Selection Rules
- **Always include**: Most recent role
- **Always include**: Roles directly relevant to the job
- **Include**: Roles that demonstrate required skills
- **May omit**: Roles older than 5 years if not relevant
- **Never omit**: Any role if user explicitly requests full CV

### Training Selection Rules
- **Include**: Training programs that provide relevant skills for the target job
- **Highlight**: Certifications earned from training (move to Certifications section)
- **May omit**: Training older than 3 years if not directly relevant to the job
- **Note**: Trainee roles are in `training` section, not `experience`

### Project Selection Rules
- **Include only if they strengthen the match** — "one strong project beats five half-finished repos" (CVailor 2026)
- **Max 3-5 projects** for fresh graduate
- **Include**: project name, description, technologies used
- **Prioritize**: projects that use technologies mentioned in job description

## Workflow

### Step 1: Analyze Job Description
When user provides a job description or position name:
1. Extract key requirements (skills, tools, experience level)
2. Identify the role type (cloud, devops, backend, etc.)
3. Note the language requirement (English/Indonesian)

### Step 2: Select Relevant Data from master.json
Match job requirements against master data:
- **Skills**: Only include skills that appear in both job requirements AND master data
- **Experience**: Prioritize roles that demonstrate required skills
- **Projects**: Select projects that showcase relevant technologies
- **Certifications**: Include all that are relevant to the position
- **Profile**: Use `profile.en` or `profile.id` as base, modify to emphasize relevant background (factual only)

### Step 3: Generate CV
Output format:
1. **Markdown version** → `output/targeted/{position}/VS-Patabuga_{position}.md`
2. **LaTeX version** → `output/targeted/{position}/VS-Patabuga_{position}.tex`
3. **PDF** → compile LaTeX to PDF (if build tools available)

**File Naming Convention:** `{FullName}_{PositionInKebabCase}`
- Example: `VS-Patabuga_service-desk-engineer.md`

### Step 4: Output Structure
```
output/targeted/{position}/
├── VS-Patabuga_{position}.md
├── VS-Patabuga_{position}.tex
└── VS-Patabuga_{position}.pdf
```

## CV Structure (Standard — 2026 ATS-Optimized)

```
[Full Name]
[Location]
[Phone] | [Email] |[Website] | [LinkedIn] | [GitHub]

PROFILE
[3-4 lines, keyword-rich, concrete]

TECHNICAL SKILLS
[Category]: [skills]
[Category]: [skills]
...

EXPERIENCE
[Selected roles, reverse chronological]
- Title, Company, Dates, Location
- 3-5 bullet points (Action + What + How + Result)

TRAINING
[Selected training programs, reverse chronological]
- Title, Company, Dates, Location
- Brief description and technologies

PROJECTS
[Selected projects that strengthen the match]
- Name, description, technologies

EDUCATION
[Degree, Institution, Dates]

CERTIFICATIONS
[Relevant certifications]

LANGUAGES
[Language (proficiency)]
```

## Language

**PATTERN:** IF job posting language (Deskripsi Pekerjaan / Job Description) is in Indonesian, THEN use Indonesian for CV. ELSE use English.

- **Default**: English
- **Use Indonesian** if job posting is in Indonesian (Bahasa Indonesia)
- **Use `profile.id`** for Indonesian version (from `profile-summary.md`)
- **Use `profile.en`** for English version
- **English level**: B2 — keep sentences simple and natural, avoid overly complex phasing

**Detection Rule:**
- Check the first line of "Deskripsi Pekerjaan" or "Job Description"
- If it contains Indonesian words (like "Memahami", "Memiliki", "Terbiasa", "Kualifikasi", "Pengalaman"), use Indonesian
- If it contains English words (like "Understanding", "Experience", "Qualification"), use English
- Default to English if uncertain or mixed content

**Language Proficiency Translation:**
- Indonesian: Use "Native", NOT "Bahasa Ibu" or "Bahasa Mother"
- English: Use "Professional Working Proficiency (B1)" per master.json

**Accuracy Rules (NON-NEGOTIABLE):**
- ALWAYS use "Native" for Indonesian language proficiency, NOT "Bahasa Ibu" or "Bahasa Mother"
- NEVER include FastAPI unless explicitly in master.json
- ALWAYS verify technology stack against master.json before including
- ALWAYS ask user to confirm BEFORE including honors like "Cum Laude" or "Graduated with Honors" - never assume

## Examples

### User Input
```
Job: Cloud Computing Engineer
Requirements: Python, Linux, AWS/GCP, Docker, CI/CD
```

### Skill Response
1. Analyze: Cloud role, needs Python, Linux, GCP, Docker, CI/CD
2. Select from master:
   - Skills: Python ✅, Linux ✅, GCP ✅, Docker ✅, GitHub Actions (CI/CD) ✅
   - Experience: Principal System Architect (cloud infra), Junior SysAdmin (Linux), Bangkit (GCP)
   - Projects: PES Production Engine (Docker+GCP), PES Infrastructure (Terraform+GCP)
   - Certifications: GCP, CCNA, Python Dicoding
3. Generate tailored CV

## File Locations

- **Master data**: `data/master.json`
- **LaTeX template**: `templates/cv-latex.tex`
- **Markdown template**: `templates/cv-markdown.md`
- **Output**: `output/targeted/`
- **General CV**: `output/general/`

## Contact Info Format

```
[Full Name]
+62 896-9266-6444 | cx@vspatabuga.io | Tangerang Selatan, Indonesia
vspatabuga.io | linkedin.com/in/vspatabuga | github.com/vspatabuga
```

- Phone in **international format** (+62)
- Email, website, LinkedIn, GitHub on **second line**
- Location: **City, Country** only (not full address)
