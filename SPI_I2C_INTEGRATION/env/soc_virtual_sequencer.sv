class soc_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(soc_virtual_sequencer)

  spi_sequencer spi_sqr;
  i2c_sequencer i2c_sqr;

  function new(string name,uvm_component parent);
	super.new(name,parent);
  endfunction 
endclass
