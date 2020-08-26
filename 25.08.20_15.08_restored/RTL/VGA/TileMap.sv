//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy February 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 



module	TileMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input logic [1:0]	 Tile_type, 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 6;  // 2^6 = 64 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

//Tile Types 
localparam  logic TILE_BACKGROUND = 2'b00
localparam  logic TILE_FLOOR = 2'b01
localparam  logic TILE_GIFT = 2'b10
// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam logic [7:0] FLOOR_ENCODING = 8'hA1 ;
localparam logic [7:0] GIFT_ENCODING = 8'hBB ;
//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


logic [0:3] [0:3] [3:0] hit_colors = 
{16'hC446,     
 16'h8C62,    
 16'h8932,
 16'h9113};

 

// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][ offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

	
		if (Tile_type == TILE_FLOOR || Tile_type == TILE_GIFT )  // inside an external bracket 
			RGBout <= object_colors[OBJECT_HEIGHT_Y - offsetY][OBJECT_WIDTH_X - offsetX];
            if(offsetY>60) RGBout <= FLOOR_ENCODING;
            else if (Tile_type == TILE_GIFT && offsetY>40 && offsetY<20 && offsetX>40 && offsetX<20) RGBout <= GIFT_ENCODING;	
            else RGBout <= TRANSPARENT_ENCODING ;
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule