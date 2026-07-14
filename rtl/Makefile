BUILD_DIR ?= build
WORK_DIR := $(BUILD_DIR)/work
LOG_DIR := $(BUILD_DIR)/logs
TOP ?= SIM_SYSTEM

VLIB ?= vlib
VMAP ?= vmap
VCOM ?= vcom
VLOG ?= vlog
VSIM ?= vsim

VHDL_PACKAGES	:= $(sort $(call rwildcard,packages/,*.vhd))
VHDL_SHARED		:= $(sort $(call rwildcard,shared/,*.vhd))
VHDL_SYSTEM		:= $(sort $(call rwildcard,system/,*.vhd))
VHDL_SIM		:= $(sort $(call rwildcard,sim/,*.vhd))
VERILOG_SHARED	:= $(sort $(call rwildcard,shared/,*.v))
VERILOG_SYSTEM	:= $(sort $(call rwildcard,system/,*.v))
VERILOG_SIM		:= $(sort $(call rwildcard,sim/,*.v))

VHDL_SOURCES := $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_SIM)
VERILOG_SOURCES := $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM)

STAMP := $(BUILD_DIR)/.compiled

define rwildcard
$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
endef

.PHONY: all compile run gui clean deps check-tools

all: compile

deps: check-tools

check-tools:
	@command -v "$(VLIB)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vlib" >&2; exit 1; }
	@command -v "$(VMAP)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vmap" >&2; exit 1; }
	@command -v "$(VCOM)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vcom" >&2; exit 1; }
	@command -v "$(VLOG)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vlog" >&2; exit 1; }
	@command -v "$(VSIM)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vsim" >&2; exit 1; }

compile: deps $(STAMP)

$(STAMP): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR) $(LOG_DIR)
	@rm -f "$@"
	@$(VLIB) "$(WORK_DIR)"
	@$(VMAP) work "$(WORK_DIR)"
	@for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_SIM); do \
		printf '%s\n' "vcom $$src"; \
		$(VCOM) -2008 -work work "$$src" || exit 1; \
	done
	@for src in $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
		printf '%s\n' "vlog $$src"; \
		$(VLOG) -work work "$$src" || exit 1; \
	done
	@touch "$@"

run: compile | $(LOG_DIR)
	$(VSIM) -c work.$(TOP) -l $(LOG_DIR)/$(TOP).log -do "run -all; quit -f"

gui: compile | $(LOG_DIR)
	$(VSIM) work.$(TOP)

$(BUILD_DIR) $(LOG_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)
