

module counter_top (
					input 	logic clk,
					input 	logic resetN,
					input 	logic [10:0] pixelX,
					input 	logic [10:0] pixelY,
					input  	logic load, 
					input 	logic turbo,
					


					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout,
					output logic 	finishCount
					);		
logic [11:0] Count_out;
logic	[10:0] offsetX;
logic	[10:0] offsetY;
logic InsideRectangle;
logic [3:0] current_digit;
logic ena;

one_sec_counter inst0 (	.clk(clk), 
								.resetN(resetN), 
								.turbo(turbo),
								.one_sec(ena)
								);




countdown inst1 (.clk(clk),
					.resetN(resetN),
					.ena(ena),
					.load(load),
					.Count_out(Count_out),
					.tc(finishCount)
					);
	

	
digits_to_numberBit inst2 (.clk(clk),
									.resetN(resetN),
									.pixelX(pixelX),
									.pixelY(pixelY),
									.digit3(Count_out[3:0]),
									.digit2(Count_out[7:4]),
									.digit1(Count_out[11:8]),
									.offsetX(offsetX),
									.offsetY(offsetY),
									.drawingRequest(InsideRectangle),
									.current_digit(current_digit)
									);





	
	NumbersBitMap inst3 (.clk(clk),
								.resetN(resetN),
								.offsetX(offsetX),
								.offsetY(offsetY),
								.InsideRectangle(InsideRectangle),
								.digit(current_digit),
								.drawingRequest(drawingRequest),
								.RGBout(RGBout)
								);
								
								
endmodule