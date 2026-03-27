class soc_virtual_sequence7 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence7)

 function new(string name = "soc_virtual_sequence7");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_wr_random_seqs i2c_wr_ran;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_wr_ran = i2c_wr_random_seqs::type_id::create("i2c_wr_ran");

	fork
	    spi_seq.start(spi_sqr);
	    i2c_wr_ran.start(i2c_sqr);
	join
 endtask
endclass
