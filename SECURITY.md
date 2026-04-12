# Security Policy

## Reporting
Laporkan masalah keamanan via GitHub Issue dengan label `security` atau email `sc@vspatabuga.io`.

## Stack
- Makefile + LaTeX build pipeline.
- Data assets di `data/master.json` (no secrets committed).

## Dependency Monitoring
- Dependabot watches `github-actions` workflows (if any) and `npm` packages if introduced later.
