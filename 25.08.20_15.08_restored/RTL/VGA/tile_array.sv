module	tile_array	(	
					input		logic	clk,
					input 	logic resetN,
					input 	logic StartOfFrame,
					input 	logic [1:0] information,
					input 	logic writeEn,
					input 	logic [2:0] TargetX,
					input 	logic [2:0] TargetY,
		//			input 	logic signed	[10:0] topLeftX, //randomized Xarray
		//			input 	logic	signed [10:0] topLeftY,    //randomized Yarray
					input 	logic	[2:0] Xnum,
					input 	logic	[2:0] Ynum,
					output   logic [1:0] Tile_Type,
					output 	logic gift_clear
			);		
bit [0:5] [0:7] [0:1] tile_bitmap  = {


{2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b01,2'b01,2'b01,2'b01,2'b11,2'b00,
 2'b01,2'b01,2'b01,2'b01,2'b01,2'b10,2'b00,2'b00}
 };
 
 always_ff@(posedge clk)
 begin 
	if (writeEn) tile_bitmap [TargetY] [TargetX]  <= information;
end
 //gift_clear check//
 logic [2:0] counterX,counterY;
 logic No_Gift;
 
 always_ff@(posedge clk or negedge resetN) begin
 
 if (!resetN) begin
	counterX <= 0;
	counterY <= 0;
	No_Gift <=1;
	gift_clear <= 1'b0;
 end
 
	else if (StartOfFrame) begin
		if ( (counterX == 7) && (counterY == 5) && No_Gift )
			gift_clear <= 1'b1;
	end
	else if  (((counterX == 7) && (counterY == 5) && (!No_Gift))) begin
		No_Gift <=1;
		counterX <= 0;
		counterY <= 0;
	end
	
	else if (counterX ==7) begin
	counterX <= 0;
	counterY <= counterY +1;
	No_Gift <= (No_Gift) && (tile_bitmap[counterY][counterX] != 2'b10) ;
	end
	
	else begin
	No_Gift <= (No_Gift) && (tile_bitmap[counterY][counterX] != 2'b10) ;
	counterX <= counterX +1;
	end
end
////////////////////////////	
	
	
 
 assign Tile_Type = tile_bitmap [Ynum] [Xnum] ; 
 
 endmodule