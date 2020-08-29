//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018




//maybe add state machine for on ground/jumping/falling
//

module	smileyface_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	rightN, //on rise 
					input	logic	leftN, 	
					input	logic	jumpN,
					input   logic   collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 

					/*//debugging input
					input	logic [31:0] Y_ACCEL,
					input	logic [31:0] sideSpeedX,
					input	logic [31:0] jumpSpeedYstep,
					input	logic [31:0] INITIAL_X,
					input	logic [31:0] INITIAL_Y,*/
					input logic [31:0] jumpSpeedYUp,
					

					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


// a module used to generate the  ball trajectory.  

localparam logic ZERO = 0;

parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
///*
parameter int INITIAL_X = 24;
parameter int INITIAL_Y = 428;
parameter int Y_ACCEL = 3; 
parameter int sideSpeedX = 72;
parameter int jumpSpeedYstep = 100;
//parameter int jumpSpeedYUp = 200      ; */ 
logic flag,newFlag;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
//const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
//const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int Xspeed, topLeftX_FixedPoint,XnxtSpeed,XnxtSpeedNew; // local parameters 
int Yspeed, topLeftY_FixedPoint,YnxtSpeed,YnxtSpeedNew;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation x & y Axis speeds 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed	<= INITIAL_X_SPEED;
		Yspeed	<= INITIAL_Y_SPEED;
		XnxtSpeed <=INITIAL_X_SPEED;
		YnxtSpeed	<= INITIAL_Y_SPEED;
		flag     <= 1'b0;
		
	end
	
	else if (startOfFrame) begin
		Xspeed <= XnxtSpeed;
		Yspeed <= YnxtSpeed;
		flag     <= 1'b0;
	end
	
	else if (!flag ) begin
	XnxtSpeed <= XnxtSpeedNew;
	YnxtSpeed <= YnxtSpeedNew;
	flag <=newFlag;
	end
end


always_comb begin
		YnxtSpeedNew = Yspeed - Y_ACCEL;
		XnxtSpeedNew = Xspeed;
		newFlag = flag;
	
	if((Xspeed==ZERO) && (Yspeed==ZERO) && (!jumpN)) begin
					newFlag = 1'b1;
					YnxtSpeedNew	= jumpSpeedYUp;
	end
	
	else if ((!rightN) && (Xspeed==ZERO))  begin
			newFlag = 1'b1;
			XnxtSpeedNew	= 		Xspeed + sideSpeedX;
			YnxtSpeedNew	= jumpSpeedYstep;
	end
	
	else if ((!leftN) && (Xspeed==ZERO)) begin
			newFlag = 1'b1;
			XnxtSpeedNew	= Xspeed - sideSpeedX;
			YnxtSpeedNew	= jumpSpeedYstep;
	end
	
	else if (collision) begin
				newFlag = 1'b1;	
				if(HitEdgeCode==4'B1001 || HitEdgeCode==4'B0011 ) begin //Bottom
					XnxtSpeedNew = ZERO;
					YnxtSpeedNew = ZERO;		
				end 
				
				else if (HitEdgeCode [2])   // hit top border of brick  
				if (Yspeed > 0) // while moving up
						YnxtSpeedNew = -Yspeed ; 
	end 
	
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	
	
	else
	begin
		
		if (startOfFrame) // perform  position integral only 30 times per second
		begin  
			topLeftY_FixedPoint  <= topLeftY_FixedPoint - Yspeed; 
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed; 
			//if (X_direction==1'b0) //  while moving down
			//else 
			//	topLeftX_FixedPoint  <= topLeftX_FixedPoint - Xspeed; 	
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule