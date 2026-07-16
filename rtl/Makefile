# Top-level orchestrator for the CNN-Accelerator repository.
#
# This does NOT replace the Makefiles already living in rtl/ and
# packages/*; it drives them from one place, fills in the steps that
# were still manual, and logs everything under report/.
#
#   make                -> submodules + all packages + rtl sim build
#   make packages       -> just the C++/Python tool packages
#   make rtl            -> just the RTL simulation build
#   make check-tools    -> report on every tool this project needs
#   make install-tools  -> best-effort install of what apt/pip can provide
#   make run ...         -> full network-to-bitstream-input pipeline, see below
#   make clean           -> clean every component + run artifacts
#   make distclean       -> clean + deinit submodules
#
# ------------------------------------------------------------------
# make run: network -> DRAM data -> firmware -> memory-init files -> rtl
# ------------------------------------------------------------------
#   make run \
#       NETWORK=materials/networks/network_5.json \
#       DRAM_INPUTS="path/in_1.npy path/in_2.npy" \
#       DRAM_WEIGHTS="path/w_1.npy path/w_2.npy" \
#       HAL_DIR=materials/hal \
#       BOOT_DIR=materials/boot \
#       CORE=aftab            # or: CORE=biriscv
#
# See the "run" target below for exactly what each step does.

SHELL := /bin/bash

REPORT_DIR := report

# $(call LOG,<log-name>,<shell command>) runs a command, tees its
# combined stdout/stderr into report/<log-name>.log, and still fails
# the build if the command fails (pipefail).
LOG = @mkdir -p $(REPORT_DIR); set -o pipefail; ( $(2) ) 2>&1 | tee "$(REPORT_DIR)/$(1).log"

# Tool packages with their own Makefile (2 native + 2 submodules)
PACKAGE_DIRS := \
	packages/Text-Converter \
	packages/Code-Converter \
	packages/PC-Tracer \
	packages/CNN-Compiler \
	packages/CNN-DRAM-Data-Gen

CLEAN_DIRS := $(PACKAGE_DIRS) rtl materials/hal

# RISC-V cross toolchain prefix. Debian/Ubuntu's apt package installs
# riscv64-unknown-elf-*, which also targets rv32im via -march; if that's
# what you have, override with CROSS=riscv64-unknown-elf.
CROSS ?= riscv32-unknown-elf

.PHONY: all submodules packages $(PACKAGE_DIRS) hal rtl \
        deps check-tools install-tools \
        run check-run-vars check-run-tools \
        clean clean-run distclean

# hal/run are intentionally left out of "all": they need a specific
# network + DRAM data supplied via variables, see "make run" above.
all: submodules packages rtl

# --- Git submodules: packages/CNN-Compiler, packages/CNN-DRAM-Data-Gen ---
submodules:
	$(call LOG,submodules,git submodule update --init --recursive)

# --- Standalone C++/Python tool packages ---
packages: submodules $(PACKAGE_DIRS)

$(PACKAGE_DIRS):
	$(call LOG,build-$(subst /,-,$@),$(MAKE) -C $@ all)

# --- RTL simulation build (VHDL/Verilog via ModelSim/Questa) ---
rtl:
	$(call LOG,rtl-build,$(MAKE) -C rtl all)

# ------------------------------------------------------------------
# Tool checking / best-effort install
# ------------------------------------------------------------------
deps: check-tools

# Tools needed somewhere in this project:
#   git, g++, curl              -> submodules + packages/*
#   python3, numpy              -> packages/CNN-DRAM-Data-Gen (IDG/WDG)
#   riscv32-unknown-elf-{gcc,objdump} (or CROSS override) -> firmware build
#   sed                         -> rtl/packages/MY_Pack_v2.vhd core select
#   vlib, vmap, vcom, vlog, vsim -> rtl/ simulation (ModelSim/Questa)
check-tools:
	@mkdir -p $(REPORT_DIR)
	@{ \
		echo "Tool check @ $$(date)"; \
		ok=1; \
		for t in git g++ curl python3 sed $(CROSS)-gcc $(CROSS)-objdump vlib vmap vcom vlog vsim; do \
			if command -v "$$t" >/dev/null 2>&1; then \
				echo "  [OK]      $$t -> $$(command -v $$t)"; \
			else \
				echo "  [MISSING] $$t"; \
				ok=0; \
			fi; \
		done; \
		if command -v python3 >/dev/null 2>&1; then \
			if python3 -c "import numpy" >/dev/null 2>&1; then \
				echo "  [OK]      python3 module: numpy"; \
			else \
				echo "  [MISSING] python3 module: numpy"; \
				ok=0; \
			fi; \
		fi; \
		echo; \
		if [ $$ok -eq 0 ]; then \
			echo "Some tools are missing. Try: make install-tools"; \
			echo "(vlib/vmap/vcom/vlog/vsim are proprietary Questa/ModelSim tools;"; \
			echo " they cannot be auto-installed, see the message from install-tools.)"; \
		else \
			echo "All required tools are present."; \
		fi; \
	} 2>&1 | tee "$(REPORT_DIR)/tool-check.log"

