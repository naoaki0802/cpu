module select(
 input wire [1:0]  aluop1_type,
 input wire [1:0]  aluop2_type, 
 input wire [31:0]  srcreg1_num,
 input wire [31:0]  srcreg2_num,
 input wire [31:0] imm,
 input wire [31:0] pc,
 input wire [5:0] alucode,
 //input wire [1:0] aluop2_type,
	      
 output wire 	[31:0]   op1foralu,
 output wire 	[31:0]   op2foralu,
 output wire 	 [31:0]  op1foradder,
 output wire 	 [31:0]  op2foradder	      
);
/*PC+immにジャンプ、PC+4をrdにストアする、J命令はrdが零レジスタである特別な場合
rs1+immにジャンプ、PC+4をrdにストアする、JR命令はrdが零レジスタである特別な場合があるでので、AdderとALUに入るのを選ぶ*/

   function [63:0] select0;
      input wire [5:0] alucode;
      input wire [31:0] pc;
      input wire [31:0] 	srcreg1_num;
      input wire [31:0] 	srcreg2_num;
      input wire [31:0] imm;
      case(alucode)
    `ALU_LUI : select0 ={srcreg1_num, imm};
    
      
	`ALU_JAL : select0 = {pc[31:0], imm[31:0]};
	`ALU_JALR : select0 = {srcreg1_num[31:0], imm[31:0]};

	`ALU_BEQ : select0 = {pc[31:0], imm[31:0]};
	`ALU_BNE : select0 = {pc[31:0], imm[31:0]};
	`ALU_BLT : select0 = {pc[31:0], imm[31:0]};
	`ALU_BGE : select0 = {pc[31:0], imm[31:0]};
	`ALU_BLTU : select0 = {pc[31:0], imm[31:0]};
	`ALU_BGEU : select0 = {pc[31:0], imm[31:0]};

    `ALU_LB : select0 = {srcreg1_num,imm};
    `ALU_LH : select0 ={srcreg1_num, imm};
    `ALU_LW : select0 ={srcreg1_num, imm};
    `ALU_LBU : select0 ={srcreg1_num, imm};
    `ALU_LHU : select0 ={srcreg1_num, imm};

`ALU_SB : select0 ={srcreg1_num, imm};
`ALU_SH : select0 ={srcreg1_num, imm};
`ALU_SW : select0 ={srcreg1_num, imm};

`ALU_ADD :if(aluop2_type == `OP_TYPE_IMM) //addi
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};
else if(aluop2_type == `OP_TYPE_PC)
select0 = {pc,imm};
`ALU_SUB : select0 = {srcreg1_num,srcreg2_num};

`ALU_SLT : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};
`ALU_SLTU : select0 = {srcreg1_num, imm};

`ALU_XOR : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};  
`ALU_OR : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};
`ALU_AND : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};
`ALU_SLL  : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num}; 
`ALU_SRL  : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num}; 
`ALU_SRA   : if(aluop2_type == `OP_TYPE_IMM) 
select0 = {srcreg1_num, imm};
else if(aluop2_type == `OP_TYPE_REG)
select0 = {srcreg1_num, srcreg2_num};

	default :select0 = 64'b0;

      endcase // case (alucode)
   endfunction // case
   
   function [31:0] select_adder0;
      input wire [1:0] 	aluop_type;
      input wire [31:0] pc;
      input wire [31:0] srcreg;
      input wire [31:0] imm;
      case(aluop_type)
	`OP_TYPE_NONE : select_adder0 = 32'b0;
	`OP_TYPE_REG : select_adder0 = srcreg;
	`OP_TYPE_IMM : select_adder0 = imm;
	`OP_TYPE_PC : select_adder0 = pc;

      endcase // case (aluop_type)

   endfunction // case
   
   assign {op1foralu, op2foralu} = select0(alucode,pc,srcreg1_num, srcreg2_num,imm);
   assign op1foradder = select_adder0(aluop1_type, pc, srcreg1_num, imm);
   assign op2foradder = select_adder0(aluop2_type, pc, srcreg2_num, imm);

endmodule // select
