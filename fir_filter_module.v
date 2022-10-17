module fir_convolution#(
parameter length = 20,
parameter data_width = 18
)(
input clock,
input load_coeff_flag,
input coeff_set_flag,
input load_data_flag,
input stop_data_load_flag,
input signed [data_width - 1:0] data_in,
input signed [data_width-1 : 0] coeff_in,

output reg signed [(data_width*3)-1 : 0] data_out
);

reg signed [data_width-1 : 0] data_in_buffer [0 : length - 1];
reg signed [data_width-1 : 0] coeff_in_buffer [0 : length - 1];

reg signed [(data_width*3)-1 : 0] fir_output;
reg [length-1 : 0] coefficient_counter;
integer n;


reg [2:0] state ;
reg [2:0] idle = 3'b000;
reg [2:0] coeff_load = 3'b001;
reg [2:0] fir_main = 3'b010;
reg [2:0] stop = 3'b011;
reg [2:0] empty_state1 = 3'b100;
reg [2:0] empty_state2 = 3'b101;
reg [2:0] empty_state3 = 3'b110;
reg [2:0] empty_state4 = 3'b111;

initial begin : initial_value
integer a;
for (a = 0 ; a <=length-1 ; a = a + 1) begin
    data_in_buffer[a]       <=      0       ;
    coeff_in_buffer[a]      <=      0       ;
end
data_out <= 0;
coefficient_counter <= 0;
fir_output <= 0;
state <= idle;

end
always @(posedge clock) begin
case (state)

idle : begin
    if (load_coeff_flag) begin
    state <= coeff_load;
    end
end

coeff_load : begin

coeff_in_buffer[length -coefficient_counter -1] <=coeff_in;
coefficient_counter <= coefficient_counter +20'd1;
state <= fir_main;
end

fir_main : begin

if(coefficient_counter <= length) begin
	coeff_in_buffer[length -coefficient_counter -1] <=coeff_in;
    coefficient_counter <= coefficient_counter +20'd1;
end

    if (load_data_flag==1) begin
    
        for (n=length-1 ; n>0 ; n=n-1) begin
            data_in_buffer[n] <= data_in_buffer[n-1];
        end
        
        data_in_buffer[0] <= data_in;
        fir_output <= 0;
        
        for (n = 0; n <= length - 1; n = n + 1) begin
    		fir_output = fir_output + (data_in_buffer[n] * coeff_in_buffer[length - 1 - n]);
    	end
    
        data_out = fir_output ;
        
        if(stop_data_load_flag == 1) begin
        	state <= stop;
        end
    end
end


stop : begin : stopp
    integer a;
    for (a = 0 ; a <= length-1 ; a = a + 1) begin
        data_in_buffer[a]       <=      0       ;
        coeff_in_buffer[a]      <=      0       ;
    end

coefficient_counter <= 0;
state <= idle;

end

empty_state1 : begin
state <= idle;
end

empty_state2 : begin
state <= idle;
end

empty_state3 : begin
state <= idle;
end

empty_state4 : begin
state <= idle;
end

default : begin : def
    integer a;
    for (a = 0 ; a < length-1 ; a = a + 1) begin
        data_in_buffer[a]       <=      0       ;
        coeff_in_buffer[a]      <=      0       ;
    end
    
    coefficient_counter <= 0;
    state <= idle;
end

endcase
end
endmodule