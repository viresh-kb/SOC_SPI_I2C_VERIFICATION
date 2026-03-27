class soc_virtual_sequence4 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence4)

 function new(string name = "soc_virtual_sequence4");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_seq_single_read i2c_rd;

	super.body();

	spi_seq = spi_sequence::type_id::create("spi_seq");
	i2c_rd = i2c_seq_single_read::type_id::create("i2c_rd");
	fork
	    spi_seq.start(spi_sqr);
	    i2c_rd.start(i2c_sqr);
	join
 endtask
endclass 
