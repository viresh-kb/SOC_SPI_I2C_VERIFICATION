interface spi_if(input bit clk);

   // master signals
  	logic	     rst;
	logic 	     newd;
	logic [11:0] din;

   // wire signals master output to slave input
 	logic        sclk;
	logic        cs;
	logic        mosi;

   // slave output signals
	logic [11:0] dout;
	logic        done;

  clocking cb_spi_driver @(posedge clk);
	output rst;
	output din;
	output newd;
	input done;
  endclocking

  clocking cb_spi_monitor @(posedge clk);
	input sclk;
	input cs;
	input mosi;
	input dout;
	input done;
	input din;
  endclocking

  modport drv_mp(clocking cb_spi_driver);
  modport mon_mp(clocking cb_spi_monitor);
endinterface
