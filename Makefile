SRC       ?= init.el
DEST_DIR  ?= $(HOME)/.emacs.d
DEST      := $(DEST_DIR)/$(notdir $(SRC))
KEEP      ?= 5

.PHONY: install diff backups prune help

help:
	@echo "make install   Install $(SRC) to $(DEST) (backup first if it differs)"
	@echo "make diff      Show diff between repo and installed file"
	@echo "make backups   List current backups"
	@echo "make prune     Keep only the $(KEEP) newest backups"
	@echo ""
	@echo "Variables: SRC ($(SRC)) DEST_DIR ($(DEST_DIR)) KEEP ($(KEEP))"

install:
	@mkdir -p "$(DEST_DIR)"
	@if [ -f "$(DEST)" ] && cmp -s "$(SRC)" "$(DEST)"; then \
		echo "Up to date: $(DEST) (skipped)"; \
	else \
		if [ -f "$(DEST)" ]; then \
			ts=$$(date +%Y%m%d-%H%M%S); \
			bak="$(DEST).bak.$$ts"; \
			cp -p "$(DEST)" "$$bak"; \
			echo "Backed up: $(DEST) -> $$bak"; \
		fi; \
		cp -p "$(SRC)" "$(DEST)"; \
		echo "Installed: $(SRC) -> $(DEST)"; \
	fi
	@$(MAKE) --no-print-directory prune KEEP=$(KEEP)

diff:
	@if [ -f "$(DEST)" ]; then \
		diff -u "$(DEST)" "$(SRC)" || true; \
	else \
		echo "$(DEST) does not exist yet"; \
	fi

backups:
	@ls -1t "$(DEST)".bak.* 2>/dev/null || echo "No backups found"

prune:
	@ls -1t "$(DEST)".bak.* 2>/dev/null | tail -n +$$(($(KEEP)+1)) | while read -r f; do \
		rm -f "$$f"; \
		echo "Removed old backup: $$f"; \
	done
