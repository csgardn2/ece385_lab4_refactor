module register_unit
(
    // Rising edge triggered clock
    input logic clk,
    
    // Clears registers to 0 if reset is high during a rising clock edge
    input logic reset,
    
    // Set to high to enable 1-bit right shifts each clock cycle for both registers a and b.
    input logic shift_enable,
    
    // Set to high to load data from parallel inputs.  Has priority over shift_enable.
    input logic a_load_enable,
    input logic b_load_enable,
    
    // Serial data inputs - Feedback from the routing unit
    input logic a_serial_in,
    input logic b_serial_in,
    
    // Parallel data inputs - From switches
    input logic[3:0] a_parallel_in,
    input logic[3:0] b_parallel_in,
    
    // Serial data outputs - Sent to the computation unit
    output logic a_serial_out,
    output logic b_serial_out,
    
    // Parallel data outputs - For viewing on the hex displays
    output logic[3:0] a_parallel_out,
    output logic[3:0] b_parallel_out
);
    
    // Declare internal storage for this module.  2 4-bit registers.
    logic[3:0] a_storage;
    logic[3:0] b_storage;
    
    // Compute the next-state of registers a_storage and b_storage at each rising clcok edge 
    always_ff @(posedge clk)
    begin
        
        // Prioritized behavior of A register
        if (reset)
            a_storage <= 4'h0;
        else if (a_load_enable)
            a_storage <= a_parallel_in;
        else if (shift_enable)
            a_storage <= {a_serial_in, a_storage[3:1]};
        
        // Prioritized behavior of B register.  This if-else chain is independent of that of
        // A above and operates in parallel with it (both registers update in the same clock cycle)
        if (reset)
            b_storage <= 4'h0;
        else if (b_load_enable)
            b_storage <= b_parallel_in;
        else if (shift_enable)
            b_storage <= {b_serial_in, b_storage[3:1]};
        
    end
    
    // Each 'assign' statement is basically shorthand for a 1-line always_comb block.
    assign a_serial_out = a_storage[0];
    assign b_serial_out = b_storage[0];
    assign a_parallel_out = a_storage;
    assign b_parallel_out = b_storage;
    
endmodule

