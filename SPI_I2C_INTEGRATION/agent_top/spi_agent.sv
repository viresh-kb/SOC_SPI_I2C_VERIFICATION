class spi_agent extends uvm_agent;
	`uvm_component_utils(spi_agent)
  
  spi_driver drv;
  spi_monitor mon;
  spi_sequencer sqr;

  soc_env_config sicfg;

 function new(string name , uvm_component parent);
	super.new(name , parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(), "SPI AGENT Build phase", UVM_LOW)

	if(!uvm_config_db #(soc_env_config)::get(this,"","soc_env_config",sicfg))
	   `uvm_fatal(get_type_name(),"configuaration object not found in config_db")

	mon = spi_monitor::type_id::create("mon",this);

	if(sicfg.spi_is_active == UVM_ACTIVE) begin
		drv = spi_driver::type_id::create("drv",this);
		sqr = spi_sequencer::type_id::create("sqr",this); end
 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info(get_type_name(),"SPI AGENT Connect phase", UVM_LOW)
	if(sicfg.spi_is_active == UVM_ACTIVE) begin
		drv.seq_item_port.connect(sqr.seq_item_export);
		`uvm_info(get_type_name(), "Driver and sequencer connection is done",UVM_LOW) end
 endfunction
endclass
