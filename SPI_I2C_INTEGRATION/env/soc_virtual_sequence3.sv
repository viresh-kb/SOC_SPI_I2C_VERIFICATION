class soc_virtual_sequence3 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence3)
  
 function new(string name = "soc_virtual_sequence3");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_seqs_single_write1 i2c_write1;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_write1 = i2c_seqs_single_write1::type_id::create("i2c_write1");

	fork
	    spi_seq.start(spi_sqr);
	    i2c_write1.start(i2c_sqr);
	join
 endtask
endclass
