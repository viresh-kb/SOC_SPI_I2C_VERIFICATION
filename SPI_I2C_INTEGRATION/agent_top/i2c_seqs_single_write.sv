class i2c_seqs_single_write extends i2c_seqs_base;

	`uvm_object_utils(i2c_seqs_single_write)
	i2c_xtn xtn;
	int temp=4;

function new(string name ="i2c_seqs_write");
	super.new(name);
endfunction

task pre_body();
	xtn=i2c_xtn::type_id::create("xtn");
endtask

virtual task body();
	`uvm_info("SEQ", "=== SEQUENCE BODY STARTED ===", UVM_LOW) 	
		for(int i=0;i<temp;i++)
		begin
			`uvm_info("SEQ", $sformatf("Starting xtn %0d", i), UVM_LOW)
			start_item(xtn);
			xtn.wr   = 1'b1;
			xtn.addr = 7'h00;
			xtn.din  = 8'h00;
			`uvm_info("DEBUB IN SEQS",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)
			`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)
			finish_item(xtn);
		end
endtask

endclass
