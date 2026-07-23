SHELL := /bin/bash

BUILD_DIR ?= build
WORK_DIR := $(BUILD_DIR)/work
LOG_DIR := $(BUILD_DIR)/logs
REPORT_DIR := report
TOP ?= SIM_SYSTEM

VSIM ?= vsim

# make run VERBOSE=1  -> full vsim banner/info output. Default (0)
# passes vsim's own -quiet flag to suppress it. Can be set directly
# here (make -C rtl run VERBOSE=1) or inherited from the top-level
# Makefile, which forwards command-line VERBOSE= automatically.
VERBOSE ?= 0
VSIM_QUIET := $(if $(filter 1,$(VERBOSE)),,-quiet)

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

# SYSTEM.vhd lives at the project root (not under system/), so the
# system/ glob above doesn't catch it -- add it explicitly, compiled
# after system/ (which it depends on) and before sim/ (which wraps it).
VHDL_TOP			:= SYSTEM.vhd
VHDL_PACKAGES		:= $(sort $(call rwildcard,packages/,*.vhd))
VHDL_SHARED			:= $(sort $(call rwildcard,shared/,*.vhd))
VHDL_SYSTEM			:= $(sort $(call rwildcard,system/,*.vhd))
VHDL_SIM			:= $(sort $(call rwildcard,sim/,*.vhd))

VERILOG_PACKAGES	:= $(sort $(call rwildcard,packages/,*.vh))
VERILOG_SHARED		:= $(sort $(call rwildcard,shared/,*.v))
VERILOG_SYSTEM		:= $(sort $(call rwildcard,system/,*.v))
VERILOG_SIM			:= $(sort $(call rwildcard,sim/,*.v))

VHDL_SOURCES := $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM)
VERILOG_SOURCES := $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM)

STAMP := $(BUILD_DIR)/.compiled
COMPILE_DO := $(BUILD_DIR)/compile.do
RUN_DO := $(BUILD_DIR)/run.do
GUI_DO := $(BUILD_DIR)/gui.do
OUTDATED_DO := $(BUILD_DIR)/outdated.do

# Checked after every vsim invocation that compiles something: even
# with the catch/quit-code guard below, this is a cheap belt-and-
# suspenders check in case a given ModelSim/Questa version doesn't
# raise a catchable error for some failure mode.
CHECK_LOG = if grep -qE '\*\* (Error|Fatal)' "$(1)"; then \
		echo "Compile errors found -- see $(1)"; \
		exit 1; \
	fi

.PHONY: all compile run gui outdated clean deps check-tools

all: compile

deps: check-tools

check-tools:
	@command -v "$(VSIM)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vsim" >&2; exit 1; }

# Generates the compile script: vlib + vmap + one vcom/vlog line per
# source file, in dependency order (packages -> shared -> system ->
# SYSTEM.vhd -> sim). Regenerated whenever the source file set changes.
#
# Each vcom/vlog call is wrapped in a Tcl catch that force-quits with
# a non-zero exit code on the first real compile error. Without this,
# vcom/vlog errors just print to the log and vsim keeps going, then
# still exits 0 at "quit -f" -- so a failed compile would look
# successful to Make, the stamp file would get touched anyway, and
# re-running make would see nothing to do and silently skip the fix.
# $(COMPILE_DO): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR)
# 	@{ \
# 		echo "vlib $(WORK_DIR)"; \
# 		echo "vmap work $(WORK_DIR)"; \
# 		echo "vcom -2008 -work work packages/MY_Pack_v2.vhd"; \
# 		for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM); do \
# 			echo "if {[catch {vcom -2008 -work work $$src}]} { quit -code 1 }"; \
# 		done; \
# 		for src in $(VERILOG_PACKAGES) $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
# 			echo "if {[catch {vlog -work work $$src}]} { quit -code 1 }"; \
# 		done; \
# 	} > "$@"
$(COMPILE_DO): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR)
	@{ \
		echo "vlib $(WORK_DIR)"; \
		echo "vmap work $(WORK_DIR)"; \
		echo "puts \"Compiling: packages/MY_Pack_v2.vhd\""; \
		echo "vcom -quiet -2008 -work work packages/MY_Pack_v2.vhd"; \
		for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM); do \
			echo "puts \"Compiling: $$src\""; \
			echo "if {[catch {vcom -quiet -2008 -work work $$src}]} { quit -code 1 }"; \
		done; \
		for src in $(VERILOG_PACKAGES) $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
			echo "puts \"Compiling: $$src\""; \
			echo "if {[catch {vlog -quiet -work work $$src}]} { quit -code 1 }"; \
		done; \
	} > "$@"


