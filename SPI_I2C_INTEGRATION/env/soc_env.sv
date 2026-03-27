class soc_env extends uvm_env;
	`uvm_component_utils(soc_env)

 spi_agent agent;
 spi_scb scb;

 i2c_agent agenth;
 i2c_scoreboard scbh; 

 soc_env_config sicfg;

 soc_virtual_sequencer vsqr;

 function new(string name,uvm_component parent);
	super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(),"SOC ENV Build phase",UVM_LOW)

	if(!uvm_config_db #(soc_env_config)::get(this,"","soc_env_config",sicfg))
	  `uvm_fatal(get_type_name(),"config object not found in the config_db")
	
	if(sicfg.has_spi_agent) begin
	agent = spi_agent::type_id::create("agent",this); end

	if(sicfg.has_spi_scoreboard) begin
	scb   = spi_scb::type_id::create("scb",this); end

	if(sicfg.has_i2c_agent) begin
	agenth = i2c_agent::type_id::create("agenth",this); end

	if(sicfg.has_i2c_scoreboard) begin
	scbh = i2c_scoreboard::type_id::create("scbh",this); end

	vsqr = soc_virtual_sequencer::type_id::create("vsqr",this);

 endfunction

 function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info(get_type_name(),"SOC ENV Connect phase",UVM_NONE)

	if(sicfg.has_spi_agent && sicfg.spi_is_active == UVM_ACTIVE)
	vsqr.spi_sqr = agent.sqr;

	if(sicfg.has_i2c_agent && sicfg.i2c_is_active == UVM_ACTIVE)
	vsqr.i2c_sqr = agenth.seqrh;

	if(sicfg.has_spi_scoreboard && sicfg.has_spi_agent) begin
	agent.mon.mon_ap.connect(scb.sb_imp); 
	`uvm_info(get_type_name(),"spi monitor scorboard connection done",UVM_NONE) end

	if(sicfg.has_i2c_scoreboard && sicfg.has_i2c_agent) begin
	agenth.monh.mon_port.connect(scbh.sb_imp);
	`uvm_info(get_type_name(),"i2c monitor scoreboard connection done",UVM_NONE) end
 endfunction
endclass
