//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018




//maybe add state machine for on ground/jumping/falling
//

module	Bumpy_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	rightN, //on rise 
					input	logic	leftN, 	
					input	logic	jumpN,
					input   logic   collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic EndGame,

					/*//debugging input
					input	logic [31:0] Y_ACCEL,
					input	logic [31:0] sideSpeedX,
					input	logic [31:0] jumpSpeedYstep,
					input logic [31:0] jumpSpeedYUp,
					input logic [31:0] Y_SPEED_LOWER_LIMIT,
					input logic [31:0] Y_SPEED_UPPER_LIMIT,
					*/
					
					

					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


// a module used to generate the  ball trajectory.  

localparam logic ZERO = 0;
const int TILE_WIDTH = 80;

parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;

 
parameter int Y_ACCEL = 3;//3 
parameter int sideSpeedX =74; //76;
parameter int jumpSpeedYstep = 100;//100;
parameter int jumpSpeedYUp = 200; 
parameter int Y_SPEED_LOWER_LIMIT = 170;//170;
parameter int Y_SPEED_UPPER_LIMIT = 170;//170;


logic flag,newFlag;

int INITIAL_X; //= 24; old default
int INITIAL_Y; //= 428;old default
 
const int	FIXED_POINT_MULTIPLIER	=	64;
const int 	BUMPY_OFFSET = 24;

// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
//const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
//const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int Xspeed, topLeftX_FixedPoint,XnxtSpeed,XnxtSpeedNew; // local parameters 
int Yspeed, topLeftY_FixedPoint,YnxtSpeed,YnxtSpeedNew;

//////////Random inital location

//initial X location

 random 
					#( //parameters
					   .SIZE_BITS(3),
						.MIN_VAL(0),
						.MAX_VAL(7)
					 )
 initalX 
					( //connections
					 .clk(clk),
					 .resetN(resetN),
					 .rise(EndGame),
					 .dout(INITIAL_X)
					 );
					 
 //initial Y location

 random 
					#( //parameters
					   .SIZE_BITS(3),
						.MIN_VAL(0),
						.MAX_VAL(5)
					 )
 initalY 
					( //connections
					 .clk(clk),
					 .resetN(resetN),
					 .rise(EndGame),
					 .dout(INITIAL_Y)
					 );
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation x & y Axis speeds 

always_ff@(posedge clk or negedge resetN)
begin
	if (!resetN)     		begin
		Xspeed	 <= INITIAL_X_SPEED;
		Yspeed	 <= INITIAL_Y_SPEED;
		XnxtSpeed <= INITIAL_X_SPEED;
		YnxtSpeed <= INITIAL_Y_SPEED;
		flag      <= 1'b0;
		
	end
	
	else if (startOfFrame) begin
		Xspeed 	 <= XnxtSpeed;
		Yspeed 	 <= YnxtSpeed;
		flag      <= 1'b0;
	end
	
	else if (!flag ) begin
	XnxtSpeed <= XnxtSpeedNew;
	YnxtSpeed <= YnxtSpeedNew;
	flag <=newFlag;
	end
end


always_comb begin
		if ((Yspeed > (- Y_SPEED_LOWER_LIMIT)) && (Yspeed < Y_SPEED_UPPER_LIMIT)) 
			YnxtSpeedNew = Yspeed - Y_ACCEL;
		else YnxtSpeedNew = Yspeed;
		
		XnxtSpeedNew = Xspeed;
		newFlag = flag;
	
	if((Xspeed==ZERO) && (!jumpN) && (collision) && (HitEdgeCode[0]) ) begin
					newFlag = 1'b1;
					YnxtSpeedNew	= jumpSpeedYUp;
	end
	
	else if ((!rightN)  && ( ((collision) && (HitEdgeCode[0])) || (Yspeed == jumpSpeedYUp)) )  begin
			newFlag = 1'b1;
			XnxtSpeedNew	=  sideSpeedX;
			YnxtSpeedNew	= jumpSpeedYstep;
	end
	
	else if ((!leftN) && ( ((collision) && (HitEdgeCode[0])) || (Yspeed == jumpSpeedYUp)) ) begin
			newFlag = 1'b1;
			XnxtSpeedNew	=  - sideSpeedX;
			YnxtSpeedNew	= jumpSpeedYstep;
	end
	
	else if (( (Xspeed == sideSpeedX) || (Xspeed == -sideSpeedX)) && (Yspeed < (-jumpSpeedYstep) ))
			XnxtSpeedNew = ZERO;
	
	else if (collision) begin
				newFlag = 1'b1;
			
			
				if(HitEdgeCode[0]) begin 								//Bottom
					XnxtSpeedNew = ZERO;
					YnxtSpeedNew = 100;
				end 
				
				else if (HitEdgeCode [2] && Yspeed > 0 ) begin   //Top - hit top border of brick   while moving up 
						if (Xspeed != 0) XnxtSpeedNew = -Xspeed;
						else XnxtSpeedNew = ZERO;
						
						if (Yspeed <Y_SPEED_UPPER_LIMIT) YnxtSpeedNew = -Yspeed; 
						else  YnxtSpeedNew = -170;
				end
					
				else if (HitEdgeCode [1] && (Xspeed > 0) )      //Right - hit right border  while moving right
						XnxtSpeedNew = -Xspeed;
				
				else if (HitEdgeCode [3] && (Xspeed < 0) )      //Left - hit left border  while moving left
						XnxtSpeedNew = -Xspeed;
	end 
	
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= ((INITIAL_X * TILE_WIDTH) + BUMPY_OFFSET) * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= ((INITIAL_Y * TILE_WIDTH) + BUMPY_OFFSET) * FIXED_POINT_MULTIPLIER;
	end
	
	
	
	else
	begin
		
		
		if (startOfFrame) // perform  position integral only 30 times per second
		begin  
			topLeftY_FixedPoint  <= topLeftY_FixedPoint - Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 	
		end
		else if(EndGame)
			begin
				topLeftX_FixedPoint	<= ((INITIAL_X * TILE_WIDTH) + BUMPY_OFFSET) * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<= ((INITIAL_Y * TILE_WIDTH) + BUMPY_OFFSET) * FIXED_POINT_MULTIPLIER;
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule