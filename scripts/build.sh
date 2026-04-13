#!/bin/bash
# Build script for CV generation
# Usage: ./scripts/build.sh [job-name]
# Example: ./scripts/build.sh service-desk-engineer
#
# Each job gets its own folder: output/targeted/{job-name}/
# Output files: VS-Patabuga_{job-name}.{md,tex,pdf}
# File naming: {FullName}_{PositionInKebabCase}

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$ROOT_DIR/templates"
OUTPUT_DIR="$ROOT_DIR/output/targeted"
BUILD_DIR="$ROOT_DIR/.build"

# Default job name
JOB_NAME="${1:-cv-general}"

echo "=== CV Builder ==="
echo "Job: $JOB_NAME"
echo ""

# Create job folder
JOB_DIR="$OUTPUT_DIR/$JOB_NAME"
mkdir -p "$JOB_DIR"
mkdir -p "$BUILD_DIR"

# Check if LaTeX template exists for this job, or use default
LATEX_TEMPLATE="$JOB_DIR/$JOB_NAME.tex"
DEFAULT_TEMPLATE="$TEMPLATE_DIR/cv-latex.tex"

if [ ! -f "$LATEX_TEMPLATE" ]; then
    echo "No .tex file found for job '$JOB_NAME'."
    echo "Please generate the .tex file first, or place it in:"
    echo "  $LATEX_TEMPLATE"
    echo ""
    echo "Using default template as fallback..."
    if [ ! -f "$DEFAULT_TEMPLATE" ]; then
        echo "Error: Default template not found: $DEFAULT_TEMPLATE"
        exit 1
    fi
    cp "$DEFAULT_TEMPLATE" "$LATEX_TEMPLATE"
fi

# Copy to build directory
cp "$LATEX_TEMPLATE" "$BUILD_DIR/$JOB_NAME.tex"

# Check if xelatex is available
if command -v xelatex &> /dev/null; then
    echo "Compiling with xelatex..."
    cd "$BUILD_DIR"
    xelatex -interaction=nonstopmode "$JOB_NAME.tex" > /dev/null 2>&1
    xelatex -interaction=nonstopmode "$JOB_NAME.tex" > /dev/null 2>&1

    if [ -f "$BUILD_DIR/$JOB_NAME.pdf" ]; then
        cp "$BUILD_DIR/$JOB_NAME.pdf" "$JOB_DIR/$JOB_NAME.pdf"
        echo ""
        echo "Success! PDF generated:"
        echo "  $JOB_DIR/$JOB_NAME.pdf"
    else
        echo ""
        echo "Error: PDF compilation failed."
        echo "Check the build log:"
        cat "$BUILD_DIR/$JOB_NAME.log" 2>/dev/null | tail -20
        exit 1
    fi
else
    echo "Warning: xelatex not found. Skipping PDF compilation."
    echo "Install TeX Live: sudo apt install texlive-xetex texlive-fonts-recommended"
    echo ""
    echo "LaTeX file ready at: $JOB_DIR/$JOB_NAME.tex"
    echo "Compile manually: xelatex $JOB_DIR/$JOB_NAME.tex"
fi

# Clean up build artifacts
rm -f "$BUILD_DIR/$JOB_NAME.aux" \
      "$BUILD_DIR/$JOB_NAME.log" \
      "$BUILD_DIR/$JOB_NAME.out" \
      "$BUILD_DIR/$JOB_NAME.toc" \
      "$BUILD_DIR/$JOB_NAME.fls" \
      "$BUILD_DIR/$JOB_NAME.fdb_latexmk" \
      "$BUILD_DIR/$JOB_NAME.synctex.gz" \
      "$BUILD_DIR/$JOB_NAME.xdv"

# Clean up artifacts from job folder (keep .tex, .md, .pdf)
rm -f "$JOB_DIR/$JOB_NAME.aux" \
      "$JOB_DIR/$JOB_NAME.log" \
      "$JOB_DIR/$JOB_NAME.out" \
      "$JOB_DIR"/*.png 2>/dev/null

echo ""
echo "Job folder: $JOB_DIR/"
echo "Files:"
ls -1 "$JOB_DIR/" 2>/dev/null | while read f; do echo "  - $f"; done
echo ""
echo "Done."
