package i2c_pkg;

	typedef enum bit [3:0] {

		idle =0,
		start = 1,
		send_addr = 2,
		get_ack1 = 3,
		send_data = 4,
		get_ack2 = 5,
 		read_data = 6,
		complete = 7,
		get_addr = 8,
		send_ack1 = 9,
		get_data = 10,
		send_ack2 = 11
	} state_type;
endpackage
