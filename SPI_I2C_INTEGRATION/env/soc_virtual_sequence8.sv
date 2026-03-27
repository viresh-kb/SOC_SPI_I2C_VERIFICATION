class soc_virtual_sequence8 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence8)

 function new(string name = "soc_virtual_sequence8");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_wrq_seqs i2c_wrq;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_wrq = i2c_wrq_seqs::type_id::create("i2c_wrq");

	fork
	    spi_seq.start(spi_sqr);
	    i2c_wrq.start(i2c_sqr);
	join
 endtask
endclass
