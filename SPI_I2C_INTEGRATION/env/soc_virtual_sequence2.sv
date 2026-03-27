class soc_virtual_sequence2 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence2)
  
 function new(string name = "soc_virtual_sequence2");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_seqs_single_write i2c_write;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_write = i2c_seqs_single_write::type_id::create("i2c_write");

	fork
	    spi_seq.start(spi_sqr);
	    i2c_write.start(i2c_sqr);
	join
 endtask
endclass
