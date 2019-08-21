`include "define.vh"

module adder(
input wire [5:0] alucode,
input wire [31:0] op1,
input wire [31:0] op2,
output wire [31:0] cpu_result
);

   function [32:0] adder0;
      input wire [5:0] alucode;
      input wire [31:0] op1;
      input wire [31:0] op2;
      case(alucode)
	`ALU_JAL : adder0 = {op1 + op2};
	`ALU_JALR : adder0 = op1;

	`ALU_BEQ : adder0 = {op1 + op2};
	`ALU_BNE : adder0 = {op1 + op2};
	`ALU_BLT : adder0 = {op1 + op2};
	`ALU_BGE : adder0 = {op1 + op2};
	`ALU_BLTU : adder0 = {op1 + op2};
	`ALU_BGEU : adder0 = {op1 + op2};

	default : adder0 = 32'b0;
endcase
endfunction
   assign cpu_result = adder0(alucode, op1, op2);
endmodule

