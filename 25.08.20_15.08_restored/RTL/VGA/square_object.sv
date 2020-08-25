
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output   logic [1:0]  Tile_type
);
 
logic	[10:0] Xnum;
logic	[10:0] Ynum;
logic [1:0] tile;

//////////--------------------------------------------------------------------------------------------------------------=
assign Xnum = (pixelX / 80);
assign Ynum = (pixelY / 80);

tile_array Tile (	.clk(clk),
						.resetN(resetN),
						.Xnum(Xnum[2:0]),
						.Ynum(Ynum[2:0]),
						.Tile_Type(tile) );


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		offsetX <= 0;
		offsetY <= 0;
		Tile_type <= 0;
		
	end
	else begin 
	
			offsetX	<= (pixelX - (Xnum*80)); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - (Ynum*80));
			Tile_type <= tile;
			
		end 
		

end 
endmodule 