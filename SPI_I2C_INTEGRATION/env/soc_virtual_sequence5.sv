class soc_virtual_sequence5 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence5)
 
 function new(string name = "soc_virtual_sequence5");
	super.new(name);
 endfunction

 virtual task body();
	spi_sequence spi_seq;
	i2c_seq_single_read1 i2c_rd1;

	super.body();

	spi_seq=spi_sequence::type_id::create("spi_seq");
	i2c_rd1 = i2c_seq_single_read1::type_id::create("i2c_rd1");

	fork
	   spi_seq.start(spi_sqr);
	   i2c_rd1.start(i2c_sqr);
	join
 endtask
endclass
