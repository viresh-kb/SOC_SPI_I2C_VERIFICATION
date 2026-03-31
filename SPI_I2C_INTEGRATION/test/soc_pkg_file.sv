package soc_pkg_file;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "soc_env_config.sv"

// spi agent components
	`include "spi_transaction.sv"
	`include "spi_sequence.sv"
	`include "spi_sequencer.sv"
	`include "spi_driver.sv"
	`include "spi_monitor.sv"
	`include "spi_agent.sv"
	`include "spi_scb.sv"

// i2c agent components
	`include "i2c_xtn.sv"
	`include "i2c_seqs.sv"
	`include "i2c_sequencer.sv"
	`include "i2c_driver.sv"
	`include "i2c_monitor.sv"
	`include "i2c_agent.sv"
	`include "i2c_scoreboard.sv"

// virtual seq and sqr
	`include "soc_virtual_sequencer.sv"
	`include "soc_virtual_sequence.sv"
	`include "soc_virtual_sequence1.sv"
	`include "soc_virtual_sequence2.sv"
	`include "soc_virtual_sequence3.sv"
	`include "soc_virtual_sequence4.sv"
	`include "soc_virtual_sequence5.sv"
	`include "soc_virtual_sequence6.sv"
	`include "soc_virtual_sequence7.sv"
	`include "soc_virtual_sequence8.sv"

	`include "soc_env.sv"
	`include "soc_base_test.sv"
	`include "soc_test1.sv"
	`include "soc_test2.sv"
	`include "soc_test3.sv"
	`include "soc_test4.sv"
	`include "soc_test5.sv"
	`include "soc_test6.sv"
	`include "soc_test7.sv"
	`include "soc_test8.sv"

endpackage
