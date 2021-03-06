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
	reg [63:0] bullet_x;
	reg [55:0] bullet_y;
	reg [7:0] draw_bullet;
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
				// asteroid_x[63:16] <= 48'd0;
				// asteroid_y[55:14] <= 42'b0;
				// asteroid_x[15:0] <= 16'b0001101100000001;
				// asteroid_y[13:0] <= 14'b00011110000001;
				// draw_asteroid[7:0] <= 8'b00000011;
				asteroid_x[63:0] <= 64'b0000101000010100000111100010100000110010001111000100011001010000;
				asteroid_y[55:0] <= 56'b00000000000000000000000000000000000000000000000000000000;
				draw_asteroid[7:0] <= 8'b11111111;
				bullet_x[63:8] <= 56'd0;
				bullet_y[55:7] <= 49'd0;
				bullet_x[7:0] <= 8'b00000000;
				bullet_y[6:0] <= 7'b0000000;
				draw_bullet[7:0] <= 8'b00000000;
				time_counter <= 24'd12500000; 
			end
			else begin
				time_counter <= time_counter == 24'd0 ? 24'd12500000 : time_counter - 1;
				if((time_counter == 24'd0) && SW[9]) begin
					asteroid_x[7:0] <= asteroid_x[7:0] + 8'd1;
					asteroid_y[6:0] <= asteroid_y[6:0] + 8'd1;
					asteroid_x[15:8] <= asteroid_x[15:8] + 8'd1;
					asteroid_y[13:7] <= asteroid_y[13:7] + 8'd1;
					asteroid_x[23:16] <= asteroid_x[23:16] + 8'd1;
					asteroid_y[20:14] <= asteroid_y[20:14] + 8'd1;
					asteroid_x[31:24] <= asteroid_x[31:24] + 8'd1;
					asteroid_y[27:21] <= asteroid_y[27:21] + 8'd1;
					asteroid_x[39:32] <= asteroid_x[39:32] + 8'd1;
					asteroid_y[34:28] <= asteroid_y[34:28] + 8'd1;
					asteroid_x[47:40] <= asteroid_x[47:40] + 8'd1;
					asteroid_y[41:35] <= asteroid_y[41:35] + 8'd1;
					asteroid_x[55:48] <= asteroid_x[55:48] + 8'd1;
					asteroid_y[48:42] <= asteroid_y[48:42] + 8'd1;
					asteroid_x[63:56] <= asteroid_x[63:56] + 8'd1;
					asteroid_y[55:49] <= asteroid_y[55:49] + 8'd1;
					bullet_x[7:0] <= bullet_x[7:0] + 8'd1;
					bullet_y[6:0] <= bullet_y[6:0] + 8'd1;
				end
			end
		end
	
	wire enable, done_draw, enter_signal, death;
	wire [2:0] calc;
	wire [3:0] state;
	assign LEDR[3:0] = state;
	wire [2:0] asteroid_counter;
	assign enter_signal = ~KEY[1];
	assign death = ~KEY[2];
	
	datapath d(
		.colour(3'b000),
		.clock(CLOCK_50),
		.resetn(resetn),
		.enable(enable),
		.calc(calc),
		.asteroid_x(asteroid_x),
		.asteroid_y(asteroid_y),
		.draw_asteroid(draw_asteroid),
		.bullet_x(bullet_x),
		.bullet_y(bullet_y),
		.draw_bullet(draw_bullet),
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
		.state(state),
		.enter_signal(enter_signal),
		.death(death)
	);
	
	hex x1(HEX0, asteroid_x[3:0]);
	hex x2(HEX1, asteroid_x[7:4]);
	hex y1(HEX2, asteroid_y[3:0]);
	hex y2(HEX3, {1'b0, asteroid_y[6:4]});
	hex roid(HEX4, {1'b0, asteroid_counter[2:0]});
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
	input [63:0] bullet_x,
	input [55:0] bullet_y,
	input [7:0] draw_bullet,
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
	reg [2:0] prev_calc;
	//reg [2:0] asteroid_counter;
	reg [2:0] bullet_counter;
	
	assign start_x = x;
	assign start_y = y;
	
	always @(posedge clock) begin: colour_load
		if (!resetn) begin
			x <= 8'b00000000;
			y <= 7'b0000000;
			c <= colour;
			done_draw <= 1'b0;
			loaded <= 1'b0;
			asteroid_counter <= 3'b000;
			bullet_counter <= 3'b000;
			prev_calc <= 3'b110;
			x_counter <= 8'd0;
			y_counter <= 7'd0;
		end
		if (enable && loaded == 1'b0) begin
				x_counter <= 8'd0;
				y_counter <= 7'd0;
				done_draw <= 1'd0;
		end
		else if (enable && (calc == 3'b000 || calc == 3'b100 || calc == 3'b101)) begin
			x_counter <= x_counter + 1;
			if (x_counter == 8'd160) begin
				y_counter <= y_counter + 1;
				if (y_counter == 8'd160) begin
					y_counter <= 7'd0;
				end
				x_counter <= 8'd0;
			end
		end
		else if (enable && calc != 3'b011) begin
			x_counter <= x_counter + 1;
			if (x_counter == 8'd5) begin
				y_counter <= y_counter + 1;
				if (y_counter == 7'd5)
					y_counter <= 7'd0;
				x_counter <= 8'd0;
			end
		end
		
		if(loaded == 1'b0) begin
			if(calc == prev_calc && calc != 3'b010 && calc != 3'b011) begin
				done_draw <= 1'b1;
			end
			else if (calc == 3'b000 || calc == 3'b100 || calc == 3'b101) begin
				x <= 8'b00000000;
				y <= 7'b0000000;
				c <= ~colour;
				loaded <= 1'b1;
				prev_calc <= calc;
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
			else if (calc == 3'b011) begin
				prev_calc <= 3'b011;
				x <= 8'd159;
				y <= 7'd119;
				if (draw_bullet[bullet_counter] == 1'b0 && bullet_counter != 3'b111) begin
					bullet_counter <= bullet_counter == 3'd7 ? 3'd0 : bullet_counter + 3'b001;
				end
				else if (bullet_counter == 3'b000 && draw_bullet[0] == 1'b1) begin
					x <= bullet_x[7:0];
					y <= bullet_y[6:0];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b001 && draw_bullet[1] == 1'b1) begin
					x <= bullet_x[15:8];
					y <= bullet_y[13:7];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b010 && draw_bullet[2] == 1'b1) begin
					x <= bullet_x[23:16];
					y <= bullet_y[20:14];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b011 && draw_bullet[3] == 1'b1) begin
					x <= bullet_x[31:24];
					y <= bullet_y[27:21];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b100 && draw_bullet[4] == 1'b1) begin
					x <= bullet_x[39:32];
					y <= bullet_y[34:28];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b101 && draw_bullet[5] == 1'b1) begin
					x <= bullet_x[47:40];
					y <= bullet_y[41:35];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b110 && draw_bullet[6] == 1'b1) begin
					x <= bullet_x[55:48];
					y <= bullet_y[48:42];
					loaded <= 1'b1;
				end
				else if (bullet_counter == 3'b111 && draw_bullet[7] == 1'b1) begin
					x <= bullet_x[63:56];
					y <= bullet_y[55:49];
					loaded <= 1'b1;
				end
				else begin
					bullet_counter <= 3'b000;
					done_draw <= 1'b1;
				end
			end
		end
		else begin
			if(calc == 3'b000) begin
				c <= ~colour;
				if (y_counter == 7'd119 && x_counter == 8'd159) begin
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
			else if(calc == 3'b011) begin
				loaded <= 1'b0;
				c <= draw_bullet[bullet_counter] == 1'b1 ? colour : ~colour;
				if (bullet_counter == 3'b111) begin
					bullet_counter <= 3'b000;
					done_draw <= 1'b1;
				end
				else begin
					bullet_counter <= bullet_counter + 3'b001;
				end
			end
			else if(calc == 3'b100) begin
				if (y_counter == 7'd119 && x_counter == 8'd159) begin
					c <= ~colour;
					loaded <= 1'b0;
					done_draw <= 1'b1;
				end
				else if(((y_counter >= 7'd18 && y_counter <= 7'd35) || (y_counter >= 7'd77 && y_counter <= 7'd84)) && x_counter >= 8'd19 && x_counter <= 8'd142) begin
					if(y_counter >= 7'd18 && y_counter <= 7'd20) begin
						if((x_counter >= 8'd19 && x_counter <= 8'd30) || 
						   (x_counter >= 8'd33 && x_counter <= 8'd44) || 
						   (x_counter >= 8'd47 && x_counter <= 8'd58) || 
						   (x_counter >= 8'd61 && x_counter <= 8'd72) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd86) || 
						   (x_counter >= 8'd89 && x_counter <= 8'd100) || 
						   (x_counter >= 8'd103 && x_counter <= 8'd114) || 
						   (x_counter >= 8'd117 && x_counter <= 8'd128) || 
						   (x_counter >= 8'd131 && x_counter <= 8'd142)) begin
							if(y_counter == 7'd18 && (x_counter == 8'd127 || x_counter == 8'd128) || y_counter == 7'd19 && x_counter == 8'd128)
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if(y_counter >= 7'd21 && y_counter <= 7'd24) begin
						if((x_counter >= 8'd19 && x_counter <= 8'd21) || 
						   (x_counter >= 8'd28 && x_counter <= 8'd30) || 
						   (x_counter >= 8'd33 && x_counter <= 8'd35) || 
						   (x_counter >= 8'd51 && x_counter <= 8'd54) || 
						   (x_counter >= 8'd61 && x_counter <= 8'd63) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd77) || 
						   (x_counter >= 8'd84 && x_counter <= 8'd86) || 
						   (x_counter >= 8'd89 && x_counter <= 8'd91) ||
						   (x_counter >= 8'd98 && x_counter <= 8'd100) ||
						   (x_counter >= 8'd107 && x_counter <= 8'd110) ||
						   (x_counter >= 8'd117 && x_counter <= 8'd119) ||
						   (x_counter >= 8'd126 && x_counter <= 8'd128) ||
						   (x_counter >= 8'd131 && x_counter <= 8'd133))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter >= 7'd25 && y_counter <= 7'd28) begin
						if((x_counter >= 8'd19 && x_counter <= 8'd30) || 
						   (x_counter >= 8'd33 && x_counter <= 8'd44) || 
						   (x_counter >= 8'd51 && x_counter <= 8'd54) ||
						   (x_counter >= 8'd61 && x_counter <= 8'd72) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd85) ||
						   (x_counter >= 8'd89 && x_counter <= 8'd91) ||
						   (x_counter >= 8'd98 && x_counter <= 8'd100) ||
						   (x_counter >= 8'd107 && x_counter <= 8'd110) ||
						   (x_counter >= 8'd117 && x_counter <= 8'd119) ||
						   (x_counter >= 8'd126 && x_counter <= 8'd128) ||
						   (x_counter >= 8'd131 && x_counter <= 8'd142)) begin
							if((y_counter == 7'd26 || y_counter == 7'd27) && x_counter == 8'd85)
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if(y_counter >= 7'd29 && y_counter <= 7'd32) begin
						if((x_counter >= 8'd19 && x_counter <= 8'd21) || 
						   (x_counter >= 8'd28 && x_counter <= 8'd30) || 
						   (x_counter >= 8'd42 && x_counter <= 8'd44) || 
						   (x_counter >= 8'd51 && x_counter <= 8'd54) || 
						   (x_counter >= 8'd61 && x_counter <= 8'd63) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd77) || 
						   (x_counter >= 8'd84 && x_counter <= 8'd86) || 
						   (x_counter >= 8'd89 && x_counter <= 8'd91) || 
						   (x_counter >= 8'd98 && x_counter <= 8'd100) ||
						   (x_counter >= 8'd107 && x_counter <= 8'd110) ||
						   (x_counter >= 8'd117 && x_counter <= 8'd119) ||
						   (x_counter >= 8'd126 && x_counter <= 8'd128) ||
						   (x_counter >= 8'd140 && x_counter <= 8'd142))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter >= 7'd33 && y_counter <= 7'd35) begin
						if((x_counter >= 8'd19 && x_counter <= 8'd21) || 
						   (x_counter >= 8'd28 && x_counter <= 8'd30) || 
						   (x_counter >= 8'd33 && x_counter <= 8'd44) || 
						   (x_counter >= 8'd51 && x_counter <= 8'd54) || 
						   (x_counter >= 8'd61 && x_counter <= 8'd72) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd77) || 
						   (x_counter >= 8'd84 && x_counter <= 8'd86) || 
						   (x_counter >= 8'd89 && x_counter <= 8'd100) || 
						   (x_counter >= 8'd103 && x_counter <= 8'd114) || 
						   (x_counter >= 8'd117 && x_counter <= 8'd128) || 
						   (x_counter >= 8'd131 && x_counter <= 8'd142)) begin
							if(y_counter == 7'd35 && (x_counter == 8'd127 || x_counter == 8'd128) || y_counter == 7'd34 && x_counter == 8'd128)
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd77) begin
						if((x_counter >= 8'd38 && x_counter <= 8'd43) || 
						   (x_counter >= 8'd46 && x_counter <= 8'd50) || 
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || 
						   (x_counter >= 8'd94 && x_counter <= 8'd99) || 
						   (x_counter >= 8'd102 && x_counter <= 8'd107) || 
						   (x_counter >= 8'd110 && x_counter <= 8'd115) || 
						   (x_counter >= 8'd118 && x_counter <= 8'd122))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd78 || y_counter == 7'd79) begin
						if((x_counter == 8'd38) || (x_counter == 8'd43) || (x_counter == 8'd46) || 
						   (x_counter == 8'd51) || (x_counter == 8'd54) || (x_counter == 8'd62) || 
						   (x_counter == 8'd70) || (x_counter == 8'd86) || (x_counter == 8'd94) || 
						   (x_counter == 8'd99) || (x_counter == 8'd104) || (x_counter == 8'd105) ||
						   (x_counter == 8'd110) || (x_counter == 8'd118) || (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd80 || y_counter == 7'd81) begin
						if((x_counter >= 8'd38 && x_counter <= 8'd43) || 
						   (x_counter >= 8'd46 && x_counter <= 8'd51) || 
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || 
						   (x_counter == 8'd94) || (x_counter == 8'd99) || (x_counter == 8'd104) || 
						   (x_counter == 8'd105) || (x_counter >= 8'd110 && x_counter <= 8'd115) || 
						   (x_counter >= 8'd118 && x_counter <= 8'd123)) begin
							if(y_counter == 7'd81 && (x_counter == 8'd51 || x_counter == 8'd123))
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd82 || y_counter == 7'd83) begin
						if((x_counter == 8'd38) || (x_counter == 8'd46) || (x_counter == 8'd51) ||
						   (x_counter == 8'd54) || (x_counter == 8'd67) || (x_counter == 8'd75) || 
						   (x_counter == 8'd86) || (x_counter == 8'd94) || (x_counter == 8'd99) || 
						   (x_counter == 8'd104) || (x_counter == 8'd105) || (x_counter == 8'd110) ||
						   (x_counter == 8'd118) || (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd84) begin
						if((x_counter == 8'd38) || (x_counter == 8'd46) || (x_counter == 8'd51) ||
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || (x_counter == 8'd94) || 
						   (x_counter == 8'd99) || (x_counter == 8'd104) || (x_counter == 8'd105) ||
						   (x_counter >= 8'd110 && x_counter <= 8'd115) || (x_counter == 8'd118) || 
						   (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else
						c <= ~colour;
				end
				else 
					c <= ~colour;
			end
			else if(calc == 3'b101) begin
				if (y_counter == 7'd119 && x_counter == 8'd159) begin
					c <= ~colour;
					loaded <= 1'b0;
					done_draw <= 1'b1;
				end
				else if(((y_counter >= 7'd36 && y_counter <= 7'd53) || (y_counter >= 7'd77 && y_counter <= 7'd84)) && x_counter >= 8'd38 && x_counter <= 8'd123) begin
					if(y_counter == 7'd36) begin
						if((x_counter >= 8'd66 && x_counter <= 8'd71) || 
						   (x_counter >= 8'd74 && x_counter <= 8'd79) || 
						   (x_counter == 8'd82) || (x_counter == 8'd87) || 
						   (x_counter >= 8'd90 && x_counter <= 8'd95))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter >= 7'd37 && y_counter <= 7'd39) begin
						if((x_counter == 8'd66) || (x_counter == 8'd74) || (x_counter == 8'd79) || 
						   (x_counter >= 8'd82 && x_counter <= 8'd87) || 
						   (x_counter >= 8'd90 && x_counter <= 8'd95)) begin
							if((y_counter == 7'd37 || y_counter == 7'd38) && 
							   (x_counter == 8'd84 || x_counter == 8'd85 || 
							   (x_counter >= 8'd91 && x_counter <= 8'd95)))
								c <= ~colour;
							else if(y_counter == 7'd39 && (x_counter == 8'd83 || x_counter == 8'd86))
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd40) begin
						if((x_counter >= 8'd66 && x_counter <= 8'd71) || 
						   (x_counter >= 8'd74 && x_counter <= 8'd79) ||
						   (x_counter >= 8'd82 && x_counter <= 8'd87) || 
						   (x_counter >= 8'd90 && x_counter <= 8'd95)) begin
							if(x_counter == 8'd67 || x_counter == 8'd68 || x_counter == 8'd83 || x_counter == 8'd86)
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd41 || y_counter == 7'd42) begin
						if((x_counter == 8'd66) || (x_counter == 8'd71) || (x_counter == 8'd74) || 
						   (x_counter == 8'd79) || (x_counter == 8'd82) || (x_counter == 8'd87) ||
						   (x_counter == 8'd90))
							c <= colour;
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd43) begin
						if((x_counter >= 8'd66 && x_counter <= 8'd71) ||
						   (x_counter == 8'd74) || (x_counter == 8'd79) || (x_counter == 8'd82) ||
						   (x_counter == 8'd87) || (x_counter >= 8'd90 && x_counter <= 8'd95))
							c <= colour;
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd46) begin
						if((x_counter >= 8'd66 && x_counter <= 8'd71) ||
						   (x_counter == 8'd74) || (x_counter == 8'd79) || 
						   (x_counter >= 8'd82 && x_counter <= 8'd87) || 
						   (x_counter >= 8'd90 && x_counter <= 8'd94))
							c <= colour;
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd47 || y_counter == 7'd48) begin
						if((x_counter == 8'd66) || (x_counter == 8'd71) || (x_counter == 8'd74) || 
						   (x_counter == 8'd79) || (x_counter == 8'd82) || (x_counter == 8'd90) ||
						   (x_counter == 8'd95))
							c <= colour;
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd49 || y_counter == 7'd50) begin
						if((x_counter == 8'd66) || (x_counter == 8'd71) || (x_counter == 8'd75) || 
						   (x_counter == 8'd78) || (x_counter >= 8'd82 && x_counter <= 8'd87) ||
						   (x_counter >= 8'd90 && x_counter <= 8'd95)) begin
							if(y_counter == 7'd50 && x_counter == 8'd95)
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd51 || y_counter == 7'd52) begin
						if((x_counter == 8'd66) || (x_counter == 8'd71) || 
						   (x_counter >= 8'd75 && x_counter <= 8'd78) ||
						   (x_counter == 8'd82) || (x_counter == 8'd90) || (x_counter == 8'd95)) begin
							if(y_counter == 7'd51 && (x_counter == 8'd76 || x_counter == 8'd77))
								c <= ~colour;
							else if(y_counter == 7'd52 && (x_counter == 8'd75 || x_counter == 8'd78))
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if (y_counter == 7'd53) begin
						if((x_counter >= 8'd66 && x_counter <= 8'd71) ||
						   (x_counter == 8'd76) || (x_counter == 8'd77) || 
						   (x_counter >= 8'd82 && x_counter <= 8'd87) ||
						   (x_counter == 8'd90) || (x_counter == 8'd95))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd77) begin
						if((x_counter >= 8'd38 && x_counter <= 8'd43) || 
						   (x_counter >= 8'd46 && x_counter <= 8'd50) || 
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || 
						   (x_counter >= 8'd94 && x_counter <= 8'd99) || 
						   (x_counter >= 8'd102 && x_counter <= 8'd107) || 
						   (x_counter >= 8'd110 && x_counter <= 8'd115) || 
						   (x_counter >= 8'd118 && x_counter <= 8'd122))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd78 || y_counter == 7'd79) begin
						if((x_counter == 8'd38) || (x_counter == 8'd43) || (x_counter == 8'd46) || 
						   (x_counter == 8'd51) || (x_counter == 8'd54) || (x_counter == 8'd62) || 
						   (x_counter == 8'd70) || (x_counter == 8'd86) || (x_counter == 8'd94) || 
						   (x_counter == 8'd99) || (x_counter == 8'd104) || (x_counter == 8'd105) ||
						   (x_counter == 8'd110) || (x_counter == 8'd118) || (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd80 || y_counter == 7'd81) begin
						if((x_counter >= 8'd38 && x_counter <= 8'd43) || 
						   (x_counter >= 8'd46 && x_counter <= 8'd51) || 
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || 
						   (x_counter == 8'd94) || (x_counter == 8'd99) || (x_counter == 8'd104) || 
						   (x_counter == 8'd105) || (x_counter >= 8'd110 && x_counter <= 8'd115) || 
						   (x_counter >= 8'd118 && x_counter <= 8'd123)) begin
							if(y_counter == 7'd81 && (x_counter == 8'd51 || x_counter == 8'd123))
								c <= ~colour;
							else
								c <= colour;
						end
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd82 || y_counter == 7'd83) begin
						if((x_counter == 8'd38) || (x_counter == 8'd46) || (x_counter == 8'd51) ||
						   (x_counter == 8'd54) || (x_counter == 8'd67) || (x_counter == 8'd75) || 
						   (x_counter == 8'd86) || (x_counter == 8'd94) || (x_counter == 8'd99) || 
						   (x_counter == 8'd104) || (x_counter == 8'd105) || (x_counter == 8'd110) ||
						   (x_counter == 8'd118) || (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else if(y_counter == 7'd84) begin
						if((x_counter == 8'd38) || (x_counter == 8'd46) || (x_counter == 8'd51) ||
						   (x_counter >= 8'd54 && x_counter <= 8'd59) || 
						   (x_counter >= 8'd62 && x_counter <= 8'd67) || 
						   (x_counter >= 8'd70 && x_counter <= 8'd75) || 
						   (x_counter >= 8'd86 && x_counter <= 8'd91) || (x_counter == 8'd94) || 
						   (x_counter == 8'd99) || (x_counter == 8'd104) || (x_counter == 8'd105) ||
						   (x_counter >= 8'd110 && x_counter <= 8'd115) || (x_counter == 8'd118) || 
						   (x_counter == 8'd123))
							c <= colour;
						else
							c <= ~colour;
					end
					else
						c <= ~colour;
				end
				else 
					c <= ~colour;
			end
		end
	end
	
	assign curr_x = x + x_counter;
	assign curr_y = y + y_counter;
endmodule

module control(clk, resetn, enable, plot, done_draw, calc, state, enter_signal, death);
	input clk, resetn, done_draw, enter_signal, death;
	output [3:0] state;
	output reg plot, enable;
	output reg [2:0] calc;
	reg [3:0] current_state, next_state;
	reg [25:0] counter;
	reg go;
	assign state = current_state;

	localparam	MENU = 4'b0000,
				MENU_WAIT = 4'b0001,
				ERASE = 4'b0010,
				CHECK_DEATH = 4'b0011,
				CALC_SHIP = 4'b0100,
				CALC_ASTEROID = 4'b0101,
				CALC_BULLET = 4'b0110,
				IDLE = 4'b0111,
				GAME_OVER = 4'b1000,
				GAME_OVER_WAIT = 4'b1001;
	
	always @ (*)
		begin: state_table
			case(current_state)
				MENU: next_state = done_draw && go ? MENU_WAIT : MENU;
				MENU_WAIT: next_state = enter_signal && go ? ERASE : MENU_WAIT;
				ERASE: next_state = done_draw && go ? CHECK_DEATH : ERASE;
				CHECK_DEATH: next_state = death ? GAME_OVER : CALC_SHIP;
				CALC_SHIP: next_state = done_draw && go ? CALC_ASTEROID : CALC_SHIP;
				CALC_ASTEROID: next_state = done_draw && go ? CALC_BULLET : CALC_ASTEROID; 
				CALC_BULLET: next_state = done_draw && go ? IDLE : CALC_BULLET;
				IDLE: next_state = go ? ERASE : IDLE;
				GAME_OVER: next_state = done_draw && go ? GAME_OVER_WAIT: GAME_OVER;
				GAME_OVER_WAIT: next_state = enter_signal && go ? MENU : GAME_OVER_WAIT;
			default: next_state = MENU;
			endcase
		end

	always @ (*)
		begin: enable_signals
		enable = 1'b0;
		plot = 1'b1;
		calc = 3'b110;
		case (current_state)
			MENU: begin
				enable = 1'b1;
				calc = 3'b100;
			end
			MENU_WAIT: begin
				plot = 1'b0;
			end
			ERASE: begin
				enable = 1'b1;
				calc = 3'b000;
			end
			CHECK_DEATH: begin
				plot = 1'b0;
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
			GAME_OVER: begin
				enable = 1'b1;
				calc = 3'b101;
			end
			GAME_OVER_WAIT: begin
				plot = 1'b0;
			end
			endcase
		end

	always @ (posedge clk)
		begin: state_FFS
		if(!resetn)
			current_state <= MENU;
		else
			current_state <= next_state;
		end

	always @ (posedge clk)
		begin: FPS_counter
			if(!resetn) begin
				counter <= 26'd21999;
			end
			else begin
				counter <= counter - 26'd1;
				if(counter == 26'd0) begin
					if (current_state == ERASE) begin
						counter <= 26'd100;
					end
					else if(current_state == CALC_SHIP) begin
						counter <= 26'd225;
					end
					else if(current_state == CALC_ASTEROID) begin
						counter <= 26'd50;
					end
					else if(current_state == CALC_BULLET) begin
						counter <= 26'd833334;
					end
					else if(current_state == MENU || current_state == GAME_OVER) begin
						counter <= 26'd12500000;
					end
					else begin
						counter <= 26'd21999;
					end
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