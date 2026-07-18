BUILD_DIR ?= build
WORK_DIR := $(BUILD_DIR)/work
LOG_DIR := $(BUILD_DIR)/logs
TOP ?= SIM_SYSTEM

VSIM ?= vsim

# NOTE: vlib/vmap/vcom/vlog are only used here to *verify they're
# installed* (check-tools). The actual compilation now happens via
# vsim's own built-in vlib/vmap/vcom/vlog Tcl commands, run from a
# generated .do script -- see $(COMPILE_DO)/$(RUN_DO)/$(GUI_DO) below.
# vsim is the only tool Make invokes directly.

# rwildcard must be defined before first use below: ':=' assignments
# expand their right-hand side immediately, so if this define came
# after the VHDL_*/VERILOG_* lines (as it previously did), every
# $(call rwildcard,...) below would silently expand to nothing and
# every source list would end up empty.
define rwildcard
$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
endef

VHDL_PACKAGES	:= $(sort $(call rwildcard,packages/,*.vhd))
VHDL_SHARED		:= $(sort $(call rwildcard,shared/,*.vhd))
VHDL_SYSTEM		:= $(sort $(call rwildcard,system/,*.vhd))
# SYSTEM.vhd lives at the project root (not under system/), so the
# system/ glob above doesn't catch it -- add it explicitly, compiled
# after system/ (which it depends on) and before sim/ (which wraps it).
VHDL_TOP		:= SYSTEM.vhd
VHDL_SIM		:= $(sort $(call rwildcard,sim/,*.vhd))
VERILOG_SHARED	:= $(sort $(call rwildcard,shared/,*.v))
VERILOG_SYSTEM	:= $(sort $(call rwildcard,system/,*.v))
VERILOG_SIM		:= $(sort $(call rwildcard,sim/,*.v))

VHDL_SOURCES := $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM)
VERILOG_SOURCES := $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM)

STAMP := $(BUILD_DIR)/.compiled
COMPILE_DO := $(BUILD_DIR)/compile.do
RUN_DO := $(BUILD_DIR)/run.do
GUI_DO := $(BUILD_DIR)/gui.do

.PHONY: all compile run gui clean deps check-tools

all: compile

deps: check-tools

check-tools:
	@command -v "$(VSIM)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vsim" >&2; exit 1; }

# Generates the compile script: vlib + vmap + one vcom/vlog line per
# source file, in dependency order (packages -> shared -> system ->
# SYSTEM.vhd -> sim). Regenerated whenever the source file set changes.
$(COMPILE_DO): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR)
	@{ \
		echo "vlib $(WORK_DIR)"; \
		echo "vmap work $(WORK_DIR)"; \
		for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM); do \
			echo "vcom -2008 -work work $$src"; \
		done; \
		for src in $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
			echo "vlog -work work $$src"; \
		done; \
	} > "$@"

compile: deps $(STAMP)

$(STAMP): $(COMPILE_DO) | $(LOG_DIR)
	$(VSIM) -c -do "do $(COMPILE_DO); quit -f" -l $(LOG_DIR)/compile.log
	@touch "$@"

# run.do / gui.do = compile.do plus a tail that loads $(TOP) and
# either runs to completion and quits (run), or runs and stays open
# for inspection (gui). Whether ModelSim actually shows a GUI is
# controlled by the outer vsim invocation's -c flag below, not by
# anything in the .do file itself.
$(RUN_DO): $(COMPILE_DO) | $(BUILD_DIR)
	@{ \
		cat "$(COMPILE_DO)"; \
		echo "vsim work.$(TOP)"; \
		echo "run -all"; \
		echo "quit -f"; \
	} > "$@"

$(GUI_DO): $(COMPILE_DO) | $(BUILD_DIR)
	@{ \
		cat "$(COMPILE_DO)"; \
		echo "vsim work.$(TOP)"; \
		echo "run -all"; \
	} > "$@"

run: deps $(RUN_DO) | $(LOG_DIR)
	$(VSIM) -c -do $(RUN_DO) -l $(LOG_DIR)/$(TOP).log

gui: deps $(GUI_DO) | $(LOG_DIR)
	$(VSIM) -do $(GUI_DO) -l $(LOG_DIR)/$(TOP).log

$(BUILD_DIR) $(LOG_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)