compile: deps $(STAMP)

$(STAMP): $(COMPILE_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do "do $(COMPILE_DO); quit -f" -l $(LOG_DIR)/compile.log
	@$(call CHECK_LOG,$(LOG_DIR)/compile.log)
	@touch "$@"

# run.do / gui.do = compile.do plus a tail that loads $(TOP) and
# either runs to completion and quits (run), or runs and stays open
# for inspection (gui). Whether ModelSim actually shows a GUI is
# controlled by the outer vsim invocation's -c flag below, not by
# anything in the .do file itself.
#		cat "$(COMPILE_DO)"; 
$(RUN_DO): $(COMPILE_DO) | $(BUILD_DIR)
	@{ \
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

run: deps $(RUN_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do $(RUN_DO) -l $(LOG_DIR)/$(TOP).log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP).log)

gui: deps $(GUI_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -do $(GUI_DO) -l $(LOG_DIR)/$(TOP).log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP).log)

# Recompiles only the source files that changed since the last
# successful full compile (i.e. newer than $(STAMP)), directly into
# the existing work library -- no vlib/full rebuild. Useful while
# iterating on a handful of files instead of paying for a full
# recompile every time via "run"/"gui".
outdated: deps $(COMPILE_DO) | $(LOG_DIR) $(REPORT_DIR)
	@vhdl_out=(); \
	for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM); do \
		if [ ! -e "$(STAMP)" ] || [ "$$src" -nt "$(STAMP)" ]; then vhdl_out+=("$$src"); fi; \
	done; \
	verilog_out=(); \
	for src in $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
		if [ ! -e "$(STAMP)" ] || [ "$$src" -nt "$(STAMP)" ]; then verilog_out+=("$$src"); fi; \
	done; \
	if [ $${#vhdl_out[@]} -eq 0 ] && [ $${#verilog_out[@]} -eq 0 ]; then \
		echo "Nothing out of date."; \
		exit 0; \
	fi; \
	echo "Out of date:"; \
	printf '  %s\n' "$${vhdl_out[@]}" "$${verilog_out[@]}"; \
	{ \
		echo "if {![file exists {$(WORK_DIR)}]} { vlib $(WORK_DIR) }"; \
		echo "vmap work $(WORK_DIR)"; \
		for src in "$${vhdl_out[@]}"; do \
			echo "puts \"Compiling: $$src\""; \
			echo "if {[catch {vcom -quiet -2008 -work work $$src}]} { quit -code 1 }"; \
		done; \
		for src in "$${verilog_out[@]}"; do \
			echo "puts \"Compiling: $$src\""; \
			echo "if {[catch {vlog -quiet -work work $$src}]} { quit -code 1 }"; \
		done; \
	} > "$(OUTDATED_DO)"; \
	$(VSIM) $(VSIM_QUIET) -c -do "do $(OUTDATED_DO); quit -f" -l $(LOG_DIR)/outdated.log; \
	$(call CHECK_LOG,$(LOG_DIR)/outdated.log); \
	touch "$(STAMP)"

$(BUILD_DIR) $(LOG_DIR) $(REPORT_DIR):
	mkdir -p $@



clean:
	rm -rf $(BUILD_DIR) $(REPORT_DIR)
	


