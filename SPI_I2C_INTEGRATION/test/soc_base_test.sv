class soc_base_test extends uvm_test;
	`uvm_component_utils(soc_base_test)

  soc_env env;
  soc_virtual_sequence vseq;
  soc_env_config sicfg;

  function new(string name,uvm_component parent);
	super.new(name,parent);
  endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(),"SPI BASE_TEST Build phase",UVM_LOW);
	
	sicfg = soc_env_config::type_id::create("sicfg");

	sicfg.spi_is_active = UVM_ACTIVE;
	sicfg.i2c_is_active = UVM_ACTIVE;
	sicfg.has_spi_agent = 1;
	sicfg.has_i2c_agent = 1;
	sicfg.has_functional_coverage = 0;
	sicfg.has_spi_scoreboard = 1;
	sicfg.has_spi_scoreboard = 1;

	uvm_config_db#(soc_env_config)::set(this,"*","soc_env_config",sicfg);	
	
	env = soc_env::type_id::create("env",this);
  endfunction

 function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	`uvm_info(get_type_name(),"SPI BASE_TEST end of elaboration phase", UVM_LOW)
	uvm_top.print_topology();
 endfunction

 
endclass
