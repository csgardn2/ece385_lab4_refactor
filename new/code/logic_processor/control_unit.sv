// The only reason why this enum is packaged in another file is so it can
// also be read from testbench.sv.  In most cases, you can just declare
// your state enum in the same file as your state machine without a package.
import enums::state_t;

module control_unit
(
    input logic clk,
    input logic reset,
    input logic execute,
    output logic shift_enable
);
    
    // Declare a register which holds the current state.
    enums::state_t cur_state;
    
    // Transition function for the state machine
    // Based on the current state, reset, and execute
    // inputs, the next state is calculated and updated
    // once every rising clock edge
    always_ff @(posedge clk)
    begin
        
        // 'begin' and 'end' statements are almost exactly equivalent
        // to '{' and '}' in C++.  They denote multi-line blocks of
        // code within if statements, case statements, and always blocks.
        // Note that there is only one line of code for each if-statement
        // below, so the usual begin-end 'brackets' were omitted for
        // style purposes.
        if (reset)
            cur_state <= enums::IDLE;
        else if (cur_state == enums::IDLE && execute)
            // Above: 'state == IDLE' refers to the value of the state register
            // just before a clock edge.  When a register is read within an
            // always_ff block (more precisly, in a block containing <=
            // assignments), it referrs to the value of that register just
            // before the clock edge.
            // Below: 'state <= SHIFT_1' refers to a value that is written
            // to a register right after the rising clock edge.
            cur_state <= enums::SHIFT_1;
        else if (cur_state == enums::SHIFT_1)
            cur_state <= enums::SHIFT_2;
        else if (cur_state == enums::SHIFT_2)
            cur_state <= enums::SHIFT_3;
        else if (cur_state == enums::SHIFT_3 && execute)
            // Recall that we do not want to begin another cycle until
            // the 'execute' switch has been returned to the off
            // position.
            cur_state <= enums::HOLDING;
        else if (cur_state == enums::SHIFT_3 && !execute)
            // In this case, the user has returned the 'execute' switch
            // to the off position in the middle of a computation and
            // the processer can be immediatly primed for another operation.
            cur_state <= enums::IDLE;
        else if (cur_state == enums::HOLDING && !execute)
            cur_state <= enums::IDLE;
        
        // In any other case (else), the 'state' register will maintain
        // its previous value.  You do not need to cover every case
        // in an 'always_ff' block but you do for an 'always_comb' block.
        
    end
    
    // Output function of the state machine.  Since this is a Mealy machine,
    // the output will depend on both the current state and the execute input.
    // Note that an 'assign' statement is basically a 1-line always_comb block.
    assign shift_enable
      = (cur_state == enums::IDLE & execute)
      | (cur_state == enums::SHIFT_1)
      | (cur_state == enums::SHIFT_2)
      | (cur_state == enums::SHIFT_3);
    
endmodule

