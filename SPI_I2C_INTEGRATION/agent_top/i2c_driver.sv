class i2c_driver extends uvm_driver #(i2c_xtn);

`uvm_component_utils(i2c_driver)

function new(string name= "i2c_driver" ,uvm_component parent);
	super.new(name,parent);
endfunction

virtual i2c_if vif;

i2c_xtn xtn;

virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual i2c_if):: get(this ,"","vif",vif))
		`uvm_fatal("Driver","Cannot get Vif?")
endfunction

virtual task run_phase(uvm_phase phase);
	super.run_phase(phase);
 	`uvm_info("DEBUG IN DRIVER",$sformatf("Hello from Driver!"),UVM_NONE)

forever begin
		`uvm_info("DRIVER", "Waiting for item...", UVM_NONE)
		seq_item_port.get_next_item(xtn);
		`uvm_info("DRIVER", $sformatf("Got item: wr=%0h din=%0h addr=%0h ", xtn.wr,xtn.din,xtn.addr), UVM_NONE)

            vif.wr <= xtn.wr;
            vif.addr <= xtn.addr;
            vif.din <= xtn.din;
            @(posedge vif.done);
        #1step;
		seq_item_port.item_done();
	end
endtask

endclass
