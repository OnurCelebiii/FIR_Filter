//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2022 13:31:16
// Design Name: 
// Module Name: tb_fir
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fir;

localparam CLOCK_FREQ = 50000000;

// Parameters for the dut module.
localparam TAPS = 20;
localparam DATA_WIDTH = 18;

// Parameter for the number of data inputs.
localparam NUMB_DATAIN = 60;

reg clock;
reg startTest = 1'd1;


// Local parameters for the n_tap_fir module.
reg loadDataFlag;
wire stopDataLoadFlag;
wire signed [DATA_WIDTH - 1:0] dataIn;
wire signed [(DATA_WIDTH * 3) - 1:0] dataOut;


// Local parameters for the setup_FIR_coeff module.
reg enableFIRCoeff;
wire coeffSetFlag;
wire signed [DATA_WIDTH - 1:0] coeffOut;

reg [1:0] stateDut;
localparam IDLE = 0;
localparam ENABLE_COEFF = 1;
localparam FIR_MAIN = 2;
localparam STOP = 3;


coeff_module #(
	.length 				(TAPS),
	.data_width 		(DATA_WIDTH)
) setupCoeff (
	.clock				(clock),
	.enable				(enableFIRCoeff),
	
	.coeff_set_flag		(coeffSetFlag),
	.coeff_out			(coeffOut)
);



// Connecting the dut.
fir_convolution #(
	.LENGTH					(TAPS),
	.DATA_WIDTH				(DATA_WIDTH)
	)dut(
	
	.clock					(clock),
	.load_coeff_flag		(enableFIRCoeff),
	.load_data_flag			(loadDataFlag),
	.coeff_set_flag			(coeffSetFlag),
	.stop_data_load_flag 	(stopDataLoadFlag),
	.coeff_in				(coeffOut),
	.data_in				(dataIn),
	
	
	.data_out 				(dataOut)
);

 data_module #(
	.length         (NUMB_DATAIN),
	.data_width     (DATA_WIDTH)
)DATA(
	.clock              (clock),
	.enable             (loadDataFlag),
	
	.data_set_flag      (stopDataLoadFlag),
	.data_out           (dataIn)
);

initial begin
	stateDut <= IDLE;
	clock <= 0;
	enableFIRCoeff = 1'd0;
	startTest = 1'b1;
	loadDataFlag = 1'd0;
end

real HALF_CLOCK_PERIOD = (1000000000.0/$itor(CLOCK_FREQ))/2.0;
integer half_cycles = 0;


// Create the clock toggeling and stop the simulation when half_cycles == (2*NUM_CYCLES).
always begin
	#(HALF_CLOCK_PERIOD);
	clock = ~clock;
	half_cycles = half_cycles + 1;

	if(startTest==0) begin
		$stop;
	end
end

always @(posedge clock) begin
	case(stateDut)
	
	
		// State IDLE. This state waits until startTest is high before transitioning to ENABLE_COEFF.
		IDLE: begin
				stateDut <= ENABLE_COEFF;
		end
		
		
		// State ENABLE_COEFF. This state enables the coefficients module and transitions to FIR_MAIN.
		ENABLE_COEFF: begin
			enableFIRCoeff <= 1'd1;
			stateDut <= FIR_MAIN;
		end
		
		
		// State FIR_MAIN. This state enables the loading of data to the dut module and then
		// loads dataInBuff to dataIn. When the counter is equal to NUMB_DATAIN the state 
		// transitions to STOP.
		FIR_MAIN: begin
		   if (coeffSetFlag ==1) begin
		   enableFIRCoeff <= 0;
		   end
		   if (stopDataLoadFlag ==1) begin
		      loadDataFlag <= 1'd0;
		      stateDut <= STOP;
		   end
		   else begin
		      loadDataFlag <= 1'd1;
		   end
		end
		
		
		// State STOP. This state resets all the used parameters in this FSM.
		STOP: begin
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			loadDataFlag <= 1'd0;
			
			
		end
		
		
		// State default. This is a default state just incase the FSM is in an unkown state.
		default: begin
			stateDut <= IDLE;
			enableFIRCoeff <= 1'd0;
			startTest <= 1'd0;
			loadDataFlag <= 1'd0;
			
		end	
	endcase
end


endmodule
