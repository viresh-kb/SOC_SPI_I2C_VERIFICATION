class soc_env_config extends uvm_object;
	`uvm_object_utils(soc_env_config)

	virtual spi_if spi_vif;
	virtual i2c_if i2c_vif;

	uvm_active_passive_enum spi_is_active = UVM_ACTIVE;
	uvm_active_passive_enum i2c_is_active = UVM_ACTIVE;

	bit has_spi_agent = 1;
	bit has_i2c_agent = 1;
	bit has_spi_scoreboard = 1;
	bit has_i2c_scoreboard = 1;
	bit has_functional_coverage = 0;

  function new(string name = "soc_env_config");
	super.new(name);
  endfunction
endclass
