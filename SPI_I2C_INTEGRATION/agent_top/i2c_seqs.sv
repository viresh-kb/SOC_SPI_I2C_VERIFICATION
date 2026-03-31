class i2c_seqs_base extends uvm_sequence #(i2c_xtn);
`uvm_object_utils(i2c_seqs_base)

function new(string name="i2c_seqs_base");
	super.new(name);
endfunction
endclass

/*class i2c_reset extends i2c_seqs_base;
i2c_xtn xtn;

`uvm_object_utils(i2c_reset)

function new (string name = "i2c_reset");
    super.new(name);
endfunction

  task pre_body();
        xtn = i2c_xtn::type_id::create("xtn");
    endtask

    task body();
            start_item(xtn);
            void'(xtn.randomize() with {
                                  rst == 1;});
            finish_item(xtn);
    
    endtask

  endclass*/

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
		//	assert(xtn.randomize() with {wr==1;});
			xtn.wr   = 1'b1;
		//	xtn.rst  = 1'b0;
			xtn.addr = 7'h00;
			xtn.din  = 8'h00;
			`uvm_info("DEBUB IN SEQS",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)
			`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)

			finish_item(xtn);
		end

endtask

endclass

class i2c_seqs_single_write1 extends i2c_seqs_base;

	`uvm_object_utils(i2c_seqs_single_write1)
	i2c_xtn xtn;
	int temp=4;

function new(string name ="i2c_seqs_single_write1");
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
		//	assert(xtn.randomize() with {wr==1 ;});
			xtn.wr   = 1'b1;
		//	xtn.rst  = 1'b0;
			xtn.addr = 7'h7F;
			xtn.din  = 8'hFF;
			`uvm_info("DEBUB IN SEQS",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)
			`uvm_info(get_type_name(),$sformatf("Max boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)

			finish_item(xtn);
		end

endtask

endclass

class i2c_seq_single_read extends i2c_seqs_base;
`uvm_object_utils(i2c_seq_single_read)
i2c_xtn xtn;
int temp=4;


function new(string name="i2c_seq_single_read");
	super.new(name);
endfunction

task pre_body();
        xtn = i2c_xtn::type_id::create("xtn");
endtask

virtual task body();

      for(int i = 0; i < temp; i++) begin

            start_item(xtn);
            /*assert(xtn.randomize() with {
                             //       rst == 0;
                                    wr == 0;});*/
	   xtn.wr   = 1'b0;
//	   xtn.rst  = 1'b0;
 	   xtn.addr = 7'h01;
	`uvm_info("DEBUB IN SEQS1",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)

 //           finish_item(xtn);

	`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h",xtn.wr,xtn.addr), UVM_LOW)

	   finish_item(xtn);
		end

  endtask
endclass

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
            /*assert(xtn.randomize() with {
                                    rst == 0;
                                    wr == 0;});*/
	   xtn.wr   = 1'b0;
//	   xtn.rst  = 1'b0;
 	   xtn.addr = 7'h7F;
	`uvm_info("DEBUB IN SEQS1",$sformatf("RANDOMIZED THE DATA"),UVM_NONE)

            finish_item(xtn);
	`uvm_info(get_type_name(),$sformatf("Max boundary condition values wr = %0h,addr=%0h",xtn.wr,xtn.addr), UVM_LOW)
        end

  endtask
endclass

class i2c_write_read_seqs extends i2c_seqs_base;
	`uvm_object_utils(i2c_write_read_seqs)

// queue to store the address
 bit [6:0] addr_q[$];

 function new(string name = "i2c_write_read_seqs");
	super.new(name);
 endfunction

 virtual task body();

	do_write(500);
	do_read();	
 endtask

// write task
 task do_write(int num_xtn);
    i2c_xtn xtn; 
    repeat(num_xtn) begin
	xtn = i2c_xtn::type_id::create("xtn");

	start_item(xtn);

	assert(xtn.randomize() with { 
		addr inside {[7'h00 : 7'h7F]};  // address ranges from 0 to 127
		din inside {[8'h00 : 8'hFF]};   // din data ranges from 0 to 255
		wr == 1'b1;
//		rst == 1'b0;
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
//	xtn.rst = 1'b0;
	xtn.addr = addr_q[i];
	finish_item(xtn);
	`uvm_info(get_type_name(), $sformatf("READ addr = %0h",xtn.addr),UVM_LOW)
     end
 endtask

