// (c) Technion IIT, Department of Electrical Engineering 2018 
// Alex Grinshpun Sept 2019

// Kobi Dekel Jul 2020
// This module shows an example for how to build hierarchy-integrated module from generic module  
// Here we take two 4bit in/out decimal_down_counter and use them to build 8bit in/out 
// decimal_2_digits_counter ( 4bit x 2 binary ) each 4 bit output can be connected to BCD27Seg 
// module and feed 7Seg. The lower 4 bit relate to the units(ones),and the higher 4 bit relate 
// to the Tens.      


module countdown
	(
	input  logic clk, 
	input  logic resetN,
	input  logic ena, 
	input  logic load, 
	output logic [11:0] Count_out,
	output logic tc
   );
	
	logic tc_ones ;
	logic tc_tens ;
	logic tc_mins ;
	
	
	
// seconds (Ones) 
	decimal_down_counter ones_counter(
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena),
		.ena_cnt(ena),  
		.loadN(~load), 
		.datain(4'd0),
		.count(Count_out[3:0]),
		.tc(tc_ones)
	);
	
// seconds (Tens) 
	six_down_counter tens_counter(
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena),
		.ena_cnt(tc_ones),  
		.loadN(~load), 
		.datain(4'd0),
		.count(Count_out[7:4]),
		.tc(tc_tens)
	);

	
// minutes (ones)
	decimal_down_counter mins_counter( 
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(tc_tens & tc_ones),
		.loadN(~load), 
		.datain(4'd2),
		.count(Count_out[11:8]),
		.tc(tc_mins)	
	);

	 
		assign tc = ( tc_ones & tc_tens & tc_mins );
 
endmodule