# Best-effort installer for everything that CAN be installed
# unattended. Debian/Ubuntu + apt only; anything else just gets a
# pointer to what needs installing by hand.
install-tools:
	@mkdir -p $(REPORT_DIR)
	@{ \
		if command -v apt-get >/dev/null 2>&1; then \
			echo ">>> apt-get found, installing base build tools (needs sudo)"; \
			sudo apt-get update && \
			sudo apt-get install -y \
				build-essential g++ gcc git curl \
				python3 python3-pip python3-venv \
				gcc-riscv64-unknown-elf || \
				echo "apt-get install failed or was declined; install the packages above manually."; \
			echo ">>> NOTE: apt's RISC-V package installs the 'riscv64-unknown-elf-*' binaries."; \
			echo "    They can still target rv32im (that's what this project's -march flags do)."; \
			echo "    Either symlink riscv32-unknown-elf-gcc -> riscv64-unknown-elf-gcc, or pass"; \
			echo "    CROSS=riscv64-unknown-elf to 'make run'."; \
		else \
			echo ">>> No apt-get on this system."; \
			echo "    Install manually: a C/C++ toolchain (gcc/g++), git, curl, python3+pip,"; \
			echo "    and a riscv32-unknown-elf-gcc / riscv32-unknown-elf-objdump toolchain"; \
			echo "    (e.g. the xPack GNU RISC-V Embedded GCC distribution)."; \
		fi; \
		echo ">>> Installing numpy for the current user"; \
		python3 -m pip install --user numpy || echo "pip install numpy failed; install it manually."; \
		echo; \
		echo ">>> ModelSim/Questa (vlib/vmap/vcom/vlog/vsim) is licensed EDA software"; \
		echo "    from Siemens EDA and cannot be installed by this target. Get it from"; \
		echo "    https://eda.sw.siemens.com/en-US/ic/modelsim/ (or your institution's mirror)"; \
		echo "    and make sure its bin/ directory is on PATH."; \
	} 2>&1 | tee "$(REPORT_DIR)/install-tools.log"

# ------------------------------------------------------------------
# run: network + DRAM data -> firmware -> memory-init files -> rtl build
# ------------------------------------------------------------------

NETWORK      ?=
DRAM_INPUTS  ?=
DRAM_WEIGHTS ?=
HAL_DIR      ?= materials/hal
BOOT_DIR     ?= materials/boot
CORE         ?= biriscv

DDG_DIR       := DDG
SOFTWARE_DIR  := software
BUILD_DIR     := build
MEM_INIT_DIR  := MEM_INIT
DUMP_DIR      := packages/CNN-Compiler/dump

check-run-vars:
	@test -n "$(NETWORK)"      || { echo "Set NETWORK=<path to network json>" >&2; exit 1; }
	@test -f "$(NETWORK)"      || { echo "NETWORK '$(NETWORK)' not found" >&2; exit 1; }
	@test -n "$(DRAM_INPUTS)"  || { echo 'Set DRAM_INPUTS="<input_1.npy> [input_2.npy ...]"' >&2; exit 1; }
	@test -n "$(DRAM_WEIGHTS)" || { echo 'Set DRAM_WEIGHTS="<weight_1.npy> [weight_2.npy ...]"' >&2; exit 1; }
	@case "$(CORE)" in aftab|biriscv) : ;; *) echo "CORE must be 'aftab' or 'biriscv' (got '$(CORE)')" >&2; exit 1 ;; esac
	@test -d "$(HAL_DIR)"          || { echo "HAL_DIR '$(HAL_DIR)' not found" >&2; exit 1; }
	@test -d "$(BOOT_DIR)/$(CORE)" || { echo "BOOT_DIR '$(BOOT_DIR)/$(CORE)' not found" >&2; exit 1; }

check-run-tools:
	@command -v python3 >/dev/null 2>&1 || { echo "Missing python3 (try: make install-tools)" >&2; exit 1; }
	@python3 -c "import numpy" >/dev/null 2>&1 || { echo "Missing python3 module numpy (try: make install-tools)" >&2; exit 1; }
	@command -v "$(CROSS)-gcc" >/dev/null 2>&1 || { echo "Missing RISC-V toolchain: $(CROSS)-gcc (try: make install-tools, or override CROSS=)" >&2; exit 1; }
	@command -v "$(CROSS)-objdump" >/dev/null 2>&1 || { echo "Missing RISC-V toolchain: $(CROSS)-objdump (try: make install-tools, or override CROSS=)" >&2; exit 1; }
	@command -v sed >/dev/null 2>&1 || { echo "Missing sed" >&2; exit 1; }

