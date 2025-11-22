// Package definition - must be first and only defined once
package typedefs;
    // CPU Operations
    typedef enum logic [2:0] {HLT, SKZ, ADD, AND, XOR, LDA, STO, JMP} opcode_t;
    // Control Sequencer States
    typedef enum logic [2:0] {INST_ADDR, INST_FETCH, INST_LOAD, IDLE,
                              OP_ADDR, OP_FETCH, ALU_OP, STORE} state_t;
endpackage : typedefs

/*---- Control Model ----*/
/*  
    +------------------------------+
    |         Control              |<------------- [2:0]opcode
    |                              |<------------- zero
    |                              |<------------- clk
    |                              |<o------------ rst_
    |                              |
    |                              |-------------> load_ac
    |                              |-------------> mem_wr
    |                              |-------------> mem_rd
    |                              |-------------> inc_pc
    |                              |-------------> load_ir
    |                              |-------------> load_pc
    |                              |-------------> halt
    |                              |
    |                              |
    +------------------------------+
*/

import typedefs::*;

module control (
    output logic load_ac,
    output logic mem_rd,
    output logic mem_wr,
    output logic inc_pc,
    output logic load_pc,
    output logic load_ir,
    output logic halt,
    input opcode_t opcode,
    input logic zero,
    input logic clk,
    input logic rst_
);
    
    timeunit 1ns;
    timeprecision 100ps;
    
    state_t state;
    logic aluop;
    
    // ALU operation check
    assign aluop = (opcode inside {ADD, AND, XOR, LDA});
    
    /* ALU operation ----*/
    /*
        +-------------+
        |    ALU      |<------- aluop
        |             |
        | 0,1,2,3 =   |
        |ADD,AND,XOR,LDA |
        |                |
        +----------------+
    */
    
    // Sequential logic for state register
    // Uses state.next() to automatically advance to next enum value
    always_ff @(posedge clk or negedge rst_) begin
        if (!rst_) begin
            state <= INST_ADDR;
        end else begin
            state <= state.next();
        end
    end
    
    // Combinational logic for outputs
    always_comb begin
        // Default outputs to 0
        {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 7'b000_0000;
        
        unique case(state)
            INST_ADDR: ;
            
            INST_FETCH: begin
                mem_rd = 1;
            end
            
            INST_LOAD: begin
                mem_rd = 1;
                load_ir = 1;
            end
            
            IDLE: begin
                mem_rd = 1;
                load_ir = 1;
            end
            
            OP_ADDR: begin
                inc_pc = 1;
                halt = (opcode == HLT);
            end
            
            OP_FETCH: begin
                mem_rd = aluop;
            end
            
            ALU_OP: begin
                load_ac = aluop;
                mem_rd = aluop;
                inc_pc = ((opcode == SKZ) && zero);
                load_pc = (opcode == JMP);
            end
            
            STORE: begin
                load_ac = aluop;
                mem_rd = aluop;
                inc_pc = (opcode == JMP);
                load_pc = (opcode == JMP);
                mem_wr = (opcode == STO);
            end
        endcase
    end
    
endmodule
