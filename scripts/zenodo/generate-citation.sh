#!/bin/bash
# Generate CITATION.cff files for all research projects
# Usage: ./generate-citation.sh [all|repo-name]

GH_ORG="patabuga"

generate_citation() {
  local repo_name="$1"
  local title="$2"
  local abstract="$3"
  local keywords="$4"
  local version="${5:-1.0.0}"
  local release_date="${6:-2026-04-05}"

  echo "Generating CITATION.cff for $repo_name..."

  # Convert keywords to YAML list
  keywords_yaml=$(echo "$keywords" | tr ',' '\n' | sed 's/^/- /')

  citation=$(cat << CITEEOF
cff-version: 1.2.0
message: "If you use this software, please cite it as below."
title: "$title"
type: software
authors:
  - family-names: Patabuga
    given-names: Virgiawan Sagarmata
    affiliation: Patabuga Enterprise
    orcid: "https://orcid.org/0009-0003-7843-0919"
abstract: >
  $abstract
license: MIT
version: "$version"
date-released: "$release_date"
url: "https://github.com/$GH_ORG/$repo_name"
repository-code: "https://github.com/$GH_ORG/$repo_name"
keywords:
$keywords_yaml
CITEEOF
)

  echo "$citation"
}

# Research projects
declare -A TITLES=(
  ["zero-trust-network"]="Zero-Trust Network Architecture"
  ["sovereign-cloud-fabric"]="Sovereign Cloud Fabric"
  ["ai-governance-orchestrator"]="AI Governance Orchestrator"
  ["evote-blockchain-dapps"]="E-Vote Blockchain dApp"
)

declare -A ABSTRACTS=(
  ["zero-trust-network"]="Identity-centric Zero-Trust network prototype with WireGuard, Tailscale, and Cloudflare Tunnel for sovereign infrastructure. Replaces traditional trusted perimeter with strict verification for every device and user."
  ["sovereign-cloud-fabric"]="Multi-cloud Terraform orchestration framework for managing distributed digital infrastructure across Azure, GCP, and AWS. Ensures control plane independence from any single provider."
  ["ai-governance-orchestrator"]="Private AI agent orchestration and automated system auditing with strict context isolation and observability. Manages local LLM workflows via OpenClaw, Ollama, and Arize Phoenix."
  ["evote-blockchain-dapps"]="Decentralized voting application using Ethereum smart contracts for secure, transparent, and immutable digital voting. Demonstrates blockchain integration with AI governance for audit anchoring."
)

declare -A KEYWORDS=(
  ["zero-trust-network"]="zero-trust, network-security, wireguard, tailscale, cloudflare, sovereign-infrastructure"
  ["sovereign-cloud-fabric"]="multi-cloud, terraform, infrastructure-as-code, cloud-orchestration, sovereign-infrastructure"
  ["ai-governance-orchestrator"]="ai-governance, llm-orchestration, observability, sovereign-ai, openclaw, ollama"
  ["evote-blockchain-dapps"]="blockchain, ethereum, smart-contracts, e-voting, decentralized"
)

if [ "$1" = "all" ] || [ -z "$1" ]; then
  for repo_name in "${!TITLES[@]}"; do
    citation=$(generate_citation "$repo_name" "${TITLES[$repo_name]}" "${ABSTRACTS[$repo_name]}" "${KEYWORDS[$repo_name]}")
    echo "=== CITATION.cff for $repo_name ==="
    echo "$citation"
    echo ""
  done
else
  if [ -n "${TITLES[$1]}" ]; then
    generate_citation "$1" "${TITLES[$1]}" "${ABSTRACTS[$1]}" "${KEYWORDS[$1]}"
  else
    echo "❌ Repository '$1' not found"
    echo "Available: ${!TITLES[@]}"
    exit 1
  fi
fi
