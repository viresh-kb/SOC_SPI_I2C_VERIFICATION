class i2c_xtn extends uvm_sequence_item;
`uvm_object_utils(i2c_xtn)

rand logic wr ;
rand logic[6:0] addr;
rand logic[7:0] din;

logic[7:0] datard;
logic done;


virtual function string convert2string();

 string result =  $sformatf("wr = %0d  addr = %0d din = %0d datard = %0d done = %0d", wr,addr,din,datard,done);

 return result;

 endfunction

function new (string name="i2c_xtn");
super.new(name);
endfunction

endclass
