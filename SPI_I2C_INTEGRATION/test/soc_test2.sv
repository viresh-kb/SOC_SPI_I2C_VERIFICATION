class soc_test2 extends soc_base_test;
	`uvm_component_utils(soc_test2)

 function new(string name,uvm_component parent);
	super.new(name,parent);
 endfunction

 virtual task run_phase(uvm_phase phase);
	soc_virtual_sequence2 vseq;
	phase.raise_objection(this);
	vseq=soc_virtual_sequence2::type_id::create("vseq");
	vseq.start(env.vsqr);
	phase.drop_objection(this);
 endtask
endclass
