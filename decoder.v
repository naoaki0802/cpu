`timescale 1ns / 1ps
`include "define.vh"



module decoder(
    input wire [31:0] ir,
    output wire [4:0] srcreg1_num,
    output wire [4:0] srcreg2_num,
    output wire [4:0] dstreg_num,
    output wire [31:0] imm,
    output wire [5:0] alucode,
    output wire [1:0] aluop1_type,
    output wire [1:0] aluop2_type,
    output wire       reg_we //,
);

wire is_load;
wire is_store;
wire is_halt;

   
      

   //always @(*) begin
      function [60:0] aludec;
	 input [31:0] ir;
case(ir[6:0])
  `LUI : aludec = {5'b0, 5'b0, ir[11:7], {ir[31:12], 12'b0}, `ALU_LUI, `OP_TYPE_NONE, `OP_TYPE_IMM, 1'b1, 3'b0};
  
  `AUIPC : aludec = {5'b0, 5'b0, ir[11:7], {ir[31:12], 12'b0}, `ALU_ADD, `OP_TYPE_IMM, `OP_TYPE_PC, 1'b1, 3'b0};
  
  `JAL : begin
if(ir[11:7] == 5'b0)
aludec = {5'b0, 5'b0, ir[11:7], {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0}, `ALU_JAL, `OP_TYPE_IMM, `OP_TYPE_PC, 1'b0, 3'b0};
else
  aludec = {5'b0, 5'b0, ir[11:7], {{12{ir[31]}}, ir[19:12], ir[20], ir[30:21], 1'b0}, `ALU_JAL, `OP_TYPE_IMM, `OP_TYPE_PC, 1'b1, 3'b0};
  end
  
  `JALR : aludec = {ir[19:15], 5'b0, ir[11:7], {{12{ir[31]}}, ir[30:20]}, `ALU_JALR, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
  `BRANCH : begin
     case(ir[14:12])
       3'b000 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BEQ,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
    
       3'b001 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BNE,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
     
       3'b100 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BLT,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
    
       3'b101 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BGE,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
    
       3'b110 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BLTU,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
    
       3'b111 : aludec = {ir[19:15], ir[24:20], 5'b0, {{20{ir[31]}}, ir[7], ir[30:25], ir[11:8], 1'b0}, `ALU_BGEU,  `OP_TYPE_REG, `OP_TYPE_REG, 4'b0};
     endcase // case (ir[14:12])
  end // case: 'BRANCH
  
	 
  
  `LOAD : begin
     case(ir[14:12])
       3'b000 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_LB, `OP_TYPE_REG, `OP_TYPE_IMM, 2'b11, 2'b0};//
     
       3'b001 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_LH, `OP_TYPE_REG, `OP_TYPE_IMM, 2'b11, 2'b0};
    
       3'b010 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_LW, `OP_TYPE_REG, `OP_TYPE_IMM, 2'b11, 2'b0};
    
       3'b100 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_LBU, `OP_TYPE_REG, `OP_TYPE_IMM, 2'b11, 2'b0};
    
       3'b101 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_LHU, `OP_TYPE_REG, `OP_TYPE_IMM, 2'b11, 2'b0};
     endcase // case (ir[14:12])
  end // case: `LOAD
  

    `STORE : begin
       case(ir[14:12])
         3'b000 : aludec = {ir[19:15], ir[24:20], 5'b0, {{21{ir[31]}}, ir[30:25], ir[11:7]}, `ALU_SB, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b0, 1'b0, 1'b1, 1'b0};
       
         3'b001 : aludec = {ir[19:15], ir[24:20], 5'b0, {{21{ir[31]}}, ir[30:25], ir[11:7]}, `ALU_SH, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b0, 1'b0, 1'b1, 1'b0};
       
         3'b010 : aludec = {ir[19:15], ir[24:20], 5'b0, {{21{ir[31]}}, ir[30:25], ir[11:7]}, `ALU_SW, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b0, 1'b0, 1'b1, 1'b0};
       endcase // case (ir[14:12])
    end
  
       
    `OPIMM : begin
       case(ir[14:12])
	 3'b000 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_ADD, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
      
	 3'b010 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_SLT, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
     
	 3'b011 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_SLTU, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
      
	 3'b100 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_XOR, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
      
	 3'b110 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_OR, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
    
	 3'b111 : aludec = {ir[19:15], 5'b0, ir[11:7], {{21{ir[31]}}, ir[30:20]}, `ALU_AND, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
       
	 3'b001 : aludec = {ir[19:15], 5'b0, ir[11:7], {{20{ir[24]}}, ir[31:20]}, `ALU_SLL, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
      
	 3'b101 : case(ir[30])
                    1'b0 : aludec = {ir[19:15], 5'b0, ir[11:7], {{20{ir[24]}}, ir[31:20]}, `ALU_SRL, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
	         
	            1'b1 : aludec = {ir[19:15], 5'b0, ir[11:7], {{20{ir[24]}}, ir[31:20]}, `ALU_SRA, `OP_TYPE_REG, `OP_TYPE_IMM, 1'b1, 3'b0};
		  endcase // case (ir[30])
       endcase // case (ir[14:12])
    end // case: `OPIMM
  
                                                                                                          
       
     `OP : begin
        case(ir[14:12])
	  3'b000 : case(ir[30])
		     1'b0 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_ADD, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
		   
                     1'b1 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SUB, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};

		   endcase // case (ir[30])
	  
       
          3'b001 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SLL, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
       
          3'b010 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SLT, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
        
          3'b011 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SLTU, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
        
          3'b100 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_XOR, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
        
          3'b101 : begin
          case(ir[30])
                     1'b0 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SRL, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};	
                   
                     1'b1 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_SRA, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
		   endcase // case (ir[30])
		   end
		   
	  
         
          3'b110 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_OR, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};
       
          3'b111 : aludec = {ir[19:15], ir[24:20], ir[11:7], 32'b0, `ALU_AND, `OP_TYPE_REG, `OP_TYPE_REG, 1'b1, 3'b0};	 
	endcase // case (ir[14:12])
     end // case: `OP
endcase // case (ir[6:0])

      endfunction // case
   assign{ srcreg1_num, srcreg2_num, dstreg_num, imm, alucode, aluop1_type, aluop2_type, reg_we , is_load, is_store, is_halt } = aludec(ir);

endmodule // decoder

   
