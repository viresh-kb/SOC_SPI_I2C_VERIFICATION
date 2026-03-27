class spi_monitor extends uvm_monitor;
	`uvm_component_utils(spi_monitor)
  virtual spi_if vif2;
  uvm_analysis_port #(spi_transaction) mon_ap;

  function new(string name , uvm_component parent);
	super.new(name , parent);
	mon_ap = new("mon_ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(), "SPI MONITOR Build phase", UVM_LOW)
	if(!(uvm_config_db #(virtual spi_if)::get(this,"","spi_vif",vif2)))
	   `uvm_fatal(get_type_name(),"monitor has not got virtual interface in config db")
  endfunction

 virtual task run_phase(uvm_phase phase);
	spi_transaction tx;
	forever begin
	`uvm_info(get_type_name(),"Monitoring the data",UVM_LOW)
	wait(vif2.cb_spi_monitor.done == 1'b1);
	tx = spi_transaction::type_id::create("tx");
	tx.din = vif2.cb_spi_monitor.din;
	tx.dout = vif2.cb_spi_monitor.dout;
	`uvm_info(get_type_name(),$sformatf("Monitored data din = %0h dout = %0h", tx.din,tx.dout), UVM_LOW)
	mon_ap.write(tx);
	wait(vif2.cb_spi_monitor.done == 1'b0);
  	end
 endtask
endclass
