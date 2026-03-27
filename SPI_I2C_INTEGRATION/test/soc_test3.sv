class soc_test3 extends uvm_test;
	`uvm_component_utils(soc_test3)

  soc_env envh;
  soc_env_config sicfg;
  soc_virtual_sequence2 vseq;

  function new(string name, uvm_component parent);
	super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	sicfg = new("sicfg");
	if(!uvm_config_db #(soc_env_config)::get(this,"","soc_env_config",sicfg))
	  `uvm_fatal(get_type_name(),"config not found")
	uvm_config_db #(soc_env_config)::set(this,"*","soc_env_config",sicfg);
	envh = soc_env::type_id::create("envh",this);
	vseq = soc_virtual_sequence2::type_id::create("vseq");
  endfunction

  task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	`uvm_info(get_type_name(),"soc_test3: SPI + I2C min boundary write",UVM_NONE)
	vseq.start(envh.vsqr);
	#100;
	phase.drop_objection(this);
  endtask
endclass
