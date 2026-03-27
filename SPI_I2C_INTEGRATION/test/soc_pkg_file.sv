package soc_pkg_file;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// transactions
	`include "spi_transaction.sv"
	`include "i2c_xtn.sv"

	// sequencers
	`include "spi_sequencer.sv"
	`include "i2c_sequencer.sv"

	// sequences
	`include "spi_sequence.sv"
	`include "i2c_seqs_base.sv"
	`include "i2c_seqs_single_write.sv"
	`include "i2c_seqs_single_write1.sv"
	`include "i2c_seq_single_read.sv"
	`include "i2c_seq_single_read1.sv"
	`include "i2c_write_read_seqs.sv"
	`include "i2c_wr_random_seqs.sv"
	`include "i2c_wrq_seqs.sv"

	// drivers and monitors
	`include "spi_driver.sv"
	`include "spi_monitor.sv"
	`include "i2c_driver.sv"
	`include "i2c_monitor.sv"

	// config
	`include "soc_env_config.sv"

	// agents
	`include "spi_agent.sv"
	`include "i2c_agent.sv"

	// scoreboards
	`include "spi_scb.sv"
	`include "i2c_scoreboard.sv"

	// virtual sequencer and sequences
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

	// env
	`include "soc_env.sv"

	// tests
	`include "soc_base_test.sv"
	`include "soc_test2.sv"
	`include "soc_test3.sv"
	`include "soc_test4.sv"
	`include "soc_test5.sv"
	`include "soc_test6.sv"
	`include "soc_test7.sv"
	`include "soc_test8.sv"

endpackage
