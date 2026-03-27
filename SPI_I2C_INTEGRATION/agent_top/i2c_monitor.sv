class i2c_monitor extends uvm_monitor;
`uvm_component_utils(i2c_monitor)

virtual i2c_if vif;

uvm_analysis_port#(i2c_xtn)mon_port;

i2c_xtn xtn;

function new(string name="i2c_monitor",uvm_component parent);
	super.new(name,parent);
	xtn=i2c_xtn::type_id::create("xtn");
	mon_port=new("mon_port",this);
endfunction

virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual i2c_if)::get(this,"","vif",vif))
		`uvm_fatal("Monitor","Cannot get vif in Monitor?")
endfunction

virtual task run_phase(uvm_phase phase);
	super.run_phase(phase);
	 forever begin
        @(posedge vif.done);
        xtn = i2c_xtn::type_id::create("xtn");
        xtn.wr     = vif.wr;
        xtn.addr   = vif.addr;
        xtn.din    = vif.din;
        xtn.done   = vif.done;
        xtn.datard = vif.datard;
        mon_port.write(xtn);
    end
endtask

endclass
