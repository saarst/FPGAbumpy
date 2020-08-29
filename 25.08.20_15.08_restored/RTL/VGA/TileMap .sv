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
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

logic	[7:0] RGBoutNew; 
//Tile Types 
localparam  logic [1:0] TILE_BACKGROUND = 2'b00;
localparam  logic [1:0] TILE_FLOOR = 2'b01;
localparam  logic [1:0] TILE_GIFT = 2'b10;
// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam logic [7:0] FLOOR_ENCODING = 8'hA1 ;
localparam logic [7:0] GIFT_ENCODING = 8'hBB ;
//////////--------------------------------------------------------------------------------------------------------------=
 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) 
		RGBout <=	8'h00;
	else 
		RGBout <= RGBoutNew;
end

always_comb
begin
	RGBoutNew = TRANSPARENT_ENCODING ;
	drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ;
	case (Tile_type)
	
		TILE_FLOOR: begin
			if ( (offsetY>60) && (offsetY <75) && (offsetX >10) && (offsetX < 70) ) 
					RGBoutNew = FLOOR_ENCODING;
		end
	
		TILE_GIFT: begin
			if ( (offsetY>60) && (offsetY <75) && (offsetX >10) && (offsetX < 70) ) 
					RGBoutNew = FLOOR_ENCODING;
			else if (  (offsetY>40) && (offsetY<20) && (offsetX>40) && (offsetX<20) ) 
					RGBoutNew = GIFT_ENCODING;
		end
	endcase
end
//////////--------------------------------------------------------------------------------------------------------------=  

endmodule