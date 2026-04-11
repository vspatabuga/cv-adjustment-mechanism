#!/bin/bash
# Zenodo Research Publisher
# Publishes research projects from Patabuga GitHub org to Zenodo
# Usage: ./publish-research.sh [all|repo-name]

set -e

TOKEN=$(pass show infrastructure/zenodo/api_token)
ZENODO_API="https://zenodo.org/api"
GH_ORG="patabuga"

# Research projects to publish
REPOS=(
  "zero-trust-network|Zero-Trust Network Architecture|Identity-centric Zero-Trust network prototype with WireGuard, Tailscale, and Cloudflare Tunnel for sovereign infrastructure|zero-trust,network-security,wireguard,tailscale,cloudflare,sovereign-infrastructure"
  "sovereign-cloud-fabric|Sovereign Cloud Fabric|Multi-cloud Terraform orchestration framework for managing distributed digital infrastructure across Azure, GCP, and AWS|multi-cloud,terraform,infrastructure-as-code,cloud-orchestration,sovereign-infrastructure"
  "ai-governance-orchestrator|AI Governance Orchestrator|Private AI agent orchestration and automated system auditing with strict context isolation and observability|ai-governance,llm-orchestration,observability,sovereign-ai,openclaw,ollama"
  "evote-blockchain-dapps|E-Vote Blockchain dApp|Decentralized voting application using Ethereum smart contracts for secure, transparent, and immutable digital voting|blockchain,ethereum,smart-contracts,e-voting,decentralized"
)

publish_repo() {
  local repo_name="$1"
  local title="$2"
  local description="$3"
  local keywords="$4"

  echo "=========================================="
  echo "📦 Publishing: $repo_name"
  echo "=========================================="

  # Check if release exists
  release=$(gh release list -R "$GH_ORG/$repo_name" 2>/dev/null | head -1)
  if [ -z "$release" ]; then
    echo "⚠️  No release found for $repo_name. Creating v1.0.0..."
    gh release create v1.0.0 \
      -R "$GH_ORG/$repo_name" \
      --title "v1.0.0 - Initial Release" \
      --notes "First stable release of $title" \
      --generate-notes 2>/dev/null || true
  fi

  # Create Zenodo deposit
  echo "📝 Creating Zenodo deposit..."
  metadata=$(cat << JSONEOF
{
  "metadata": {
    "title": "$title",
    "description": "$description",
    "upload_type": "software",
    "access_right": "open",
    "license": "mit",
    "version": "1.0.0",
    "keywords": [$(echo "$keywords" | tr ',' '\n' | sed 's/.*/"&"/' | tr '\n' ',' | sed 's/,$//')],
    "creators": [
      {
        "name": "Patabuga, Virgiawan Sagarmata",
        "affiliation": "Patabuga Enterprise"
      }
    ],
    "related_identifiers": [
      {
        "identifier": "https://github.com/$GH_ORG/$repo_name",
        "relation": "isSupplementTo",
        "scheme": "url"
      }
    ]
  }
}
JSONEOF
)

  response=$(curl -s -X POST "$ZENODO_API/deposit/depositions" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$metadata")

  deposit_id=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

  if [ -z "$deposit_id" ] || [ "$deposit_id" = "" ]; then
    echo "❌ Failed to create deposit for $repo_name"
    echo "Response: $response"
    return 1
  fi

  echo "✅ Deposit created: $deposit_id"

  # Download repo as zip
  echo "📥 Downloading repository..."
  zip_file="/tmp/${repo_name}-v1.0.0.zip"
  curl -sL "https://github.com/$GH_ORG/$repo_name/archive/refs/tags/v1.0.0.zip" -o "$zip_file"

  if [ ! -f "$zip_file" ]; then
    echo "❌ Failed to download repository"
    return 1
  fi

  # Upload zip to deposit
  echo "📤 Uploading to Zenodo..."
  upload_response=$(curl -s -X POST "$ZENODO_API/deposit/depositions/$deposit_id/files" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"filename\":\"${repo_name}-v1.0.0.zip\"}")

  bucket_url=$(echo "$upload_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('links',{}).get('upload',''))" 2>/dev/null)

  if [ -n "$bucket_url" ]; then
    curl -s --upload-file "$zip_file" "$bucket_url" > /dev/null
    echo "✅ File uploaded"
  fi

  # Publish
  echo "🚀 Publishing to Zenodo..."
  publish_response=$(curl -s -X POST "$ZENODO_API/deposit/depositions/$deposit_id/actions/publish" \
    -H "Authorization: Bearer $TOKEN")

  doi=$(echo "$publish_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('doi',''))" 2>/dev/null)
  doi_url=$(echo "$publish_response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('links',{}).get('doi',''))" 2>/dev/null)

  if [ -n "$doi" ] && [ "$doi" != "" ]; then
    echo "✅ Published successfully!"
    echo "   DOI: $doi"
    echo "   URL: $doi_url"
    echo ""
    echo "   Badge: [![DOI](https://zenodo.org/badge/DOI/$doi.svg)](https://doi.org/$doi)"
  else
    echo "⚠️  Deposit created but not auto-published"
    echo "   Manual publish: $ZENODO_API/deposit/depositions/$deposit_id/actions/publish"
  fi

  # Cleanup
  rm -f "$zip_file"
  echo ""
}

# Main
if [ "$1" = "all" ] || [ -z "$1" ]; then
  echo "🚀 Patabuga Enterprise — Zenodo Research Publisher"
  echo "Publishing ${#REPOS[@]} research projects to Zenodo"
  echo ""
  for repo_data in "${REPOS[@]}"; do
    IFS='|' read -r repo_name title description keywords <<< "$repo_data"
    publish_repo "$repo_name" "$title" "$description" "$keywords"
  done
  echo "🎉 All projects processed!"
else
  # Find specific repo
  found=false
  for repo_data in "${REPOS[@]}"; do
    IFS='|' read -r repo_name title description keywords <<< "$repo_data"
    if [ "$repo_name" = "$1" ]; then
      publish_repo "$repo_name" "$title" "$description" "$keywords"
      found=true
      break
    fi
  done
  if [ "$found" = false ]; then
    echo "❌ Repository '$1' not found in research projects list"
    echo "Available: $(echo "${REPOS[@]}" | tr ' ' '\n' | cut -d'|' -f1 | tr '\n' ', ')"
    exit 1
  fi
fi
