// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball, //bumpy
			input	logic	drawing_request_Tile, //tile
			input	logic	drawing_request_Border, //tile
			input logic [1:0] TileType, 
			input logic gift_clear, //no gifts remaining
			input	logic	[3:0] HitEdgeCode , //one bit per edge 
			input	logic finishCount ,

		
			
			output logic collision, // active in case of collision between two objects
			output logic jumpCollision, // active in case where side movement is enabled
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic EndGame,
			output logic victory,
			output logic Loss,
			output logic Remove_Gift
);

//Tile Types codes
localparam  logic [1:0] TILETYPE_BACKGROUND = 2'b00;
localparam  logic [1:0] TILETYPE_FLOOR = 2'b01;
localparam  logic [1:0] TILETYPE_GIFT = 2'b10;
localparam  logic [1:0] TILETYPE_HOLE = 2'b11;

assign collision =  (drawing_request_Ball &&  ( (drawing_request_Tile && (TileType == TILETYPE_FLOOR))  || drawing_request_Border) ) ;
assign jumpCollision =  (drawing_request_Ball && (drawing_request_Tile && (TileType == TILETYPE_BACKGROUND)) ) ; //used for jumping intervals
assign Remove_Gift =  (drawing_request_Ball &&  drawing_request_Tile && (TileType == TILETYPE_GIFT) ) ;
assign victory =  (drawing_request_Ball &&  drawing_request_Tile && (TileType == TILETYPE_HOLE) ) ;
assign Loss =  outOfMap || finishCount ;
assign EndGame = victory || Loss;
assign outOfMap = (drawing_request_Ball &&  drawing_request_Border && (HitEdgeCode == 4'b0001) );

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 
logic showHole ;
logic outOfMap ;

//assign showHole = (numOfGifts == 0);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 
			
						
			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
			if ( collision  && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ;
			end  
	end 
end

endmodule