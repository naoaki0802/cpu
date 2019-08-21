module pc(
input clk,
input rst,
input wire br_taken,
input wire [31:0] pc_default,
input wire [31:0] pc_branch,
output wire [31:0] pc_result,
output wire [31:0] pc_default_out	  
);
reg [31:0] store;
always @(posedge clk or negedge rst) begin
if(rst == 0)
store <= 32'h8000;
//store <= 0;
else if(br_taken == 1)
store <= pc_branch;
else
store <= store + 32'b100;

end
 ////  function [31:0] pc;
     // input wire   br_taken;
     // input wire [31:0] pc_default;
     // input wire [31:0] pc_branch;
      //case
 //  assign pc_result = pc(br_taken, pc_default, pc_branch);
  // assign pc_default_out = pc_default + 32'b100;
  assign pc_result = store;
  assign pc_default_out = store;
   

endmodule // pc
