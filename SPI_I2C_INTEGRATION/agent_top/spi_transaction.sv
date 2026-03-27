class spi_transaction extends uvm_sequence_item;
	`uvm_object_utils(spi_transaction)

  rand logic [11:0] din;
  logic [11:0] dout;

 function new(string name = "spi_transaction");
	super.new(name);
 endfunction
endclass
