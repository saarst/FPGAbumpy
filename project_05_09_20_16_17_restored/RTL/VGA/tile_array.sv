module	tile_array	(	
					input		logic	clk,
					input 	logic resetN,
					input 	logic [1:0] information,
					input 	logic writeEn,
		//			input 	logic [2:0] TargetX,
		//			input 	logic [2:0] TargetY,
		//			input 	logic signed	[10:0] topLeftX, //randomized Xarray
		//			input 	logic	signed [10:0] topLeftY,    //randomized Yarray
					input 	logic	[2:0] Xnum,
					input 	logic	[2:0] Ynum,
					input 	logic EndGame,
					output   logic [1:0] Tile_Type,
					output 	logic gift_clear
			);		
			
///////////////////////////DefaultMapS//////////////////////////////////////////			
localparam bit [0:5] [0:7] [0:1] map0  = {


{2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b01,2'b01,2'b01,2'b01,2'b10,2'b00,
 2'b01,2'b01,2'b01,2'b01,2'b01,2'b10,2'b00,2'b00}
 };
 
 localparam bit [0:5] [0:7] [0:1] map1  = {


{2'b00,2'b01,2'b00,2'b10,2'b01,2'b00,2'b01,2'b00,
 2'b00,2'b01,2'b00,2'b01,2'b10,2'b00,2'b01,2'b00,
 2'b00,2'b10,2'b00,2'b01,2'b01,2'b00,2'b10,2'b00,
 2'b00,2'b01,2'b00,2'b01,2'b10,2'b00,2'b01,2'b00,
 2'b00,2'b01,2'b00,2'b10,2'b01,2'b00,2'b01,2'b00,
 2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b01,2'b00}
 };
 
 localparam bit [0:5] [0:7] [0:1] map2  = {


{2'b01,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b10,2'b00,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b10,2'b00,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b00,2'b10,2'b00,2'b00,2'b00,2'b00,
 2'b00,2'b00,2'b01,2'b01,2'b10,2'b01,2'b00,2'b00,
 2'b01,2'b10,2'b10,2'b10,2'b10,2'b10,2'b10,2'b01}
 };
 
 bit [0:5] [0:7] [0:1] tile_bitmap;
 ///////////////////////RandomMachine////////////////////////////////////////////////
 logic [1:0] nxtMap;
 random randomNxtMap (.clk(clk),
					 .resetN(resetN),
					 .rise(EndGame),
					 .dout(nxtMap)
					 );
 ////////////////////////////WriteToMemory///////////////////////////////////////////
 
 
 
 always_ff@(posedge clk or negedge resetN )
 begin 
	if (!resetN) 
		tile_bitmap <= map0 ;
 
	else if (EndGame) begin
	case (nxtMap) 
		2'b00:	tile_bitmap <= map0 ;
		2'b01:	tile_bitmap <= map1 ;
		2'b10:	tile_bitmap <= map2 ;
	default : 	tile_bitmap <= map0 ;
	endcase
	end

	else if (writeEn) tile_bitmap [Ynum] [Xnum]  <= information;
	else if (gift_clear) tile_bitmap [5] [0]  <= 2'b11;
end



///////gift_clear check//////////////////////////////////////////////////////
 logic [2:0] counterX,counterY;
 logic No_Gift;
 
 always_ff@(posedge clk or negedge resetN) begin
 
	if (!resetN) begin
		counterX <= 0;
		counterY <= 0;
		No_Gift <=1;
		gift_clear <= 1'b0;
	end
	
	else if (EndGame) begin
		counterX <= 0;
		counterY <= 0;
		No_Gift <=1;
		gift_clear <= 1'b0;
	end
 
	
	else	if ( (counterX == 7) && (counterY == 5) && No_Gift )
			gift_clear <= 1'b1;

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
////////////////////////////ReadFromMemory///////////////////////////////////////////////////	
	
	
 
 assign Tile_Type = tile_bitmap [Ynum] [Xnum] ; 
 
 endmodule