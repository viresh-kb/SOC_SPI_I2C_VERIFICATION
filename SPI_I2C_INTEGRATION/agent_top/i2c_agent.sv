class i2c_agent extends uvm_agent;
`uvm_component_utils(i2c_agent)

i2c_monitor monh;
i2c_driver drvh;
i2c_sequencer seqrh;

soc_env_config sicfg;

function new(string name="i2c_agent",uvm_component parent);
	super.new(name,parent);
endfunction


virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(),"Entered i2c build phase",UVM_NONE)

	if(!uvm_config_db #(soc_env_config)::get(this,"","soc_env_config",sicfg))
		`uvm_fatal(get_type_name,"config object not found in config_db")

	monh=i2c_monitor::type_id::create("monh",this);

	if(sicfg.i2c_is_active == UVM_ACTIVE) begin
		drvh=i2c_driver::type_id::create("drvh",this);
		seqrh=i2c_sequencer::type_id::create("seqrh",this); end

endfunction


virtual function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("DEBUG", $sformatf("Hello from i2c agent connect phase"), UVM_NONE)
	if(sicfg.i2c_is_active == UVM_ACTIVE) begin
		drvh.seq_item_port.connect(seqrh.seq_item_export);
		`uvm_info(get_type_name(),"i2c driver sequencer connection is done",UVM_NONE) end

endfunction

endclass
