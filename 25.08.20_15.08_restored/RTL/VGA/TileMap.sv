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

					output	logic drawingRequest, //output that the pixel should be dispalyed
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;
 //Next pixel color
logic	[7:0] RGBoutNew; 

//Drawing request
localparam  logic NO_DRAWING = 1'b0;
localparam  logic YES_DRAWING = 1'b1;

//Tile Types codes
localparam  logic [1:0] TILETYPE_BACKGROUND = 2'b00;
localparam  logic [1:0] TILETYPE_FLOOR = 2'b01;
localparam  logic [1:0] TILETYPE_GIFT = 2'b10;
localparam  logic [1:0] TILETYPE_HOLE = 2'b11;


//Tile Types colors
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
localparam logic [7:0] FLOOR_ENCODING = 8'hA1 ;
localparam logic [7:0] GIFT_ENCODING = 8'hBB ;
localparam logic [7:0] HOLE_ENCODING = 8'hF1 ;
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
	
	
	
	//floor drawing
	if (Tile_type!= TILETYPE_BACKGROUND &&
	(offsetY>63) &&
	(offsetY <75) &&
	(offsetX >10) &&
	(offsetX < 70)
	) 
	begin
			RGBoutNew = FLOOR_ENCODING;
			drawingRequest = YES_DRAWING ;
	end
	else	if (Tile_type!= TILETYPE_BACKGROUND &&   // cheat look good
	(offsetY>60) &&
	(offsetY <=63) &&
	(offsetX >10) &&
	(offsetX < 70)
	) 
	begin
			RGBoutNew = TRANSPARENT_ENCODING;
			drawingRequest = YES_DRAWING ;
			
	end
	
		else	if (Tile_type == TILETYPE_BACKGROUND &&   // cheat look good
	(offsetY==62) &&
	(offsetX >10) &&
	(offsetX < 70)
	) 
	begin
			RGBoutNew = TRANSPARENT_ENCODING;
			drawingRequest = YES_DRAWING ;
			
	end
	
	
	else 
		begin  
			case (Tile_type)
			
			
				TILETYPE_GIFT: begin
					if (  (offsetY<40) && (offsetY>20) && (offsetX<40) && (offsetX>20) ) 
							begin
							RGBoutNew = GIFT_ENCODING;
							drawingRequest = YES_DRAWING ;
							end
					else
						begin
							RGBoutNew = TRANSPARENT_ENCODING ; //default is transparent 
							drawingRequest = NO_DRAWING ;
						end
				end
				
				TILETYPE_HOLE: begin
					if (  (offsetY<40) && (offsetY>20) && (offsetX<40) && (offsetX>20) ) 
							begin
							RGBoutNew = HOLE_ENCODING;
							drawingRequest = YES_DRAWING ;
							end
					else
						begin
							RGBoutNew = TRANSPARENT_ENCODING ; //default is transparent
							drawingRequest = NO_DRAWING ;
						end
						
					
				end
				default: begin
					RGBoutNew = TRANSPARENT_ENCODING ; //default is transparent 
					drawingRequest = NO_DRAWING ;
				end
			endcase
		end
end
//////////--------------------------------------------------------------------------------------------------------------=  

endmodule