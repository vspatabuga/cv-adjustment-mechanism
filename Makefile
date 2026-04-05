.PHONY: general cv build clean install-deps help

# Default: build general CV
general: build

# Build a targeted CV (usage: make cv JOB=it-support-vista-jaya-raya)
cv:
	@bash scripts/build.sh $(JOB)

# Build PDF from template
build:
	@bash scripts/build.sh cv-general

# Clean build artifacts
clean:
	@rm -rf .build/
	@echo "Build artifacts cleaned."

# Install LaTeX dependencies
install-deps:
	@echo "Installing TeX Live dependencies..."
	sudo apt update && sudo apt install -y texlive-xetex texlive-fonts-recommended fonts-liberation
	@echo "Dependencies installed."

# List all generated CVs
list:
	@echo "Generated CVs:"
	@ls -1 output/targeted/ 2>/dev/null | while read d; do echo "  - $$d"; done

# Show help
help:
	@echo "VSP CV - Makefile Commands"
	@echo ""
	@echo "  make general          Build general CV PDF"
	@echo "  make cv JOB=name      Build targeted CV (e.g. it-support-vista)"
	@echo "  make build            Alias for make general"
	@echo "  make clean            Remove build artifacts"
	@echo "  make install-deps     Install TeX Live and fonts"
	@echo "  make list             List all generated CVs"
	@echo "  make help             Show this help"
