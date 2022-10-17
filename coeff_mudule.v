module coeff_module #(
	parameter length = 20,
	parameter data_width = 18
)(
	input clock,
	input enable,
	output reg coeff_set_flag,
	output reg signed [data_width - 1:0] coeff_out
);

integer coeff_counter;
reg signed [data_width - 1:0] coeff [0:length - 1];

initial begin
	coeff[0] <= 18'd34124;
	coeff[1] <= 18'd3114;
	coeff[2] <= 18'd0;
	coeff[3] <= 18'd4991;
	coeff[4] <= 18'd12522;
	coeff[5] <= -18'd7711;
	coeff[6] <= -18'd5151;
	coeff[7] <= 18'd81122;
	coeff[8] <= 18'd9890;
	coeff[9] <= 18'd1091;
	coeff[10] <= -18'd9111;
	coeff[11] <= -18'd10369;
	coeff[12] <= 18'd911;
	coeff[13] <= 18'd1121;
	coeff[14] <= 18'd591;
	coeff[15] <= 18'd7590;
	coeff[16] <= 18'd19;
	coeff[17] <= 18'd5811;
	coeff[18] <= -18'd970;
	coeff[19] <= 18'd10000;
end

initial begin
	coeff_out <= {(data_width){1'd0}};
	coeff_set_flag <= 1'd0;
	coeff_counter <= 10'd0;
end
always @(posedge clock) begin

	
	if(enable) begin: setcoeff

		coeff_out <= coeff[coeff_counter];
		coeff_counter <= coeff_counter + 10'd1;

		if(coeff_counter >= length - 1) begin
			coeff_set_flag <= 1'd1;
		end

	end
	else begin
		coeff_set_flag <= 1'd0;
		coeff_counter <= 10'd0;
		coeff_out <= {(data_width){1'd0}};
	end

end
endmodule