// Declare a module with the name 'function_unit'
module function_unit
(
    // Specify input and output "pins" for this module
    input logic[2:0] function_select,
    input logic a,
    input logic b,
    output logic out
);
    
    // All combinational logic must be declared inside an always_comb block
    // or an assign statement
    always_comb begin
        
        // Create a 1-bit 8-to-1 multiplexer that switches
        // between the outputs of various logic operations.
        case (function_select)
            3'b000:  out = a & b;
            3'b001:  out = a | b;
            3'b010:  out = a ^ b;
            3'b011:  out = 1'b1;
            3'b100:  out = ~(a & b);
            3'b101:  out = ~(a | b);
            3'b110:  out = ~(a ^ b);
            3'b111:  out = 1'b0;
        endcase
        
    end
    
endmodule
