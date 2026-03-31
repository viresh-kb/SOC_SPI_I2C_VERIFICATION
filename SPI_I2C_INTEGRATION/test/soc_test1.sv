class soc_test1 extends soc_base_test;
	`uvm_component_utils(soc_test1) 

 function new(string name,uvm_component parent);
	super.new(name,parent);
 endfunction

 virtual task run_phase(uvm_phase phase);
	soc_virtual_sequence1 vseq;
	phase.raise_objection(this);
	vseq=soc_virtual_sequence1::type_id::create("vseq1");
	vseq.start(env.vsqr);
	#1000;
	phase.drop_objection(this);
 endtask
endclass
