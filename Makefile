# Top-level orchestrator for the CNN-Accelerator repository.
#
# This does NOT replace the Makefiles already living in rtl/ and
# packages/*; it just drives them from one place and fills in the
# steps that were still manual (submodule init, aggregate clean).
#
# Usage:
#   make            -> submodules + all packages + rtl sim build
#   make packages   -> just the C++/Python tool packages
#   make rtl        -> just the RTL simulation build
#   make hal APP_DIR=<path-to-generated-app>
#                   -> build the RISC-V HAL/firmware (see materials/hal/Makefile)
#   make clean      -> clean every component
#   make distclean   -> clean + deinit submodules

SHELL := /bin/bash

# Tool packages with their own Makefile (2 native + 2 submodules)
PACKAGE_DIRS := \
	packages/Text-Converter \
	packages/Code-Converter \
	packages/PC-Tracer \
	packages/CNN-Compiler \
	packages/CNN-DRAM-Data-Gen

CLEAN_DIRS := $(PACKAGE_DIRS) rtl materials/hal

.PHONY: all submodules packages $(PACKAGE_DIRS) hal rtl \
        deps check-tools clean distclean

# hal is intentionally left out of "all": it needs APP_DIR (a generated
# per-network application) that isn't checked into this repo.
all: submodules packages rtl

# --- Git submodules: packages/CNN-Compiler, packages/CNN-DRAM-Data-Gen ---
submodules: deps
	@git submodule update --init --recursive

# --- Standalone C++/Python tool packages ---
packages: submodules $(PACKAGE_DIRS)

$(PACKAGE_DIRS):
	@printf '>>> building %s\n' "$@"
	@$(MAKE) -C $@ all

# --- RISC-V HAL / firmware (see materials/hal/Makefile for variables) ---
hal:
	@$(MAKE) -C materials/hal all

# --- RTL simulation build (VHDL/Verilog via ModelSim/Questa) ---
rtl:
	@$(MAKE) -C rtl all

# --- Housekeeping ---
deps: check-tools

check-tools:
	@command -v git >/dev/null 2>&1 || { printf '%s\n' "Missing git" >&2; exit 1; }

clean:
	@for d in $(CLEAN_DIRS); do \
		printf '>>> cleaning %s\n' "$$d"; \
		$(MAKE) -C $$d clean; \
	done

distclean: clean
	@git submodule deinit -f --all
