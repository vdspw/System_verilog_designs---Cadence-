/* --- Modelling a simple register --- */
/* 
    +-----------------------------+
    |        Simple Register      |<------- clk
    |                             |<o------ rst
    |                             |
    |                             |<------- enable
    |                             |<------- [7:0] data
    |                             |
    |                             |
    |                             |-------> [7:0] out
    |                             |
    |                             |
    +-----------------------------+
*/

module register (
    input logic clk,
    input logic rst_,
    input logic enable,
    input logic [7:0] data,
    output logic [7:0] out
);
 timeunit 1ns;
 timeprecision 100ps;

  always_ff@(posedge clk or negedge rst_) begin
   if(!rst_) begin
        out<= 8'b0;
    end
    else if(enable) begin
        out<= data;
    end
 end



endmodule
