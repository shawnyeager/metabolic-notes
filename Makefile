PREFIX ?= $(HOME)/.local
NOTES_DIR ?= $(HOME)/Work/notes
SHELL_RC ?= $(HOME)/.bashrc
NVIM_SITE ?= $(HOME)/.local/share/nvim/site

.PHONY: all install cli nvim aliases uninstall help

all: cli nvim aliases
	@echo ""
	@echo "Done. Restart your shell or run: source $(SHELL_RC)"

install: all

cli:
	@mkdir -p $(PREFIX)/bin
	@cp bin/note $(PREFIX)/bin/note
	@chmod +x $(PREFIX)/bin/note
	@mkdir -p $(NOTES_DIR)/daily $(NOTES_DIR)/extracted
	@if [ ! -f $(NOTES_DIR)/WHAT.md ]; then \
		cp templates/WHAT.md $(NOTES_DIR)/WHAT.md; \
	fi
	@echo "cli  → $(PREFIX)/bin/note"
	@echo "     → $(NOTES_DIR)/"

nvim:
	@mkdir -p $(NVIM_SITE)/lua/metabolic
	@mkdir -p $(NVIM_SITE)/plugin
	@cp lua/metabolic/init.lua $(NVIM_SITE)/lua/metabolic/init.lua
	@cp plugin/metabolic.lua $(NVIM_SITE)/plugin/metabolic.lua
	@echo "nvim → $(NVIM_SITE)/"

aliases:
	@mkdir -p $(HOME)/.local/share/metabolic-notes
	@echo "alias nn='note'" > $(HOME)/.local/share/metabolic-notes/aliases
	@echo "alias nw='note what'" >> $(HOME)/.local/share/metabolic-notes/aliases
	@echo "alias nx='note extract'" >> $(HOME)/.local/share/metabolic-notes/aliases
	@echo "alias nk='note week'" >> $(HOME)/.local/share/metabolic-notes/aliases
	@echo "alias nt='note tags'" >> $(HOME)/.local/share/metabolic-notes/aliases
	@if [ ! -f "$(SHELL_RC)" ]; then \
		echo "aliases: $(SHELL_RC) not found"; \
	elif grep -qF "metabolic-notes/aliases" "$(SHELL_RC)"; then \
		echo "aliases: already in $(SHELL_RC)"; \
	else \
		echo "" >> "$(SHELL_RC)"; \
		echo "# metabolic-notes" >> "$(SHELL_RC)"; \
		echo "source $(HOME)/.local/share/metabolic-notes/aliases" >> "$(SHELL_RC)"; \
	fi
	@echo "aliases → ~/.local/share/metabolic-notes/aliases"

uninstall:
	@rm -f $(PREFIX)/bin/note
	@rm -rf $(NVIM_SITE)/lua/metabolic
	@rm -f $(NVIM_SITE)/plugin/metabolic.lua
	@rm -rf $(HOME)/.local/share/metabolic-notes
	@if grep -qF "metabolic-notes/aliases" "$(SHELL_RC)" 2>/dev/null; then \
		sed '/# metabolic-notes/d; /metabolic-notes\/aliases/d' "$(SHELL_RC)" > "$(SHELL_RC).tmp" && \
		mv "$(SHELL_RC).tmp" "$(SHELL_RC)"; \
	fi
	@echo "Removed $(PREFIX)/bin/note"
	@echo "Removed $(NVIM_SITE)/lua/metabolic/"
	@echo "Removed $(NVIM_SITE)/plugin/metabolic.lua"
	@echo "Removed ~/.local/share/metabolic-notes/"
	@echo "Notes preserved at $(NOTES_DIR)"

help:
	@echo "Usage: make [target] [VAR=value]"
	@echo ""
	@echo "Targets:"
	@echo "  all       Install everything (default)"
	@echo "  cli       Install note script + create notes dirs"
	@echo "  nvim      Install Neovim plugin"
	@echo "  aliases   Add shell aliases to config"
	@echo "  uninstall Remove cli + nvim (preserves notes)"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX    Install prefix ($(PREFIX))"
	@echo "  NOTES_DIR Notes directory ($(NOTES_DIR))"
	@echo "  SHELL_RC  Shell config ($(SHELL_RC))"
	@echo "  NVIM_SITE Neovim site dir ($(NVIM_SITE))"
