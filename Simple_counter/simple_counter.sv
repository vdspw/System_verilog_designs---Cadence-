/*----SImple counter model----*/
/*
    +-------------------------------+
    |   Simple Counter Module       |
    |                               |<------- clk
    |                               |<o------ rst  
    |                               |<------- enable
    |                               |<------- load
    |                               |<------- [4:0] data
    |                               |
    |                               |-------> [4:0] count
    |                               |
    +-------------------------------+
*/

`timescale 1ns/100ps 

module counter ( 
    input logic clk,
    input logic rst_,
    input logic enable,
    input logic load,
    input logic [4:0] data,
    output logic [4:0] count
);

  always_ff@(posedge clk or negedge rst_) begin
    if(!rst_)begin
        count <= 5'b0;
    end
    else if(load) begin
        count <= data;
    end 
    else if(enable) begin
        count <= count + 1;
    end   
end


endmodule
