module logic_processor
(
    
    // Rising edge triggered clock
    input logic clk,
    
    // Push-button 0.  The buttons on the FPGA are active low.
    // It is a common style practice to append '_n' or some
    // other identifier to the end of active low signal names,
    // such as the reset_n signal below.
    input logic reset_n,
    
    // Active-low push-button 1.
    input logic a_load_enable_n,
    
    // Active-low push-button 2.
    input logic b_load_enable_n,
    
    // Active-low push-button 3.
    input logic execute_n,
    
    // Determine the combinational operation to be performed by
    // the function unit.  See function_unit.sv for details.
    input logic[2:0] function_select,
    
    // Determine what new data will be written to registers A
    // and B during an execution cycle.  See routing_unit.sv
    // for details.
    input logic[1:0] routing_select,
    input logic[3:0] data_in,
    output logic[3:0] a_data_out,
    output logic[3:0] b_data_out
    
);
    
    // Delcare some internal signals which are routed
    // from module to module without going to the outside.
    // You should think of these as wire traces on a PCB.
    logic shift_enable;
    logic a_serial_in;
    logic a_serial_out;
    logic b_serial_in;
    logic b_serial_out;
    logic function_to_routing;
    
    // Instantiate a register unit.  This is similar to
    // "instantiating and object named 'register unit_inst'
    // from class 'register_unit'".  Keep in mind, that
    // this creates physical hardware.  You do NOT "call"
    // the register unit, as you would in a software language.
    register_unit register_unit_inst
    (
        // This is shorthand for .clk(clk).
        .clk,
        // Instantiate an inverter for the reset signal and
        // connect the inverter output to the 'reset' pin
        // of this 'register_unit' instance.
        .reset(~reset_n),
        .shift_enable,
        .a_load_enable(~a_load_enable_n),
        .b_load_enable(~b_load_enable_n),
        .a_serial_in,
        .b_serial_in,
        // Here, we connect the
        // 'a_parallel_in' pin of this 'register_unit' instance
        // to the 'data_in' signal of this module 'processor'.
        .a_parallel_in(data_in),
        .b_parallel_in(data_in),
        .a_serial_out,
        .b_serial_out,
        .a_parallel_out(a_data_out),
        .b_parallel_out(b_data_out)
    );
    
    // Instantiate the function unit
    function_unit function_unit_inst
    (
        .function_select,
        .a(a_serial_out),
        .b(b_serial_out),
        .out(function_to_routing)
    );
    
    // Instantiate the routing unit
    routing_unit routing_unit_inst
    (
        .routing_select,
        .a_in(a_serial_out),
        .b_in(b_serial_out),
        .f_in(function_to_routing),
        .a_out(a_serial_in),
        .b_out(b_serial_in)
    );    
    
    // Instantiate a the control unit
    control_unit control_unit_inst
    (
        .clk,
        .reset(~reset_n),
        .execute(~execute_n),
        .shift_enable
    );
    
 endmodule
 