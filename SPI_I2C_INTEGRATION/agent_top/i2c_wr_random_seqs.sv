class i2c_wr_random_seqs extends i2c_seqs_base;
	`uvm_object_utils(i2c_wr_random_seqs)

  function new(string name ="i2c_wr_random_seqs");
	super.new(name);
  endfunction

 virtual task body();
	do_write(50);
	do_read(50);
 endtask

 task do_write(int num_xtn);
	i2c_xtn xtn;
	repeat(num_xtn)begin
	  xtn = i2c_xtn::type_id::create("xtn");
	  start_item(xtn);
	  assert(xtn.randomize() with {  
		addr inside {[7'h00 : 7'h7F]};
		din inside  {[8'h00 : 8'hFF]};
		wr == 1'b1; 
		});
	  finish_item(xtn);
	 `uvm_info(get_type_name(),$sformatf("[write] address = %0h,din=%0h", xtn.addr,xtn.din),UVM_LOW)
	end
 endtask

 task do_read(int num_xtn);
	i2c_xtn xtn;
	repeat(num_xtn) begin
	 xtn = i2c_xtn::type_id::create("xtn");
  	  start_item(xtn);
	  assert(xtn.randomize() with {
		addr inside {[7'h00 : 7'h7F]};
		wr == 1'b0;
		});
	  finish_item(xtn);
	 `uvm_info(get_type_name(),$sformatf("[READ] addr = %0h",xtn.addr),UVM_LOW)
	end
 endtask
endclass
