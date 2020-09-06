// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs
// Alex Grinshpun

module six_down_counter //counts down from six to zero
	(
	input logic clk,
	input logic resetN,
	input logic ena,
	input logic ena_cnt,
	input logic loadN, 
	input logic [3:0] datain,
	output logic [3:0] count,
	output logic tc
   );
	


// Down counter
always_ff @(posedge clk or negedge resetN)
  begin
	
	if ( !resetN )	begin 
				count <= 4'b0000;
		end
   else if (!loadN) begin	
				count <= datain;
		end
	else if (ena & ena_cnt ) begin
				count <= (count == 4'b0000) ? (4'd5) : (count-1);
		end
	else begin
				count <= count;
		end
	end
	
	assign tc= ~|count;
			
					
endmodule
