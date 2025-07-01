# Makefile for LaTeX presentation compilation
# Compatible with LaTeX Workshop VS Code extension

# Variables
MAIN_TEX = final_pres_slides.tex
OUTPUT_NAME = final_pres_slides
BUILD_DIR = .build
LATEX_ENGINE = pdflatex
BIBTEX_ENGINE = bibtex

# Default target
.PHONY: all clean cleanall view help

all: $(OUTPUT_NAME).pdf

# Main compilation target
$(OUTPUT_NAME).pdf: $(MAIN_TEX)
	@echo "Compiling LaTeX presentation..."
	@mkdir -p $(BUILD_DIR)
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN_TEX)
	@if [ -f docs/latex/references.bib ]; then \
		echo "Running bibtex..."; \
		cp docs/latex/references.bib $(BUILD_DIR)/; \
		cd $(BUILD_DIR) && $(BIBTEX_ENGINE) $(OUTPUT_NAME); \
		cd .. && $(LATEX_ENGINE) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN_TEX); \
	fi
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN_TEX)
	@if [ -f $(BUILD_DIR)/$(OUTPUT_NAME).pdf ]; then \
		cp $(BUILD_DIR)/$(OUTPUT_NAME).pdf .; \
		echo "Compilation complete: $(OUTPUT_NAME).pdf"; \
	else \
		echo "Error: PDF not generated. Check log files in $(BUILD_DIR)/"; \
		exit 1; \
	fi

# Quick compilation (single pass, no bibliography)
quick: $(MAIN_TEX)
	@echo "Quick compilation..."
	@mkdir -p $(BUILD_DIR)
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN_TEX)
	@if [ -f $(BUILD_DIR)/$(OUTPUT_NAME).pdf ]; then \
		cp $(BUILD_DIR)/$(OUTPUT_NAME).pdf .; \
		echo "Quick compilation complete: $(OUTPUT_NAME).pdf"; \
	else \
		echo "Error: PDF not generated. Check log file: $(BUILD_DIR)/$(OUTPUT_NAME).log"; \
		exit 1; \
	fi

# Simple compilation in current directory (fallback)
simple: $(MAIN_TEX)
	@echo "Simple compilation in current directory..."
	$(LATEX_ENGINE) -interaction=nonstopmode $(MAIN_TEX)
	@echo "Simple compilation complete: $(OUTPUT_NAME).pdf"

# Clean auxiliary files but keep PDF
clean:
	@echo "Cleaning auxiliary files..."
	@rm -rf $(BUILD_DIR)
	@rm -f *.aux *.log *.out *.toc *.nav *.snm *.vrb *.fls *.fdb_latexmk *.synctex.gz

# Clean everything including PDF
cleanall: clean
	@echo "Cleaning all generated files..."
	@rm -f $(OUTPUT_NAME).pdf

# Open PDF viewer (macOS)
view: $(OUTPUT_NAME).pdf
	@if command -v open >/dev/null 2>&1; then \
		open $(OUTPUT_NAME).pdf; \
	else \
		echo "Cannot open PDF viewer. Please open $(OUTPUT_NAME).pdf manually."; \
	fi

# Watch mode (requires entr - install with: brew install entr)
watch:
	@if command -v entr >/dev/null 2>&1; then \
		echo "Watching for changes... Press Ctrl+C to stop."; \
		find . -name "*.tex" -o -name "*.bib" | entr -r make quick; \
	else \
		echo "entr not found. Install with: brew install entr"; \
		echo "Alternatively, use LaTeX Workshop's auto-build feature in VS Code."; \
	fi

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Compile presentation with bibliography (default)"
	@echo "  quick    - Quick compilation (single pass, no bibliography)"
	@echo "  simple   - Simple compilation in current directory (fallback)"
	@echo "  clean    - Remove auxiliary files"
	@echo "  cleanall - Remove all generated files including PDF"
	@echo "  view     - Open the compiled PDF"
	@echo "  watch    - Watch for changes and auto-compile (requires entr)"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "LaTeX Workshop VS Code Extension:"
	@echo "  Use Cmd+Alt+B (macOS) or Ctrl+Alt+B to build"
	@echo "  Use Cmd+Alt+V (macOS) or Ctrl+Alt+V to view PDF"
	@echo ""
	@echo "Troubleshooting:"
	@echo "  If 'make' fails, try 'make simple' for basic compilation"
	@echo "  Check log files in .build/ directory for detailed error messages"

# Force rebuild
force: cleanall all

# Debug compilation with verbose output
debug: $(MAIN_TEX)
	@echo "Debug compilation with verbose output..."
	@mkdir -p $(BUILD_DIR)
	$(LATEX_ENGINE) -output-directory=$(BUILD_DIR) -interaction=errorstopmode $(MAIN_TEX)
	@cp $(BUILD_DIR)/$(OUTPUT_NAME).pdf . 2>/dev/null || echo "PDF not generated due to errors"