endclass

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
		addr inside {[7'h00 : 7'h7F]};    // address ranges from 0 to 127
		din inside  {[8'h00 : 8'hFF]};    // din data ranges from 0 to 255
		wr == 1'b1; 
//		rst == 1'b0;
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
		addr inside {[7'h00 : 7'h7F]};    // address ranges from 64 to 127
		wr == 1'b0;
//		rst == 1'b0;
		});

	  finish_item(xtn);
	 `uvm_info(get_type_name(),$sformatf("[READ] addr = %0h",xtn.addr),UVM_LOW)
	end
 endtask
endclass

class i2c_wrq_seqs extends i2c_seqs_base;

	`uvm_object_utils(i2c_wrq_seqs)

 bit [6:0] addr_q[$];

 function new(string name = "i2c_wrq_seqs");
	super.new(name);
 endfunction

 virtual task body();

	do_write(500);
	do_read(500);
	
 endtask

// write task
 task do_write(int num_xtn);
    i2c_xtn xtn;
    repeat(num_xtn) begin
		xtn = i2c_xtn::type_id::create("xtn");

	start_item(xtn);

	assert(xtn.randomize() with {
		addr inside {[7'h00 : 7'h7F]};    // address ranges from 0 to 127
		din inside  {[8'h00 : 8'hFF]};    // din data ranges from 0 to 255
		wr == 1'b1;
//		rst == 1'b0;
		});
	finish_item(xtn);

	addr_q.push_back(xtn.addr);

	`uvm_info(get_type_name(),$sformatf("write addr=%0h din=%0h",xtn.addr,xtn.din),UVM_LOW)
    end
 endtask

 task do_read(int num_xtn);
	i2c_xtn xtn;
	int index;

	if(addr_q.size() == 0) begin
	  `uvm_error(get_type_name(),"No address is written yet!")
	  return;
	end
	


     repeat(num_xtn) begin
	xtn = i2c_xtn::type_id::create("xtn");

	index = $urandom_range(0,addr_q.size()-1);

	start_item(xtn);
//	addr inside {[7'h40 : 7'h7F]};    // address ranges from 64 to 127
	xtn.wr = 1'b0;
//	xtn.rst = 1'b0;
	xtn.addr = addr_q[index];

	finish_item(xtn);
	`uvm_info(get_type_name(),$sformatf("RANDOM READ FROM QUEUE addr = %0h",xtn.addr),UVM_LOW)
     end
 endtask

endclass

/*class i2c_min_boundary extends i2c_seqs_base;
	`uvm_object_utils(i2c_min_address)

  function new(string name = "i2c_min_boundary");
	super.new(name);
  endfunction

 virtual task body();
	i2c_xtn xtn;
	repeat(5) beign
	xtn = i2c_xtn::type_id::create("xtn");

	start_item(xtn);
	
	assert(xtn.randomize() with {
		wr == 1'b1;
		rst == 1'b0;
		addr == 7'h00;
		din == 8'h00;
		});
	finish-item(xtn);
	`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)
 endtask
endclass


class i2c_max_boundary extends i2c_seqs_base;
	`uvm_object_utils(i2c_max_boundary)

  function new(string name = "i2c_max_boundary");
	super.new(name);
  endfunction

 virtual task body();
	i2c_xtn xtn;
	repeat(5) beign
	xtn = i2c_xtn::type_id::create("xtn");

	start_item(xtn);

	assert(xtn.randomize() with {
		wr == 1'b1;
		rst == 1'b0;
		addr == 7'h7F;
		din == 8'hFF;
		});
	finish-item(xtn);
	`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)
 endtask
endclass


class i2c_min_range extends i2c_seqs_base;
	`uvm_object_utils(i2c_min_range)

  function new(string name = "i2c_max_boundary");
	super.new(name);
  endfunction

 virtual task body();
	i2c_xtn xtn;
	repeat(5) beign
	xtn = i2c_xtn::type_id::create("xtn");

	start_item(xtn);

	assert(xtn.randomize() with {
		wr == 1'b1;
		rst == 1'b0;
		addr == 7'h7F;
		din == 8'hFF;
		});
	finish-item(xtn);
	`uvm_info(get_type_name(),$sformatf("Min boundary condition values wr = %0h,addr=%0h,din=%0h", xtn.wr,xtn.addr,xtn.din), UVM_LOW)
 endtask
endclass*/
