module data_module #(
	parameter length = 60,
	parameter data_width = 18
)(
	input clock,
	input enable,
	output reg data_set_flag,
	output reg signed [data_width - 1:0] data_out
);

integer data_counter;
reg signed [data_width - 1:0] dataInBuff [0:length - 1];

initial begin

    data_counter   <= 0         ;
    dataInBuff[0]  <= 18'd131071;
	dataInBuff[1]  <= 18'd131071;
	dataInBuff[2]  <= 18'd131071;
	dataInBuff[3]  <= 18'd131071;
	dataInBuff[4]  <= 18'd131071;
	dataInBuff[5]  <= 18'd131071;
	dataInBuff[6]  <= 18'd131071;
	dataInBuff[7]  <= 18'd131071;
	dataInBuff[8]  <= 18'd131071;
	dataInBuff[9]  <= 18'd131071;
	dataInBuff[10] <= 18'd131071;
	dataInBuff[11] <= 18'd131071;
	dataInBuff[12] <= 18'd131071;
	dataInBuff[13] <= 18'd131071;
	dataInBuff[14] <= 18'd131071;
	dataInBuff[15] <= 18'd131071;
	dataInBuff[16] <= 18'd131071;
	dataInBuff[17] <= 18'd131071;
	dataInBuff[18] <= 18'd131071;
	dataInBuff[19] <= 18'd131071;
	
	// 20 -131072 are sent (smallest 18 bit value) to check the lower bounds of the FIR filter.
	dataInBuff[20] <= -18'd131072;
	dataInBuff[21] <= -18'd131072;
	dataInBuff[22] <= -18'd131072;
	dataInBuff[23] <= -18'd131072;
	dataInBuff[24] <= -18'd131072;
	dataInBuff[25] <= -18'd131072;
	dataInBuff[26] <= -18'd131072;
	dataInBuff[27] <= -18'd131072;
	dataInBuff[28] <= -18'd131072;
	dataInBuff[29] <= -18'd131072;
	dataInBuff[30] <= -18'd131072;
	dataInBuff[31] <= -18'd131072;
	dataInBuff[32] <= -18'd131072;
	dataInBuff[33] <= -18'd131072;
	dataInBuff[34] <= -18'd131072;
	dataInBuff[35] <= -18'd131072;
	dataInBuff[36] <= -18'd131072;
	dataInBuff[37] <= -18'd131072;
	dataInBuff[38] <= -18'd131072;
	dataInBuff[39] <= -18'd131072;
	
	// 20 random values are sent to check the other opperations.
	dataInBuff[40] <= 18'd131071;
	dataInBuff[41] <= 18'd0;
	dataInBuff[42] <= -18'd17923;
	dataInBuff[43] <= -18'd666;
	dataInBuff[44] <= 18'd999;
	dataInBuff[45] <= -18'd12361;
	dataInBuff[46] <= -18'd1;
	dataInBuff[47] <= 18'd1251;
	dataInBuff[48] <= 18'd48302;
	dataInBuff[49] <= 18'd8592;
	dataInBuff[50] <= 18'd22341;
	dataInBuff[51] <= -18'd55555;
	dataInBuff[52] <= -18'd32123;
	dataInBuff[53] <= -18'd9898;
	dataInBuff[54] <= 18'd23411;
	dataInBuff[55] <= -18'd23211;
	dataInBuff[56] <= 18'd992;
	dataInBuff[57] <= 18'd73;
	dataInBuff[58] <= -18'd124;
	dataInBuff[59] <= -18'd1231;
end

initial begin
	data_out <= {(data_width){1'd0}};
	data_set_flag <= 1'd0;
	data_counter <= 10'd0;
end
always @(posedge clock) begin

	
	if(enable) begin: setcoeff
		if(data_counter == length - 1) begin
			data_set_flag <= 1'd1;
		end
		else begin
		  data_out <= dataInBuff[data_counter];
		  data_counter <= data_counter + 10'd1;
        end


	end
	else begin
		data_set_flag <= 1'd0;
		data_counter <= 10'd0;
		data_out <= {(data_width){1'd0}};
	end

end
endmodule