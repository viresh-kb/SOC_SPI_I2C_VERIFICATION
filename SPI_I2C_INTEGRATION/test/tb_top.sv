`include "uvm_macros.svh"
import uvm_pkg::*;
import soc_pkg_file::*;

module tb_top;

  bit clk;
  bit i2c_clk;

  spi_if spif(clk);
  i2c_if i2cvif(i2c_clk);

  top spi_dut(
    .clk(clk),
    .rst(spif.rst),
    .newd(spif.newd),
    .din(spif.din),
    .dout(spif.dout),
    .done(spif.done)
  );

  i2c_mem i2c_dut(
    .clk(i2c_clk),
    .rst(i2cvif.rst),
    .wr(i2cvif.wr),
    .addr(i2cvif.addr),
    .din(i2cvif.din),
    .datard(i2cvif.datard),
    .done(i2cvif.done)
  );

  always #2  clk     = ~clk;
  always #10 i2c_clk = ~i2c_clk;

  initial begin
    soc_env_config sicfg;
    sicfg = new("sicfg");
    sicfg.spi_vif = spif;
    sicfg.i2c_vif = i2cvif;
    uvm_config_db #(soc_env_config)::set(null,"*","soc_env_config",sicfg);
    uvm_config_db #(virtual spi_if)::set(null,"*","spi_vif",spif);
    uvm_config_db #(virtual i2c_if)::set(null,"*","vif",i2cvif);
    run_test();
  end

  initial begin
    spif.rst  = 1'b1;
    i2cvif.rst = 1'b1;
    #20;
    spif.rst  = 1'b0;
    i2cvif.rst = 1'b0;
  end

endmodule
