`include "define.vh"

module load(
input wire [5:0] alucode,
input wire [31:0] load_data,
input wire [31:0] alu_result,
output wire [31:0] load_result
 );
   
   function [31:0] load0;
      input wire [5:0] alucode;
      input wire [31:0] load_data;
      input wire [31:0] alu_result;

      case(alucode)
	`ALU_LB : load0 = {{24{load_data[7]}}, load_data[7:0]};
	`ALU_LBU : load0 = {24'b0, load_data[7:0]};
	`ALU_LH : load0 = {{16{load_data[7]}}, load_data[15:0]};
	`ALU_LHU : load0 = {16'b0, load_data[7:0]};
	`ALU_LW : load0 = load_data;

	default : load0 = alu_result;

      endcase // case (alucode)
   endfunction // case
   assign load_result = load0(alucode,load_data, alu_result);

   endmodule
