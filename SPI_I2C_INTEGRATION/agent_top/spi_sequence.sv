class spi_sequence extends uvm_sequence #(spi_transaction);
	`uvm_object_utils(spi_sequence)

  function new(string name = "spi_sequence");
	super.new(name);
  endfunction

  virtual task body();
	spi_transaction tx;

	repeat(10) begin
	  tx = spi_transaction::type_id::create("tx");
	  start_item(tx);
	  if(!tx.randomize())begin
		`uvm_error(get_type_name(), "randomization failed") end
	  else begin
		`uvm_info(get_type_name(), $sformatf("generated din = %0h", tx.din), UVM_LOW) end
	  finish_item(tx);
	end
  endtask
endclass
