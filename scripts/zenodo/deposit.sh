#!/bin/bash
# Zenodo Deposit Script
# Creates a new deposit on Zenodo and returns the deposit ID
# Usage: ./deposit.sh <title> <description> <keywords> <creators>

set -e

ZENODO_API="https://sandbox.zenodo.org/api"
# For production, use: https://zenodo.org/api
ZENODO_API="https://zenodo.org/api"
TOKEN=$(pass show infrastructure/zenodo/api_token)

TITLE="${1:-Research Software}"
DESCRIPTION="${2:-Research software developed by Patabuga Enterprise}"
KEYWORDS="${3:-research,software}"
CREATORS="${4:-Patabuga, Virgiawan Sagarmata}"
VERSION="${5:-1.0.0}"
LICENSE="${6:-mit}"
UPLOAD_TYPE="${7:-software}"

echo "=== Zenodo Deposit ==="
echo "Title: $TITLE"
echo "Description: $DESCRIPTION"
echo "Keywords: $KEYWORDS"
echo "Version: $VERSION"
echo ""

# Create deposit metadata
METADATA=$(cat << JSONEOF
{
  "metadata": {
    "title": "$TITLE",
    "description": "$DESCRIPTION",
    "upload_type": "$UPLOAD_TYPE",
    "access_right": "open",
    "license": "$LICENSE",
    "version": "$VERSION",
    "keywords": [$(echo "$KEYWORDS" | sed 's/,/","/g' | sed 's/^/"/;s/$/"/' | sed 's/","/","/g')],
    "creators": [
      {
        "name": "$CREATORS",
        "affiliation": "Patabuga Enterprise"
      }
    ]
  }
}
JSONEOF
)

echo "Creating deposit..."
RESPONSE=$(curl -s -X POST "$ZENODO_API/deposit/depositions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "$METADATA")

DEPOSIT_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
DEPOSIT_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('links',{}).get('html',''))" 2>/dev/null)

if [ -n "$DEPOSIT_ID" ] && [ "$DEPOSIT_ID" != "" ]; then
  echo "✅ Deposit created successfully!"
  echo "   Deposit ID: $DEPOSIT_ID"
  echo "   URL: $DEPOSIT_URL"
  echo "$DEPOSIT_ID"
else
  echo "❌ Failed to create deposit"
  echo "Response: $RESPONSE"
  exit 1
fi
