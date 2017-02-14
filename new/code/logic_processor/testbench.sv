// A testbench is typically only used for simulation
// and is usually not actually converted to physical circuitry.
// It is used to stimulate the input signals of a module 
// with a specific test pattern.

import enums::state;

// The testbench does not have input nor output pins,
// since it will not become real hardware and has
// all of the simulation data hard coded inside it.
module testbench();
    
    // Half clock cycle at 50 MHz.
    // '#1' represents a delay of 10ns (1 timeunit)
    // '#5' represents a delay of 50ns (5 timeunits)
    // ...etc
    timeunit 10ns;
    timeprecision 1ns;
    
    // Any internal signals you declare inside a testbench will
    // be displayed in the simulation.
    logic clk;
    logic reset_n;
    logic a_load_enable_n;
    logic b_load_enable_n;
    logic execute_n;
    logic[2:0] function_select;
    logic[1:0] routing_select;
    logic[3:0] data_in;
    logic[3:0] a_data_out;
    logic[3:0] b_data_out;
    
    // You can view the internal signals of modules from a testbench.
    // Use the period . to traverse the module heiarchy
    state cur_state;
    assign cur_state = logic_processor_inst.control_unit_inst.cur_state;
    
    logic_processor logic_processor_inst
    (
        clk,
        reset_n,
        a_load_enable_n,
        b_load_enable_n,
        execute_n,
        function_select,
        routing_select,
        data_in,
        a_data_out,
        b_data_out
    );
    
    // An 'always' block inside a testbench creates an
    // infinite loop and will execute the contained
    // simulation commands over and over.  This block
    // generates the clock with a period of 100ns.
    // You can create as many always blocks as you want
    // and each will be executed in parallel.
    always
    begin
        
        // The '#5' means 'wait 5 timeunits before
        // applying the next line to the simulation'
        // which sets the clock to 1.
        #5
        clk = 1'b0;
        
        // Wait 5 time units after executing the previous
        // simulation command before setting the clock
        // to 0.
        #5
        clk = 1'b1;
        
    end
    
    // An 'initial' block inside a testbench is executed
    // exactly once.  You can create as many initial blocks
    // as you want and each will be executed in parallel.
    initial
    begin
        
        // 0ns
        reset_n = 1'b1;
        execute_n = 1'b1;
        a_load_enable_n = 1'b1;
        b_load_enable_n = 1'b1;
        
        // 180ns
        // Pull the reset signal low before the next rising clock edge
        #18
        reset_n = 1'b0;
        
        // 220ns
        // Disengage reset signal
        #4
        reset_n = 1'b1;
        
        // 380ns
        // Load the value 1100 into register A
        #16
        data_in = 4'b1100;
        a_load_enable_n = 1'b0;
        
        // 420ns
        // Disengage register load
        #4
        data_in = 4'bxxxx;
        a_load_enable_n = 1'b1;
        
        // 480ns
        // Load the value 1010 into register B
        #6
        data_in = 4'b1010;
        b_load_enable_n = 1'b0;
        
        // 520ns
        // Disengage register load
        #4
        data_in = 4'bxxxx;
        b_load_enable_n = 1'b1;
        
        // 680ns
        // Execute an XOR operation and write result to A
        #16
        function_select = 3'b010;
        routing_select = 2'b10;
        execute_n = 1'b0;
        
        // 720ns
        // Pull the execute switch high before the computation cycle finishes
        #4
        execute_n = 1'b1;
        
        // The computation cycle will finish at 1000ns
        // The follow registers should have the following values at 1001ns:
        //     a_data_out = 0110
        //     b_data_out = 1010
        //     cur_state  = IDLE
        
        // 1180ns
        // Execute a NOT operation and write result to B
        #46
        function_select = 3'b101;
        routing_select = 2'b01;
        execute_n = 1'b0;
        
        // Pull the execute switch high before the computation cycle finishes
        #14
        execute_n = 1'b1;
        
        // The computation cycle will finish at 1500ns
        // The follow registers should have the following values at 1501ns:
        //     a_data_out = 0110
        //     b_data_out = 0001
        //     cur_state  = IDLE
        
        // 1680ns
        // Execute a SWAP operation
        #46
        function_select = 3'bxxx;
        routing_select = 2'b11;
        execute_n = 1'b0;
        
        // The computation cycle will finish at 1500ns
        // The follow registers should have the following values at 1501ns:
        //     a_data_out = 0001
        //     b_data_out = 0110
        //     cur_state  = HOLDING
        
        // Pull the execute switch high after the computation cycle finishes
        #50
        execute_n = 1'b1;
        
    end
    
endmodule
