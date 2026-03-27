class spi_scb extends uvm_scoreboard;
	`uvm_component_utils(spi_scb)
 uvm_analysis_imp #(spi_transaction,spi_scb) sb_imp;

 int total_transaction;
 int match_transaction;
 int mismatch_transaction;
 
 function new(string name,uvm_component parent);
	super.new(name,parent);
	sb_imp = new("sb_imp",this);
 endfunction

 function void write(spi_transaction tx);
	`uvm_info(get_type_name(),$sformatf("Scoreboard received data din = %0h dout = %0h", tx.din,tx.dout), UVM_LOW)
	total_transaction++;
	if(tx.din == tx.dout) begin
		match_transaction++;
		`uvm_info(get_type_name(),$sformatf("SPI Transaction data match din = %0h dout = %0h",tx.din,tx.dout),UVM_LOW)
	end
	else begin
		mismatch_transaction++;
		`uvm_error(get_type_name(),$sformatf("SPI transaction data mismatch din = %0h dout = %0h",tx.din,tx.dout)) end
 endfunction

 function void report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"=================== SPI SCOREBOARD SUMMARY =========================",UVM_NONE)
	`uvm_info(get_type_name(),$sformatf("Total transaction = %0d",total_transaction),UVM_NONE)
	`uvm_info(get_type_name(),$sformatf("Matched transaction = %0d",match_transaction),UVM_NONE)
	`uvm_info(get_type_name(),$sformatf("Mismatched transaction = %0d",mismatch_transaction),UVM_NONE)
	`uvm_info(get_type_name(),"=================== SPI SCOREBOARD SUMMARY =========================",UVM_NONE)
 endfunction
endclass
