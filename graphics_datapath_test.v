module graphics_datapath_test(
		CLOCK_50,
		KEY,
		SW,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		LEDR,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]);
	);
	reg [63:0] asteroid_x;
	reg [55:0] asteroid_y;
	reg [7:0] draw_asteroid;
	wire [7:0] curr_x;
	wire [6:0] curr_y;
	wire [7:0] start_x;
	wire [6:0] start_y;
	
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [9:0] LEDR;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	//assign asteroid_x[63:0] = 64'd0;
	//assign asteroid_y[55:0] = 56'd0;	
	//assign draw_asteroid[7:0] = 8'b00000000;
	// TEST 1
	// assign asteroid_x[63:16] = 48'd0;
	// assign asteroid_y[55:14] = 42'd0;
	// assign asteroid_x[15:0] = 16'b000000000000000;
	// assign asteroid_y[13:0] = 14'b0000000000000;
	// assign draw_asteroid[7:0] = 8'b00000001;
	//COMPLETE STARTING
	// assign asteroid_x[63:0] = 64'b0001010000010100000101000100111101001111100010111000101110001011;
	// assign asteroid_y[55:0] = 56'b00000000111011111011100000001110111000000001110111110111;
	// assign draw_asteroid[7:0] = 8'b11111111;
	reg [23:0] time_counter;
	
	always @ (posedge CLOCK_50, negedge resetn)
		begin
			if (!resetn) begin
				asteroid_x[63:16] <= 48'd0;
				asteroid_y[55:14] <= 42'd0;
				asteroid_x[15:0] <= 16'b0001101100000001;
				asteroid_y[13:0] <= 14'b00011110000001;
				draw_asteroid[7:0] <= 8'b00000011;
				// asteroid_x[63:0] <= 64'b0001010000010100000101000100111101001111100010111000101110001011;
				// asteroid_y[55:0] <= 56'b00000000111011111011100000001110111000000001110111110111;
				// draw_asteroid[7:0] <= 8'b11111111;
				// asteroid_x[63:0] = 64'd0;
				// asteroid_y[55:0] = 56'd0;	
				// draw_asteroid[7:0] = 8'b00000000;
				time_counter <= 24'd12500000; 
			end
			else begin
				time_counter <= time_counter == 24'd0 ? 24'd12500000 : time_counter - 1;
				if((time_counter == 24'd0) && SW[9]) begin
					asteroid_x[7:0] <= asteroid_x[7:0] + 8'd1;
					asteroid_y[6:0] <= asteroid_y[6:0] + 8'd1;
				end
			end
		end
	
	wire enable, done_draw;
	wire [2:0] calc, state;
	assign LEDR[2:0] = state;
	wire [2:0] asteroid_counter;
	datapath d(
		.colour(3'b000),
		.clock(CLOCK_50),
		.resetn(resetn),
		.enable(enable),
		.calc(calc),
		.asteroid_x(asteroid_x),
		.asteroid_y(asteroid_y),
		.draw_asteroid(draw_asteroid),
		.direction(SW[3:0]),
		.curr_x(x),
		.curr_y(y),
		.start_x(start_x),
		.start_y(start_y),
		.asteroid_counter(asteroid_counter),
		.c(colour),
		.done_draw(done_draw)
	);
	
	control c(
		.clk(CLOCK_50), 
		.resetn(resetn), 
		.enable(enable), 
		.plot(writeEn), 
		.done_draw(done_draw),
		.calc(calc),
		.state(state)
	);
	
	hex x1(HEX0, asteroid_x[3:0]);
	hex x2(HEX1, asteroid_x[7:4]);
	hex y1(HEX2, asteroid_y[3:0]);
	hex y2(HEX3, {1'b0, asteroid_y[6:4]});
	hex roid(HEX4, {2'b000, asteroid_counter[2:0]});
endmodule

module datapath(
	input [2:0] colour,
	input clock,
	input resetn,
	input enable,
	input [2:0] calc,
	input [63:0] asteroid_x,
	input [55:0] asteroid_y,
	input [7:0] draw_asteroid,
	input [3:0] direction,
	output [7:0] curr_x,
	output [6:0] curr_y,
	output [7:0] start_x,
	output [6:0] start_y,
	output reg [2:0] asteroid_counter,
	output reg [2:0] c,
	output reg done_draw
);
	reg [7:0] x_counter;
	reg [6:0] y_counter;
	reg [7:0] x;
	reg [6:0] y;
	reg [0:0] loaded;
	reg [1:0] prev_calc;
	//reg [2:0] asteroid_counter;
	
	assign start_x = x;
	assign start_y = y;
	
	always @(posedge clock) begin: colour_load
		if (!resetn) begin
			x <= 8'b00010100;
			y <= 7'b0000000;
			c <= colour;
			done_draw <= 1'b0;
			loaded <= 1'b0;
			asteroid_counter <= 3'b000;
			prev_calc <= 3'b100;
			x_counter <= 8'd0;
			y_counter <= 7'd0;
		end
		if (enable && loaded == 1'b0) begin
				x_counter <= 8'd0;
				y_counter <= 7'd0;
				done_draw <= 1'd0;
		end
		else if (enable && calc == 3'b000) begin
			x_counter <= x_counter + 1;
			if (x_counter == 8'd120) begin
				y_counter <= y_counter + 1;
				if (y_counter == 8'd120) begin
					y_counter <= 7'd0;
				end
				x_counter <= 8'd0;
			end
		end
		else if (enable) begin
			x_counter <= x_counter + 1;
			if (x_counter == 8'd5) begin
				y_counter <= y_counter + 1;
				if (y_counter == 7'd5)
					y_counter <= 7'd0;
				x_counter <= 8'd0;
			end
		end
		
		if(loaded == 1'b0) begin
			if(calc == prev_calc && calc != 3'b010) begin
				done_draw <= 1'b1;
			end
			else if (calc == 3'b000) begin
				x <= 8'b00010100;
				y <= 7'b0000000;
				c <= 3'b110;
				loaded <= 1'b1;
				prev_calc <= 3'b000;
			end
			else if (calc == 3'b001) begin
				x <= 8'd79;
				y <= 7'd59;
				c <= colour;
				loaded <= 1'b1;
				prev_calc <= 3'b001;
			end
			else if (calc == 3'b010) begin
				prev_calc <= 3'b010;
				x <= 8'd159;
				y <= 7'd119;
				if (draw_asteroid[asteroid_counter] == 1'b0 && asteroid_counter != 3'b111) begin
					asteroid_counter <= asteroid_counter == 3'd7 ? 3'd0 : asteroid_counter + 3'b001;
				end
				else if (asteroid_counter == 3'b000 && draw_asteroid[0] == 1'b1) begin
					x <= asteroid_x[7:0] - 8'b00000010;
					y <= asteroid_y[6:0] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b001 && draw_asteroid[1] == 1'b1) begin
					x <= asteroid_x[15:8] - 8'b00000010;
					y <= asteroid_y[13:7] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b010 && draw_asteroid[2] == 1'b1) begin
					x <= asteroid_x[23:16] - 8'b00000010;
					y <= asteroid_y[20:14] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b011 && draw_asteroid[3] == 1'b1) begin
					x <= asteroid_x[31:24] - 8'b00000010;
					y <= asteroid_y[27:21] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b100 && draw_asteroid[4] == 1'b1) begin
					x <= asteroid_x[39:32] - 8'b00000010;
					y <= asteroid_y[34:28] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b101 && draw_asteroid[5] == 1'b1) begin
					x <= asteroid_x[47:40] - 8'b00000010;
					y <= asteroid_y[41:35] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b110 && draw_asteroid[6] == 1'b1) begin
					x <= asteroid_x[55:48] - 8'b00000010;
					y <= asteroid_y[48:42] - 7'b0000010;
					loaded <= 1'b1;
				end
				else if (asteroid_counter == 3'b111 && draw_asteroid[7] == 1'b1) begin
					x <= asteroid_x[63:56] - 8'b00000010;
					y <= asteroid_y[55:49] - 7'b0000010;
					loaded <= 1'b1;
				end
				else begin
					asteroid_counter <= 3'b000;
					done_draw <= 1'b1;
				end
				
			end
		end
		else begin
			if(calc == 3'b000) begin
				c <= 3'b110;
				if (y_counter == 7'd119 && x_counter == 8'd119) begin
					loaded <= 1'b0;
					done_draw <= 1'b1;
				end
			end
			else if(calc == 3'b001) begin
				if (x_counter == 8'd4 && y_counter == 8'd4) begin
					loaded <= 1'b0;
					done_draw <= 1'b1;
				end
				else if (direction == 4'b0001) begin
					if ((x_counter == 8'd2 && y_counter == 7'd1) || 
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd2) || 
						((x_counter == 8'd1 || x_counter == 8'd3) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b0101) begin
					if (((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd1)|| 
						((x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd2) || 
						(x_counter == 8'd3 && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b0100) begin
					if (((x_counter == 8'd1 || x_counter == 8'd2) && y_counter == 7'd1)|| 
						((x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd2) || 
						((x_counter == 8'd1 || x_counter == 8'd2) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b0110) begin
					if ((x_counter == 8'd3 && y_counter == 7'd1)|| 
						((x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd2) || 
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b0010) begin
					if (((x_counter == 8'd1 || x_counter == 8'd3) && y_counter == 7'd1)|| 
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd2) || 
						(x_counter == 8'd2 && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b1010) begin
					if ((x_counter == 8'd1 && y_counter == 7'd1)|| 
						((x_counter == 8'd1 || x_counter == 8'd2) && y_counter == 7'd2) || 
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b1000) begin
					if (((x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd1)|| 
						((x_counter == 8'd1 || x_counter == 8'd2) && y_counter == 7'd2) || 
						((x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
				else if (direction == 4'b1001) begin
					if (((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd1)|| 
						((x_counter == 8'd1 || x_counter == 8'd2) && y_counter == 7'd2) || 
						((x_counter == 8'd1) && y_counter == 7'd3))
						c <= colour;
					else
						c <= ~colour;
				end
			end
			else if(calc == 3'b010) begin
				if ((x_counter == 8'd4 && y_counter == 7'd4) || draw_asteroid[asteroid_counter] == 1'b0) begin
					loaded <= 1'b0;
					if (asteroid_counter == 3'b111) begin
						asteroid_counter <= 3'b000;
						done_draw <= 1'b1;
					end
					else begin
						asteroid_counter <= asteroid_counter + 3'b001;
					end
				end
				else begin
					if ((x_counter == 8'd2 && y_counter == 7'd0)|| 
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd1) || 
						((x_counter == 8'd0 || x_counter == 8'd1 || x_counter == 8'd3 || x_counter == 8'd4) && y_counter == 7'd2) ||
						((x_counter == 8'd1 || x_counter == 8'd2 || x_counter == 8'd3) && y_counter == 7'd3) ||
						(x_counter == 8'd2 && y_counter == 7'd4))
						c <= colour;
					else
						c <= ~colour;
				end
			end
		end
	end
	
	assign curr_x = x + x_counter;
	assign curr_y = y + y_counter;
endmodule

module control(clk, resetn, enable, plot, done_draw, calc, state);
	input clk, resetn, done_draw;
	output [2:0] state;
	output reg plot, enable;
	output reg [1:0] calc;
	reg [2:0] current_state, next_state;
	reg [25:0] counter;
	reg go;
	assign state = current_state == 3'b000 ? 3'b111: current_state;

	localparam		ERASE = 3'b000,
				CALC_SHIP = 3'b001,
				CALC_ASTEROID = 3'b010,
				CALC_BULLET = 3'b011,
				IDLE = 3'b100,
				ERASE_DELAY = 3'b101;
	
	always @ (*)
		begin: state_table
			case(current_state)
				ERASE: next_state = done_draw && go ? CALC_SHIP : ERASE;
				ERASE_DELAY: next_state = go ? CALC_SHIP: ERASE_DELAY;
				CALC_SHIP: next_state = done_draw && go ? CALC_ASTEROID : CALC_SHIP;
				CALC_ASTEROID: next_state = done_draw && go ? IDLE : CALC_ASTEROID; //TODO: Add CALC_BULLET
				IDLE: next_state = go ? ERASE : IDLE;
			default: next_state = ERASE;
			endcase
		end

	always @ (*)
		begin: enable_signals
		enable = 1'b0;
		plot = 1'b1;
		calc = 3'b100;
		case (current_state)
			ERASE: begin
				enable = 1'b1;
				calc = 3'b000;
			end
			CALC_SHIP: begin
				enable = 1'b1;
				calc = 3'b001;
			end
			CALC_ASTEROID: begin
				enable = 1'b1;
				calc = 3'b010;
				end
			CALC_BULLET: begin
				enable = 1'b1;
				calc = 3'b011;
				end
			IDLE: begin
				plot = 1'b0;
				end
			endcase
		end

	always @ (posedge clk)
		begin: state_FFS
		if(!resetn)
			current_state <= ERASE;
		else
			current_state <= next_state;
		end

	always @ (posedge clk)
		begin: FPS_counter
			if(!resetn) begin
				counter <= 26'd19999;
			end
			else begin
				counter <= counter - 26'd1;
				if(counter == 26'd0) begin
					if (current_state == ERASE) begin
						counter <= 26'd99;
					end
					else if(current_state == CALC_SHIP) begin
						counter <= 26'd1999;
					end
					else if(current_state == CALC_ASTEROID) begin
						counter <= 26'd899999;
					end
					else begin
						counter <= 26'd19999;
					end
					// if (current_state == ERASE) begin
						// counter <= 26'd49999999;
					// end
					// else if(current_state == ERASE_DELAY) begin
						// counter <= 26'd99;
					// end
					// else if(current_state == CALC_SHIP) begin
						// counter <= 26'd1999;
					// end
					// else if(current_state == CALC_ASTEROID) begin
						// counter <= 26'd899999;
					// end
					// else begin
						// counter <= 26'd19999;
					// end
					go <= 1'b1;
				end
				else 
					go <= 1'b0;
			end
		end
endmodule

module hex(HEX0, SW);
    input [3:0] SW;
    output [6:0] HEX0;
	
	assign HEX0[0] = ~SW[3] & SW[2] & ~SW[1] & ~SW[0] |
			  		 ~SW[3] & ~SW[2] & ~SW[1] & SW[0] |
			  		 SW[3] & SW[2] & ~SW[1] & SW[0] |
			  		 SW[3] & ~SW[2] & SW[1] & SW[0];
	
	assign HEX0[1] = ~SW[3] & SW[2] & ~SW[1] & SW[0] |
			  		 SW[3] & & SW[1] & SW[0] |
			  		 SW[3] & SW[2] & ~SW[0] |
			  		 SW[2] & SW[1] & ~SW[0];
	
	assign HEX0[2] = ~SW[3] & ~SW[2] & SW[1] & ~SW[0] |
				     SW[3] & SW[2] & ~SW[0] |
				     SW[3] & SW[2] & SW[1];

	assign HEX0[3] = ~SW[2] & ~SW[1] & SW[0] |
				     SW[2] & SW[1] & SW[0] |
				     SW[3] & ~SW[2] & SW[1] & ~SW[0] |
				     ~SW[3] & SW[2] & ~SW[1] & ~SW[0];

	assign HEX0[4] = ~SW[3] & SW[0] |
				     ~SW[2] & ~SW[1] & SW[0] |
				     ~SW[3] & SW[2] & ~SW[1];

	assign HEX0[5] = ~SW[3] & ~SW[2] & SW[0] |
				     ~SW[3] & ~SW[2] & SW[1] |
				     ~SW[3] & SW[1] & SW[0] |
				     SW[3] & SW[2] & ~SW[1] & SW[0];

	assign HEX0[6] = ~SW[3] & ~SW[2] & ~SW[1] |
			   	     SW[3] & SW[2] & ~SW[1] & ~SW[0] |
				     ~SW[3] & SW[2] & SW[1] & SW[0];
endmodule