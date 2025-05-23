MAIN = SeminarReport
BUILD_DIR = build
TEX_FILES = $(wildcard chapters/*.tex)

.PHONY: all clean build-dir view watch

all: build-dir $(BUILD_DIR)/$(MAIN).pdf

build-dir:
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(MAIN).pdf: $(MAIN).tex $(TEX_FILES) references.bib
	latexmk -pdf -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(MAIN).tex

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.lof *.log *.lot *.out *.synctex.gz *.toc

view: $(BUILD_DIR)/$(MAIN).pdf
	xdg-open $(BUILD_DIR)/$(MAIN).pdf

watch:
	latexmk -pdf -output-directory=$(BUILD_DIR) -pvc -interaction=nonstopmode $(MAIN).tex

# For LaTeX Workshop compatibility
pdf: all
