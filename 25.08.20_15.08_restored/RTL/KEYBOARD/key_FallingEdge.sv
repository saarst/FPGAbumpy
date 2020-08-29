// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 
// detect a key and generate three ouptputs for this key 


module key_FallingEdge 	
 ( 
   input	 logic     clk,
	input	 logic     resetN,
	input  logic     keyN,  
   output logic  keyFallingEdgePulse	//  valid for one clock after presing the key 
 	 
  ) ;
 
 	
	logic keyIsPressed_d,keyIsPressed ; //  _d == delay of one clock 
	logic [3:0] counter;

   assign keyFallingEdgePulse = (!(( keyIsPressed_d == 1'b0 ) && ( keyIsPressed == 1'b1 ))) ; // detects a falling edge (change) in the input
 
  
	always_ff @(posedge clk or negedge resetN)
		begin
			if (!resetN) begin 
				keyIsPressed_d <= 0  ; 
				keyIsPressed  <= 0 ; 
				counter <= 4'h0;
	 
			end
			
			else if (counter == 4'hF )  begin
				counter <= counter +1;
				keyIsPressed_d  <= keyIsPressed; // generate a delay of one frame
				if (!keyN)    keyIsPressed <= 1'b1 ; 
				else 			 keyIsPressed <= 1'b0 ;  
			end
			else counter <= counter +1;

			
		end	
endmodule


