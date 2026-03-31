class soc_test7 extends soc_base_test;
	`uvm_component_utils(soc_test7)

 function new(string name,uvm_component parent);
	super.new(name,parent);
 endfunction

 virtual task run_phase(uvm_phase phase);
	soc_virtual_sequence7 vseq;
	phase.raise_objection(this);
	vseq = soc_virtual_sequence7::type_id::create("vseq");
	vseq.start(env.vsqr);
	phase.drop_objection(this);
 endtask
endclass
