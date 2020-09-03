// (c) Technion IIT, Department of Electrical Engineering 2019 


module	tile_object	(	
					input		logic	clk,
					input		logic	resetN,
					//Write to tile array
					input 	logic RemoveGift,
					//input 	logic	[10:0] TargetX,
					//input 	logic	[10:0] TargetY,
					input 	logic	[1:0] Write_Tile_type, //tile type to write to array

					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic EndGame,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output   logic [1:0]  Tile_type,
					output	logic gift_clear
);
 
logic	[10:0] Xnum;
logic	[10:0] Ynum;
logic [1:0] tile;

//////////--------------------------------------------------------------------------------------------------------------=
assign Xnum = (pixelX / 80);
assign Ynum = (pixelY / 80);

tile_array Tile (	.clk(clk),
						.resetN(resetN),
						.information(2'b01),
						.writeEn(RemoveGift),
						.Xnum(Xnum[2:0]),
						.Ynum(Ynum[2:0]),
						.Tile_Type(tile),
						.EndGame(EndGame),
						.gift_clear(gift_clear)
						);


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