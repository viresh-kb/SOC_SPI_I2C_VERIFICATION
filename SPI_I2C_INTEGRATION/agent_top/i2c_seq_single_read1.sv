class i2c_seq_single_read1 extends i2c_seqs_base;
`uvm_object_utils(i2c_seq_single_read1)
i2c_xtn xtn;
int temp=4;

function new(string name="i2c_seq_single_read1");
super.new(name);
endfunction

task pre_body();
        xtn = i2c_xtn::type_id::create("xtn");
endtask

virtual task body();
      for(int i = 0; i < temp; i++) begin
            start_item(xtn);
	   xtn.wr   = 1'b0;
 	   xtn.addr = 7'h7F;
	`uvm_info("DEBUB IN SEQS1",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)
            finish_item(xtn);
	`uvm_info(get_type_name(),$sformatf("Max boundary condition values wr = %0h,addr=%0h",xtn.wr,xtn.addr), UVM_LOW)
        end
  endtask
endclass
