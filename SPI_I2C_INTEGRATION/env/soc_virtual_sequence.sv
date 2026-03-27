class soc_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(soc_virtual_sequence)

 soc_env_config sicfg;
 `uvm_declare_p_sequencer(soc_virtual_sequencer);

 spi_sequencer spi_sqr;
 i2c_sequencer i2c_sqr;

 function new(string name="soc_virtual_sequence");
	super.new(name);
 endfunction

 virtual task body();
	if(!uvm_config_db#(soc_env_config)::get(null,get_full_name(),"soc_env_config",sicfg))
	   `uvm_fatal(get_type_name(),"config object not found in the config_db")

	if(sicfg.has_spi_agent && sicfg.spi_is_active == UVM_ACTIVE)
	  spi_sqr = p_sequencer.spi_sqr;

	if(sicfg.has_i2c_agent && sicfg.i2c_is_active == UVM_ACTIVE)
   	  i2c_sqr = p_sequencer.i2c_sqr;	
	
 endtask
endclass
