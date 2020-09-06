//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	digits_to_numberBit	(	
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
					output	logic	[3:0] current_digit
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
	) current_number = 4'b0001;
	
else if ( (pixelX  >= OBJECT_WIDTH_X) &&
		(pixelX < 2*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 4'b0010;
	
else if ( (pixelX  >= 2*OBJECT_WIDTH_X) &&
		(pixelX < 3*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 4'b0011;
	
else if ( (pixelX  >= 3*OBJECT_WIDTH_X) &&
		(pixelX < 4*OBJECT_WIDTH_X) && 
		(pixelY  >= 0) && 
		(pixelY < OBJECT_HEIGHT_Y)
	) current_number = 4'b0100;
	
else current_number = 4'b0000;
	
if (current_number == 4'b0000) insideBracket =1'b0;
else  insideBracket =1'b1;

end


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest	<=	1'b0;
		current_digit <= 4'hF;
	end
	else begin 

		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			case (current_number) 
			4'b0001: current_digit <= digit1;
			4'b0010: current_digit <= 4'hA; // encoding for ":"
			3'b0011: current_digit <= digit2;
			4'b0100: current_digit <= digit3;
			default : current_digit<= 4'hF;
			endcase
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - (current_number-4'b0001)*OBJECT_WIDTH_X); //calculate relative offsets from top left corner
			offsetY	<= (pixelY);
		end 
		
		else begin  
			current_digit<= 4'hF;
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 
endmodule 