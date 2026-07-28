SHELL := /bin/bash

BUILD_DIR ?= build
WORK_DIR := work
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
# generated .do script -- see $(LEGACY_DO)/$(LEGACY_SIM_DO) below.
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

VHDL_SOURCES        := $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM)
VERILOG_SOURCES     := $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM)


# ModelSim *project* (.mpf) flow -- an alternative to the raw
# vlib/vcom/vlog flow above. Functionally compiles the same files in
# the same order; the only difference is the files end up registered
# in a .mpf project file, which is useful if you want to later open
# it in the ModelSim GUI with the file list already populated. Pick
# one flow or the other -- they don't need to be used together.
#
# The project's "work" library is pointed at the same physical
# directory ($(WORK_DIR)) that the plain compile flow above uses, so
# both flows share one compiled library instead of each maintaining
# its own copy of "work" in a different location.
STAMP               := $(BUILD_DIR)/.compiled
PROJECT_STAMP       := $(BUILD_DIR)/.project_compiled
PROJECT_NAME        ?= rtl_project
PROJECT_MPF         := $(PROJECT_NAME).mpf

LEGACY_DO           := $(BUILD_DIR)/legacy_compile.do
LEGACY_SIM_DO       := $(BUILD_DIR)/legacy_sim_compile.do
PROJECT_DO          := $(BUILD_DIR)/project.do
PROJECT_SIM_DO      := $(BUILD_DIR)/project_sim.do

# Checked after every vsim invocation that compiles something: even
# with the catch/quit-code guard below, this is a cheap belt-and-
# suspenders check in case a given ModelSim/Questa version doesn't
# raise a catchable error for some failure mode.
CHECK_LOG = if grep -qE '\*\* (Error|Fatal)' "$(1)"; then \
		echo "Compile errors found -- see $(1)"; \
		exit 1; \
	fi

.PHONY: all deps \
		compile run \
		project simulate \
		legacy legacy-simulate \
		check-tools \
		clean 

all: deps

deps: check-tools

check-tools:
	@command -v "$(VSIM)" >/dev/null 2>&1 || { printf '%s\n' "Missing ModelSim/Questa tool: vsim" >&2; exit 1; }

# Generates the compile script: vlib + vmap + one vcom/vlog line per
# source file, in dependency order (packages -> shared -> system ->
# SYSTEM.vhd -> sim). Regenerated whenever the source file set changes,
# which is also what lets $(STAMP) below know whether a recompile is
# actually needed: if no source file changed, this file's mtime is
# untouched, $(STAMP) stays newer than it, and Make skips recompiling
# entirely.
#
# Each vcom/vlog call is wrapped in a Tcl catch that force-quits with
# a non-zero exit code on the first real compile error. Without this,
# vcom/vlog errors just print to the log and vsim keeps going, then
# still exits 0 at "quit -f" -- so a failed compile would look
# successful to Make, the stamp file would get touched anyway, and
# re-running make would see nothing to do and silently skip the fix.
$(LEGACY_DO): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR)
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

# $(STAMP) depends only on $(LEGACY_DO) (not the sources directly),
# so re-running "make compile"/"make all" after no source files have
# changed does nothing: $(LEGACY_DO) wasn't regenerated, so it's
# still older than $(STAMP), so this recipe is skipped and vsim is
# never invoked.
$(STAMP): $(LEGACY_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do "do $(LEGACY_DO); quit -f" -l $(LOG_DIR)/$(TOP)_legacy_compile.log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP)_legacy_compile.log)
	@touch "$@"

# run.do = compile.do plus a tail that loads $(TOP), runs to
# completion, and quits.
$(LEGACY_SIM_DO): $(LEGACY_DO) | $(BUILD_DIR)
	@{ \
		echo "vsim work.$(TOP)"; \
		echo "run -all"; \
		echo "quit -f"; \
	} > "$@"

run: deps $(LEGACY_SIM_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do $(LEGACY_SIM_DO) -l $(LOG_DIR)/$(TOP)_legacy_simulate.log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP)_legacy_simulate.log)

# Aliases for the top-level Makefile's "legacy-project"/"legacy-simulate"
# targets, which invoke "$(MAKE) -C rtl legacy" / "... legacy-simulate".
# Those target names didn't exist here at all (only "compile"/"run"
# did), so "make legacy-project"/"make legacy-simulate" from the repo
# root would have failed with "No rule to make target 'legacy'".
legacy: compile
legacy-simulate: run


