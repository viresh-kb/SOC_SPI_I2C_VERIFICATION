class spi_driver extends uvm_driver #(spi_transaction);
	`uvm_component_utils(spi_driver)
  virtual spi_if vif1;

  function new(string name , uvm_component parent);
	super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(), "SPI Driver build phase", UVM_NONE);
	if(!(uvm_config_db #(virtual spi_if)::get(this,"","spi_vif",vif1)))
		`uvm_fatal(get_type_name(), "driver did not get virtual interface")
  endfunction

  virtual task run_phase(uvm_phase phase);
	 spi_transaction tx;
	`uvm_info(get_type_name(), "SPI Driver run_phase task", UVM_LOW)

	forever begin
	  seq_item_port.get_next_item(tx);
	  drive_spi_transaction(tx);
	  seq_item_port.item_done();
	end
   endtask

  virtual task drive_spi_transaction(spi_transaction tx);
	`uvm_info(get_type_name(),$sformatf("driving transactions din = %0h", tx.din),UVM_LOW)
	vif1.cb_spi_driver.din <= tx.din;
	vif1.cb_spi_driver.newd <= 1'b1;
	repeat(22)@(vif1.cb_spi_driver);
	vif1.cb_spi_driver.newd <= 1'b0;
	wait(vif1.cb_spi_driver.done == 1'b1);
	`uvm_info(get_type_name(), "SPI Transaction completed",UVM_LOW)
  endtask
endclass
