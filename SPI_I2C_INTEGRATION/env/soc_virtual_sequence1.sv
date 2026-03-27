class soc_virtual_sequence1 extends soc_virtual_sequence;
	`uvm_object_utils(soc_virtual_sequence1)

  function new(string name="soc_virtual_sequence1");
	super.new(name);
  endfunction

 virtual task body();
	spi_sequence spi_seq;
	
	super.body();
	
	spi_seq = spi_sequence::type_id::create("spi_seq");

	fork
	   spi_seq.start(spi_sqr);
	join
 endtask
endclass
