/*`include "uvm_macros.svh"
import uvm_pkg::*;
import soc_pkg_file::*;*/


module tb_top;

import uvm_pkg::*;
import soc_pkg_file::*;
`include "uvm_macros.svh"

	bit clk=1'b0;
	bit rst;
	
	spi_if spif(clk);
	i2c_if vif(clk);

	top DUT(.clk(clk),
		.rst(spif.rst),
		.newd(spif.newd),
		.din(spif.din),
		.dout(spif.dout),
		.done(spif.done)
		/*.sclk(spif.sclk),
		.cs(spif.cs),
		.mosi(spif.mosi)*/
		);

 	i2c_mem DUT_i2c(.clk(clk),
		.rst(vif.rst),
		.wr(vif.wr),
		.addr(vif.addr),
		.din(vif.din),
		.datard(vif.datard),
		.done(vif.done)
		);

// Binding the assertion module
	bind i2c_mem i2c_assertion i2c_assert_inst(
		.clk(clk),
		.rst(rst),
		.state(state),
		.wr(wr),
		.sda(sda),
		.update(update),
		.done(done),
		.en(en),
		.sdat(sdat),
		.nstate(nstate),
		.countn(countn),
		.addrn(addrn),
		.scl(scl),
		.sdan(sdan)
	);

	assign spif.rst = rst;
	assign vif.rst = rst;

  initial begin
	uvm_config_db#(virtual spi_if)::set(null,"uvm_test_top.env.agent*","spi_vif",spif);
	uvm_config_db#(virtual i2c_if)::set(null,"uvm_test_top.env.agenth*","vif",vif);
  end

	always #2 clk = ~clk;
	
	initial begin
		rst = 1'b1;
		#15 rst = 1'b0;
	end

	initial begin
		run_test();
	end



/*  task reset();
	spif.cb_spi_driver.rst <= 1'b1;
	repeat(10)@(spif.cb_spi_driver);
	spif.cb_spi_driver.rst <= 1'b0;
  endtask*/
 

endmodule
