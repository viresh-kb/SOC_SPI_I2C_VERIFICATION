# ======================================================
#   SOC SPI + I2C UVM TESTBENCH MAKEFILE
# ======================================================

SIMULATOR = Questa
work = work

# ---------------- RTL ----------------
RTL   = ../rtl/spi_rtl.sv \
        ../rtl/i2c_pkg.sv \
        ../rtl/i2c_rtl.sv \
        ../rtl/i2c_assertion.sv

INTF  = ../rtl/spi_if.sv ../rtl/i2c_if.sv 

# ---------------- TESTBENCH ----------------
PKG  = ../test/soc_pkg_file.sv
TOP  = ../test/tb_top.sv

# ---------------- Include directories ----------------
INC = +incdir+../rtl +incdir+../agent_top +incdir+../env +incdir+../test

# ---------------- Coverage Options ----------------
VSIMOPT   = -vopt -voptargs=+acc
VSIMCOV   = -coverage
VLOGCOV   = -cover bcesf

# ---------------- Test List ----------------
TESTS = soc_test2 soc_test3 soc_test4 soc_test5 soc_test6 soc_test7 soc_test8

# ======================================================
# HELP
# ======================================================

help:
	@echo "========== AVAILABLE COMMANDS =========="
	@echo ""
	@echo "Compile:"
	@echo "  make sv_cmp"
	@echo ""
	@echo "Single Test (Batch Mode):"
	@echo "  make run_test2"
	@echo "  make run_test3"
	@echo "  make run_test4"
	@echo "  make run_test5"
	@echo "  make run_test6"
	@echo "  make run_test7"
	@echo "  make run_test8"
	@echo ""
	@echo "Single Test (GUI Mode):"
	@echo "  make run_test2_gui"
	@echo "  make run_test3_gui"
	@echo "  make run_test4_gui"
	@echo "  make run_test5_gui"
	@echo "  make run_test6_gui"
	@echo "  make run_test7_gui"
	@echo "  make run_test8_gui"
	@echo ""
	@echo "Regression (Batch Mode):"
	@echo "  make regress"
	@echo ""
	@echo "Regression (GUI Mode):"
	@echo "  make regress_gui"
	@echo ""
	@echo "Coverage:"
	@echo "  make cov_term"
	@echo "  make cov_gui"
	@echo ""
	@echo "Clean:"
	@echo "  make clean"
	@echo "========================================="

# ======================================================
# TARGET MAPPING
# ======================================================

clean        : clean_Questa
sv_cmp       : sv_cmp_Questa
regress      : regress_Questa
regress_gui  : regress_gui_Questa
cov_gui      : cov_gui_Questa
cov_term     : cov_term_Questa

# ======================================================
# COMPILE
# ======================================================

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -sv $(VLOGCOV) -work $(work) $(INC) $(INTF) $(RTL)
	vlog -sv $(VLOGCOV) -work $(work) $(INC) $(PKG)
	vlog -sv $(VLOGCOV) -work $(work) $(INC) $(TOP)

# ======================================================
# SINGLE TEST (BATCH MODE)
# ======================================================

run_test%: sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) -c \
	     work.tb_top +UVM_TESTNAME=soc_test$* \
	     -do "coverage save -onexit soc_test$*.ucdb; run -all; exit"

# ======================================================
# SINGLE TEST (GUI MODE)
# ======================================================

run_test%_gui: sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) \
	     work.tb_top +UVM_TESTNAME=soc_test$* \
	     -do "add wave -r /*; coverage save -onexit soc_test$*.ucdb; run -all"

# ======================================================
# REGRESSION (BATCH MODE)
# ======================================================

regress_Questa: sv_cmp_Questa
	@echo "Running Regression in Batch Mode..."
	@rm -rf *.ucdb soc_full_cov.ucdb

	@for test in $(TESTS); do \
		echo "Running $$test..."; \
		vsim $(VSIMOPT) $(VSIMCOV) -c \
		     work.tb_top +UVM_TESTNAME=$$test \
		     -do "coverage save -onexit $$test.ucdb; run -all; exit"; \
	done

	@if ls *.ucdb 1> /dev/null 2>&1; then \
		echo "Merging coverage databases..."; \
		vcover merge -out soc_full_cov.ucdb *.ucdb; \
		echo "Coverage Summary:"; \
		vcover report -cvg -summary soc_full_cov.ucdb; \
	else \
		echo "ERROR: No UCDB files generated. Simulation likely failed."; \
	fi

# ======================================================
# REGRESSION (GUI MODE)
# ======================================================

regress_gui_Questa: sv_cmp_Questa
	@echo "Running Regression in GUI Mode..."
	@rm -rf *.ucdb soc_full_cov.ucdb

	@for test in $(TESTS); do \
		echo "Running $$test in GUI..."; \
		vsim $(VSIMOPT) $(VSIMCOV) \
		     work.tb_top +UVM_TESTNAME=$$test \
		     -do "add wave -r /*; coverage save -onexit $$test.ucdb; run -all; quit -sim"; \
	done

	@if ls *.ucdb 1> /dev/null 2>&1; then \
		vcover merge -out soc_full_cov.ucdb *.ucdb; \
		vsim -viewcov soc_full_cov.ucdb; \
	else \
		echo "ERROR: No UCDB files generated."; \
	fi

# ======================================================
# COVERAGE VIEW
# ======================================================

cov_gui_Questa:
	vsim -viewcov soc_full_cov.ucdb

cov_term_Questa:
	vcover report -cvg -summary soc_full_cov.ucdb

# ======================================================
# CLEAN
# ======================================================

clean_Questa:
	rm -rf transcript* *.log *.wlf *.ucdb soc_full_cov.ucdb modelsim.ini work
	clear
