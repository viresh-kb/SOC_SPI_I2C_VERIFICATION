class soc_virtual_sequence6 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence6)

 function new(string name = "soc_virtual_sequence6");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_write_read_seqs i2c_wr;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_wr = i2c_write_read_seqs::type_id::create("i2c_wr");

	fork
	    spi_seq.start(spi_sqr);
	    i2c_wr.start(i2c_sqr);
	join
 endtask
endclass
