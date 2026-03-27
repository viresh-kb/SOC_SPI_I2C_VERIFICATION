module i2c_assertion(
	input clk,
	input rst,
	input logic [3:0] state,
	input logic wr,
	input logic sda,
	input logic update,
	input logic done,
	input logic en,
	input logic sdat,
	input scl,
	input logic [3:0] nstate,
	input logic [3:0] countn,
	input logic [7:0] addrn,
	input logic [7:0] datan,
	input logic sdan
);

localparam idle        = 4'd0;
localparam start       = 4'd1;
localparam send_addr   = 4'd2;
localparam get_ack1    = 4'd3;
localparam send_data   = 4'd4;
localparam get_ack2    = 4'd5;
localparam read_data   = 4'd6;
localparam complete    = 4'd7;
localparam get_addr    = 4'd8;
localparam send_ack1   = 4'd9;
localparam get_data    = 4'd10;
localparam send_ack2   = 4'd11;

// ================ master assertions ====================

property p_wait_for_ack1;
	@(posedge clk)
	(!rst && state == get_ack1 && sda != 0) |=> (state == get_ack1);
endproperty
assert property(p_wait_for_ack1)
	else $error("FSM ERROR: Exited get_ack1 without ACK");

property p_ack1_write_branch;
	@(posedge clk)
	(!rst && state == get_ack1 && sda == 0 && wr == 1) |=> (state == send_data);
endproperty
assert property(p_ack1_write_branch)
	else $error("FSM ERROR: wrong state transition other than send_data state");

property p_ack1_read_branch;
	@(posedge clk)
	(!rst && state == get_ack1 && sda == 0 && wr == 0) |=> (state == read_data);
endproperty
assert property(p_ack1_read_branch)
	else $error("FSM ERROR: wrong state transition other tham read_state");

property p_wait_for_ack2;
	@(posedge clk)
	(!rst && state == get_ack2 && sda != 0) |=> (state == get_ack2);
endproperty
assert property(p_wait_for_ack2)
	else $error("FSM ERROR: Exited get_ack2 without ACK");

property p_wait_for_update;
	@(posedge clk)
	(!rst && state == complete && update == 0) |=> (state == complete);
endproperty
assert property(p_wait_for_update)
	else $error("FSM ERROR: Exited complete without update");

property p_done_valid;
	@(posedge clk)
	(!rst && done == 1) |-> (state ==  idle);
endproperty
assert property(p_done_valid)
	else $error("FSM ERROR: DONE de-asserted but still state changed");

// =============== slave assertions ==================

property p_start_to_get_addr;
  @(posedge clk)
  (!rst && nstate == start && scl && !sdat) |=> (nstate == get_addr);
endproperty
assert property(p_start_to_get_addr)
  else $error("SLAVE FSM ERROR: start did not transition to get_addr");

property p_addr_collection;
	@(posedge clk)
	(!rst && nstate == get_addr && countn == 8) |=> (nstate == send_ack1);
endproperty
assert property(p_addr_collection)
	else $error("SLAVE ERROR: Adress phase did not complete correctly");

property p_ack1_drive;
	@(posedge clk)
	(!rst && state == send_ack1) |-> (sdan == 0);
endproperty
assert property(p_ack1_drive)
	else $error("SLAVE ERROR: ACK1 not driven low");

property p_data_collect;
	@(posedge clk)
	(!rst && nstate == get_data && countn == 8) |=> (nstate == send_ack2);
endproperty
assert property(p_data_collect)
	else $error("SLAVE ERROR: Data phase did not complete correclty");

property p_update_assert;
	@(posedge clk)
	(!rst && nstate == complete) |=> (update == 1);
endproperty
assert property(p_update_assert)
	else $error("SLAVE ERROR: Update no asserted");

property p_ack1_alignment;
	@(posedge clk)
	(!rst && state == get_ack1) |=> (nstate == send_ack1);
endproperty
assert property(p_ack1_alignment)
	else $error("PROTOCOL ERROR: ACK1 is not aligned with master");

property p_ack2_alignment;
	@(posedge clk)
	(!rst && state == get_ack2) |=> (nstate == send_ack2);
endproperty
assert property(p_ack2_alignment)
	else $error("PROTOCOL ERROR: ACK2 is not aligned with master");

property p_master_driving;
	@(posedge clk)
	(!rst && en ==1 ) |-> (sda == sdat);
endproperty
assert property (p_master_driving)
	else $error("PROTOCOL ERROR: SDA is not driven by the master");

property p_slave_driving;
	@(posedge clk)
	(en ==0 ) |-> (sda === sdan);
endproperty
assert property (p_slave_driving)
	else $error("PROTOCOL ERROR: SDA is not driven by the slave");

endmodule