# packages builds packages/CNN-Compiler and packages/Text-Converter
# (and, as a side effect, the other two tool packages too).
run: check-run-vars check-run-tools packages
	@mkdir -p $(DDG_DIR)/ID $(DDG_DIR)/WD $(SOFTWARE_DIR) $(BUILD_DIR) $(MEM_INIT_DIR) $(DUMP_DIR)

	@echo ">>> [1/6] DRAM input/weight data generation (IDG/WDG -> $(DDG_DIR)/)"
	$(call LOG,01-idg-wdg,\
		i=1; for f in $(DRAM_INPUTS); do \
			python3 packages/CNN-DRAM-Data-Gen/IDG.py "$$f" "$(DDG_DIR)/ID/Input_$${i}.bin" || exit 1; \
			i=$$((i+1)); \
		done; \
		i=1; for f in $(DRAM_WEIGHTS); do \
			python3 packages/CNN-DRAM-Data-Gen/WDG.py "$$f" "$(DDG_DIR)/WD/Weight_$${i}.bin" || exit 1; \
			i=$$((i+1)); \
		done)
	
	@echo ">>> [2/6] CNN-Compiler ($(NETWORK) -> $(SOFTWARE_DIR)/, dump in $(DUMP_DIR)/)"
	$(call LOG,02-cnn-compiler,\
		packages/CNN-Compiler/build/CNN-Compiler -v \
			-n "$(NETWORK)" \
			-m "$(HAL_DIR)" \
			-d "$(DUMP_DIR)" \
			-o "$(SOFTWARE_DIR)" \
			-i $(DDG_DIR)/ID/*.bin \
			-w $(DDG_DIR)/WD/*.bin)
	
	@echo ">>> [3/6] Cross-compiling $(SOFTWARE_DIR)/ for CORE=$(CORE) ($(CROSS)-gcc -> $(BUILD_DIR)/)"
	$(call LOG,03-riscv-compile,\
		$(CROSS)-gcc -mabi=ilp32 -O2 \
			-march=rv32im -Wa,-march=rv32im \
			-Wextra -Wall -Wno-unused-parameter \
			-Wno-unused-variable -Wno-unused-function \
			-fdata-sections -ffunction-sections \
			-fdiagnostics-color=always \
			-I$(SOFTWARE_DIR)/include \
			-T $(BOOT_DIR)/$(CORE)/link.riscv.ld -nostartfiles -Wl,--gc-sections \
			-lm $(SOFTWARE_DIR)/src/*.cpp $(BOOT_DIR)/$(CORE)/crt0.boot_M.S \
			-o $(BUILD_DIR)/main.elf && \
		$(CROSS)-objdump -s -l --inlines $(BUILD_DIR)/main.elf > $(BUILD_DIR)/text.txt && \
		$(CROSS)-objdump -d -l --inlines $(BUILD_DIR)/main.elf > $(BUILD_DIR)/code.txt)
	
	@echo ">>> [4/6] Text-Converter ($(BUILD_DIR)/text.txt -> $(MEM_INIT_DIR)/)"
	$(call LOG,04-text-converter,\
		packages/Text-Converter/build/Text-Converter \
			-i $(BUILD_DIR)/text.txt \
			-o $(MEM_INIT_DIR))
	
	@echo ">>> [5/6] Selecting CORE=$(CORE) in rtl/packages/MY_Pack_v2.vhd"
	$(call LOG,05-core-select,\
		case "$(CORE)" in \
			aftab)   NEWVAL=P_USE_AFTAB ;; \
			biriscv) NEWVAL=P_USE_BIRISC ;; \
		esac; \
		sed -i.bak -E \
			"s/(CONSTANT[[:space:]]+P_uProcessor_in_use[[:space:]]*:[[:space:]]*P_uProcessor_type[[:space:]]*:=[[:space:]]*)P_USE_[A-Z]+;/\1$${NEWVAL};/" \
			rtl/packages/MY_Pack_v2.vhd; \
		grep -n "P_uProcessor_in_use" rtl/packages/MY_Pack_v2.vhd)
	
	@echo ">>> [6/6] Building rtl/"
	$(call LOG,06-rtl-build,$(MAKE) -C rtl all)
	
	@echo ">>> done: firmware in $(BUILD_DIR)/, memory-init files in $(MEM_INIT_DIR)/, logs in $(REPORT_DIR)/"

# ------------------------------------------------------------------
# Housekeeping
# ------------------------------------------------------------------

clean:
	@for d in $(PACKAGE_DIRS) materials/hal rtl; do \
		$(MAKE) -C $$d clean; \
	done

clean-run:
	rm -rf $(DDG_DIR) $(SOFTWARE_DIR) $(BUILD_DIR) $(MEM_INIT_DIR) $(DUMP_DIR)
	rm -f rtl/packages/MY_Pack_v2.vhd.bak

distclean: clean clean-run
	rm -rf $(REPORT_DIR)
	@git submodule deinit -f --all
