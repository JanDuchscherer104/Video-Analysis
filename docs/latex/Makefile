MAIN = SeminarReport
BUILD_DIR = .build
TEX_FILES = $(wildcard *.tex)
FIGURES = $(wildcard figures/*.png figures/*.pdf figures/*.jpg)

.PHONY: all clean build-dir view watch pdf help debug

# Default target - always clean first for fresh build
all: clean build-dir $(BUILD_DIR)/$(MAIN).pdf

# Create build directory
build-dir:
	@mkdir -p $(BUILD_DIR)

# Main PDF build rule with better error handling
$(BUILD_DIR)/$(MAIN).pdf: $(MAIN).tex $(TEX_FILES) references.bib $(FIGURES) | build-dir
	@echo "Building PDF..."
	@if latexmk -pdf -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN).tex; then \
		echo "Build complete: $(BUILD_DIR)/$(MAIN).pdf"; \
	else \
		echo "Build failed! Check the log file:"; \
		echo "  cat $(BUILD_DIR)/$(MAIN).log | tail -50"; \
		echo "Or run 'make debug' for interactive mode"; \
		exit 1; \
	fi

# Debug build with interactive mode to see errors
debug: | build-dir
	@echo "Running debug build with interactive mode..."
	latexmk -pdf -output-directory=$(BUILD_DIR) -interaction=errorstopmode $(MAIN).tex

# Show last errors from log file
show-errors:
	@echo "Last 50 lines of build log:"
	@if [ -f $(BUILD_DIR)/$(MAIN).log ]; then \
		tail -50 $(BUILD_DIR)/$(MAIN).log; \
	else \
		echo "No log file found. Run 'make' first."; \
	fi

# Clean all generated files
clean:
	@echo "Cleaning build files..."
	rm -rf $(BUILD_DIR)
	rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.lof *.log *.lot *.out *.synctex.gz *.toc
	@echo "Clean complete."

# View the PDF
view: $(BUILD_DIR)/$(MAIN).pdf
	xdg-open $(BUILD_DIR)/$(MAIN).pdf

# Watch mode for continuous compilation
watch: | build-dir
	latexmk -pdf -output-directory=$(BUILD_DIR) -pvc -interaction=nonstopmode $(MAIN).tex

# Force rebuild (ignore timestamps)
rebuild: clean all

# For LaTeX Workshop compatibility
pdf: all

# Check if all required files exist
check:
	@echo "Checking required files..."
	@test -f $(MAIN).tex || (echo "Error: $(MAIN).tex not found!" && exit 1)
	@test -f references.bib || (echo "Error: references.bib not found!" && exit 1)
	@echo "All required files present."

# Help target
help:
	@echo "Available targets:"
	@echo "  all         - Build the PDF (default)"
	@echo "  debug       - Build with interactive error mode"
	@echo "  show-errors - Show last 50 lines of build log"
	@echo "  clean       - Remove all generated files"
	@echo "  view        - Open the PDF in default viewer"
	@echo "  watch       - Continuous compilation mode"
	@echo "  rebuild     - Clean and rebuild"
	@echo "  check       - Check if required files exist"
	@echo "  help        - Show this help message"
