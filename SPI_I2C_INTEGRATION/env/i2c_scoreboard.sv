class i2c_scoreboard extends uvm_scoreboard;

`uvm_component_utils(i2c_scoreboard)

i2c_xtn xtn;

uvm_analysis_imp #(i2c_xtn,i2c_scoreboard)sb_imp;

	int unsigned passed_cases = 0;
  	int unsigned failed_cases = 0;
	int unsigned total_cases  = 0;

  	logic [7:0] ref_mem[128] = '{default:0};
  	logic [7:0] ref_dout;

covergroup i2c_cg;

	cp_wr : coverpoint xtn.wr {
		bins read  = {0};
		bins write = {1};
	}

	cp_addr : coverpoint xtn.addr {
		bins addr_min  = {7'h00};
		bins addr_max  = {7'h7F};
		bins addr_low  = {[7'h00 : 7'h3F]};
		bins addr_full = {[7'h40 : 7'h7F]};
	}

	cp_din : coverpoint xtn.din iff (xtn.wr == 1){
		bins din_min  = {8'h00};
		bins din_max  = {8'hFF};
		bins din_low  = {[8'h00 : 8'h7F]};
		bins din_full = {[8'h80 : 8'hFF]};
	}
	
	cp_datard : coverpoint xtn.datard {
		bins data_rd_min  = {8'h00};
		bins data_rd_max  = {8'hFF};
		bins data_rd_low  = {[8'h00 : 8'h3F]};
		bins data_rd_med  = {[8'h40 : 8'h7F]};
		bins data_rd_high = {[8'h80 : 8'hC4]};
		bins data_rd_full = {[8'hC5 : 8'hFF]};
	}

endgroup

function new(string name="i2c_scoreboard",uvm_component parent);
	super.new(name,parent);
	i2c_cg = new();
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	sb_imp = new("sb_imp",this);
endfunction

function void write(i2c_xtn xtn);
	this.xtn = xtn;
	total_cases++;
	`uvm_info("SCOREBOARD", $sformatf("GOT: wr=%0d addr=%0d", xtn.wr, xtn.addr), UVM_NONE)

	if(i2c_cg == null) begin
		`uvm_fatal(get_type_name(),"covergroup handle is null") end

	if(xtn == null) begin
		`uvm_fatal(get_type_name(),"transaction handle is null") end

	i2c_cg.sample();

          if (xtn.wr == 1) begin
                ref_mem[xtn.addr] = xtn.din;
		passed_cases++;
	`uvm_info(get_type_name(), $sformatf("WRITE: addr=%0d din=%02d PASSED:%0d", xtn.addr, xtn.din, passed_cases), UVM_NONE)
	return;
            end

		if (!xtn.wr) begin
                    ref_dout = ref_mem[xtn.addr];
                    if (ref_dout == xtn.datard) begin
                        passed_cases++;
                        `uvm_info(get_type_name(), $sformatf("PASSED CASE: %0d", passed_cases), UVM_NONE)
                        `uvm_info(get_type_name(), $sformatf("ref_dout: %0d", ref_dout), UVM_NONE)
                        `uvm_info(get_type_name(), $sformatf("xtn.datard: %0d", xtn.datard), UVM_NONE)
                    end
                    else begin
                        failed_cases++;
                        `uvm_info(get_type_name(), $sformatf("FAILED CASE: %0d", failed_cases), UVM_NONE)
                        `uvm_info(get_type_name(), $sformatf("ref_dout: %0d xtn.datard: %0d ", ref_dout, xtn.datard ), UVM_NONE)
                    end
        end
endfunction

function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info(get_type_name(), $sformatf("TOTAL CASES: %0d", total_cases), UVM_NONE)
	`uvm_info(get_type_name(), $sformatf("PASSED CASES: %0d", passed_cases), UVM_NONE)
	`uvm_info(get_type_name(), $sformatf("FAILED CASES: %0d", failed_cases), UVM_NONE)
endfunction

endclass
