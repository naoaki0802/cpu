`timescale 1ns /1ps
`include "define.vh"

module alu(
input wire [5:0] alucode,
input wire [31:0] op1,
input wire [31:0] op2,
output wire [31:0] alu_result,
output wire br_taken
);
   
   function [32:0] alualu;
      input wire [5:0] ir;
      input [31:0] op1;
      input [31:0] op2;
      case(alucode)
	`ALU_LUI : alualu = {op2[31:0], 1'b0};

	`ALU_JAL : alualu = {op1[31:0] + 32'b100, 1'b1};

	`ALU_JALR : alualu = {op2[31:0] + 32'b100, 1'b1};

	`ALU_BEQ : begin
	   case(op1 == op2)
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b0, 1'b1};
	     endcase
	end

	`ALU_BNE : begin
           case(op1 != op2)
             0 : alualu = {32'b0, 1'b0};
             1 : alualu = {32'b0, 1'b1};
             endcase // case (op1 != op2)
	end

	`ALU_BLT : begin
	   case({{~op1[31]}, op1[30:0]} < {{~op2[31]}, op2[30:0]})
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b0, 1'b1};
	   endcase // case ()
	end

	`ALU_BGE : begin
	   case({{~op1[31]}, op1[30:0]} >= {{~op2[31]}, op2[30:0]})
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b0, 1'b1};
	   endcase // case ()
	end

	`ALU_BLTU : begin
	   case(op1 < op2)
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b0, 1'b1};
	   endcase // case ()
	end

        `ALU_BGEU : begin
	   case(op1 >= op2)
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b0, 1'b1};
	   endcase // case ()
	end

	`ALU_LB : alualu = {op1 + op2, 1'b0};
	`ALU_LH : alualu = {op1 + op2, 1'b0};
	`ALU_LW : alualu = {op1 + op2, 1'b0};
	`ALU_LBU : alualu = {op1 + op2, 1'b0};
	`ALU_LHU : alualu = {op1 + op2, 1'b0};
	
	`ALU_SB : alualu = {op1 + op2, 1'b0};
	`ALU_SH : alualu = {op1 + op2, 1'b0};
	`ALU_SW : alualu = {op1 + op2, 1'b0};

	`ALU_ADD : alualu = {op1 + op2, 1'b0};
	`ALU_SUB : alualu = {op1 - op2, 1'b0};

	`ALU_SLT : begin
	   if($signed(op1) < $signed(op2))
	   alualu = {32'b1, 1'b0};
	   else alualu = {32'b0, 1'b0};
	   end

	`ALU_SLTU : begin
	   case(op1 < op2)
	     0 : alualu = {32'b0, 1'b0};
	     1 : alualu = {32'b1, 1'b0};
	   endcase // case (op1 < op2)
	   
	end

	`ALU_XOR : alualu = {op1 ^ op2, 1'b0};
	`ALU_OR : alualu = {op1 | op2, 1'b0};
	`ALU_AND : alualu = {op1 & op2, 1'b0};

	`ALU_SLL : alualu = {op1 << op2[4:0], 1'b0};
	`ALU_SRL : alualu = {op1 >> op2[4:0], 1'b0};
	`ALU_SRA : alualu = {$signed(op1) >>> op2[4:0], 1'b0};

      endcase // case (alucode)

   endfunction // case

   assign {alu_result, br_taken} = alualu(alucode, op1, op2);

endmodule // alu

