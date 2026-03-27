class i2c_write_read_seqs extends i2c_seqs_base;
	`uvm_object_utils(i2c_write_read_seqs)

 bit [6:0] addr_q[$];

 function new(string name = "i2c_write_read_seqs");
	super.new(name);
 endfunction

 virtual task body();
	do_write(500);
	do_read();	
 endtask

 task do_write(int num_xtn);
    i2c_xtn xtn; 
    repeat(num_xtn) begin
	xtn = i2c_xtn::type_id::create("xtn");
	start_item(xtn);
	assert(xtn.randomize() with { 
		addr inside {[7'h00 : 7'h7F]};
		din inside {[8'h00 : 8'hFF]};
		wr == 1'b1;
		});
	finish_item(xtn);
	addr_q.push_back(xtn.addr);
	`uvm_info(get_type_name(),$sformatf("[WRITE] addr=%0h din=%0h",xtn.addr,xtn.din),UVM_LOW)
    end
 endtask

 task do_read();
     i2c_xtn xtn;
     foreach(addr_q[i]) begin
	xtn=i2c_xtn::type_id::create("xtn");
	start_item(xtn);
	xtn.wr = 1'b0;
	xtn.addr = addr_q[i];
	finish_item(xtn);
	`uvm_info(get_type_name(), $sformatf("READ addr = %0h",xtn.addr),UVM_LOW)
     end
 endtask

endclass
