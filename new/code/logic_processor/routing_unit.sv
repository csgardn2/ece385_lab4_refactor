module routing_unit
(
    input logic[1:0] routing_select,
    input logic a_in,
    input logic b_in,
    input logic f_in,
    output logic a_out,
    output logic b_out
);
    
    always_comb
    begin
        
        // Create a 2-bit 4-to-1 MUX with
        // a_in, b_in, and f_in as data inputs and
        // a_out and b_out as outputs
        case (routing_select)
            2'b00: begin
                a_out = a_in;
                b_out = b_in;
            end    
            2'b01: begin
                a_out = a_in;
                b_out = f_in;
            end
            2'b10: begin
                a_out = f_in;
                b_out = b_in;
            end
            2'b11: begin
                a_out = b_in;
                b_out = a_in;
            end
        endcase
        
    end
    
endmodule