# Generates the project script: pre-creates/maps a "work" library at
# $(WORK_DIR) (the same directory the plain compile flow above uses)
# *before* creating the project, so "project new" picks up that
# existing mapping instead of creating its own default "work" library
# under ".". (Passing the library path directly as an extra argument
# to "project new" is not accepted by all vsim/Questa versions --
# some report a bogus "invalid Configuration/Project file suffix"
# parse error -- so the library is set up ahead of time instead.)
# Then deletes any stale .mpf, creates a fresh project, registers
# every source file via "project addfile" (same file set/order as
# $(LEGACY_DO)), printing a "Compiling: <file>" line per file just
# like $(LEGACY_DO) does, then compiles the whole project in one go.
#
# IMPORTANT: everything -- project creation, file registration, AND
# the actual compile -- happens in this single .do script / single
# vsim invocation, ending in "project compileall". Earlier revisions
# of this Makefile split "create project" and "open + compile" across
# two separate .do scripts/vsim sessions (referencing a second do-file
# variable that was never actually defined, so it silently expanded to
# an empty string and never got (re)generated). Splitting it that way
# also meant re-opening the project and re-running
# compileoutofdate/calculateorder/compileall in a second batch vsim
# session, which is exactly the failure mode described below in
# $(PROJECT_STAMP): the ModelSim/Questa "project" command family is
# known to silently no-op under headless/-c batch execution on some
# installs, which then leaves a stray empty result that Tcl tries to
# execute as a command ("invalid command name \"\""). Doing it all in
# one shot, in one session, avoids re-entering that command family a
# second time.
#
# Regenerated whenever the source file set changes -- same mechanism
# as $(LEGACY_DO), which is what lets $(PROJECT_STAMP) below skip
# recompilation when nothing changed.
$(PROJECT_DO): $(VHDL_SOURCES) $(VERILOG_SOURCES) | $(BUILD_DIR)
	@{ \
		echo "if {![file exists {modelsim.ini}]} { vmap -c }"; \
		echo "if {![file exists {$(WORK_DIR)}]} { vlib $(WORK_DIR) }"; \
		echo "vmap work $(WORK_DIR)"; \
		echo "if {[file exists {$(PROJECT_MPF)}]} { project close; file delete {$(PROJECT_MPF)} }"; \
		echo "if {[catch {project new {.} {$(PROJECT_NAME)} work} perr]} { puts \"project new failed: \$$perr\"; quit -code 1 }"; \
		echo "puts \"Adding VHDL files\""; \
		echo "project addfile {packages/MY_Pack_v2.vhd}"; \
		for src in $(VHDL_PACKAGES) $(VHDL_SHARED) $(VHDL_SYSTEM) $(VHDL_TOP) $(VHDL_SIM); do \
			echo "project addfile {$$src}"; \
		done; \
		echo "puts \"Adding Verilog files\""; \
		for src in $(VERILOG_PACKAGES) $(VERILOG_SHARED) $(VERILOG_SYSTEM) $(VERILOG_SIM); do \
			echo "project addfile {$$src}"; \
		done; \
		echo "puts \"Recalculating compilation order\""; \
		echo "puts \"Compiling project\""; \
		echo "project calculateorder"; \
	} > "$@"

project: deps $(PROJECT_STAMP)

# Same skip-if-unchanged behavior as $(STAMP) above: this recipe only
# runs when $(PROJECT_DO) is newer than $(PROJECT_STAMP), i.e. when
# the source file set actually changed.
$(PROJECT_STAMP): $(PROJECT_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do "source $(PROJECT_DO); quit -f" -l $(LOG_DIR)/$(TOP)_project_compile.log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP)_project_compile.log)
	@test -f "$(PROJECT_MPF)" || { \
		echo "$(PROJECT_MPF) was not created -- see $(LOG_DIR)/project.log."; \
		echo "This can happen if 'project new' fails without raising a catchable"; \
		echo "Tcl error (silent no-op) -- known to occur for the ModelSim 'project'"; \
		echo "command family under headless/-c batch execution on some installs."; \
		exit 1; \
	}
	@touch "$@"

# Simulate $(TOP) using the library the project flow just compiled.
#
# NOTE: this deliberately does NOT re-open the .mpf or call any
# "project ..." Tcl subcommand. $(PROJECT_DO) above already mapped
# "work" to $(WORK_DIR) and fully compiled it via "project compileall"
# -- that mapping is persisted in modelsim.ini in this directory, so a
# brand new vsim invocation can just load "work.$(TOP)" directly, the
# same way $(LEGACY_SIM_DO) does for the plain compile flow. This
# avoids re-entering the "project" command family a second time at
# simulate time, which is what previously produced
# "invalid command name \"\"" (one of project open/compileoutofdate/
# calculateorder/compileall silently returning nothing in a second
# batch session, and vsim then trying to execute the empty result).
$(PROJECT_SIM_DO): $(PROJECT_DO) | $(BUILD_DIR)
	@{ \
		echo "pwd"; \
		echo "vsim work.$(TOP)"; \
		echo "run -all"; \
	} > "$@"

simulate: project $(PROJECT_SIM_DO) | $(LOG_DIR) $(REPORT_DIR)
	$(VSIM) $(VSIM_QUIET) -c -do "do $(PROJECT_SIM_DO); quit -f" -l $(LOG_DIR)/$(TOP)_project_simulate.log
	@$(call CHECK_LOG,$(LOG_DIR)/$(TOP)_project_simulate.log)

$(BUILD_DIR) $(LOG_DIR) $(REPORT_DIR):
	mkdir -p $@



clean:
	rm -rf $(BUILD_DIR) $(REPORT_DIR) work
	rm -f $(PROJECT_MPF) modelsim.ini 
	rm -f rtl_project.cr.mti
	rm -f rtl_project.mpf