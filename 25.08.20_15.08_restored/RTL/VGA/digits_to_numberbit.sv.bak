//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					//input 	logic signed	[10:0] topLeftX, //position on the screen 
					//input 	logic	signed [10:0] topLeftY,
					input 	logic [3:0] digit1,
					input 	logic [3:0] digit2,
					input 	logic [3:0] digit3,
					
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[3:0] digit
);

parameter  int OBJECT_WIDTH_X = 16;
parameter  int OBJECT_HEIGHT_Y = 32;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
logic [3:0] current_number;
logic insideBracket ; 

//////////--------------------------------------------------------------------------------------------------------------=
always_comb begin
if ( (pixelX  >= 0) &&
		(pixelX < OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 3'b001;
	
else if ( (pixelX  >= OBJECT_WIDTH_X) &&
		(pixelX < 2*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 3'b010;
	
else if ( (pixelX  >= 2*OBJECT_WIDTH_X) &&
		(pixelX < 3*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 3'b011;
	
else if ( (pixelX  >= 3*OBJECT_WIDTH_X) &&
		(pixelX < 4*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 3'b100;
	
else current number = 3'b000;
	
if (current_number == 3'b000) insideBracket =1'b0;
else  insideBracket =1'b1;

end


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
		digit <= 4'h0;
	end
	else begin 

		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			case (current_number) 
			3'b001: digit <= {0,digit1};
			3'b010: digit <= 4'hA; // encoding for ":"
			3'b011: digit <= {0,digit2};
			3'b100: digit <= {0,digit3};
			default : digit<= 4'hF;
			endcase
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 
endmodule 