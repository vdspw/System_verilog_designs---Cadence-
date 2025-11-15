/*----- Simple 2:1 Multiplexer -----*/
/*
    +-----------------------------+
    |        Simple Mux           |<------- sel_a
    |                             |<o------ in_a
    |                             |<o------ in_b
    |                             |      
    |                             |-------> out
    |                             |
    +-----------------------------+
*/  

module scale_mux #(WIDTH = 1)
  
  (
    input logic [WIDTH-1:0]in_a,
    input logic [WIDTH-1:0]in_b,
    input logic sel_a,
    output logic [WIDTH-1:0]out
);
    timeunit 1ns;
    timeprecision 100ps;
    
    always_comb begin
        if(sel_a) begin
            out = in_a;
        end
        else begin
            out = in_b;
        end
    end


endmodule
