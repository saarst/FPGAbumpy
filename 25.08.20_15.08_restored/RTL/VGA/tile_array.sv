module	tile_array	(	
					input		logic	clk,
					input		logic	resetN,

		//			input 	logic signed	[10:0] topLeftX, //randomized Xarray
		//			input 	logic	signed [10:0] topLeftY,    //randomized Yarray
					input 	logic	[2:0] Xnum,
					input 	logic	[2:0] Ynum,
					output   logic [1:0] Tile_Type
			);		
bit [0:5] [0:7] [0:1] tile_bitmap  = {


{2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b00,2'b00}
 };
 
 
 
 assign Tile_Type = tile_bitmap [Ynum] [Xnum] ; 
 
 endmodule