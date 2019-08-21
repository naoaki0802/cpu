module regi(
clk,
we,
r_addr1,
r_addr2,
r_data1,
r_data2,
w_addr,
w_data);
   input clk, we;
   input [4:0] r_addr1, r_addr2, w_addr;//5bit 入れる
   input [31:0] w_data;
   output [31:0] r_data1, r_data2;//31bit 出す
   //reg [4:0] 	 addr_reg1, addr_reg2;
   reg [31:0] 	 mem [0:31];
   always @(posedge clk) begin
      if(we && w_addr != 0) mem[w_addr] <= w_data;//零レジスタの実装
   //   addr_reg1 <= r_addr1;
   //   addr_reg2 <= r_addr2;
  end
   initial mem[0] <= 0;
   assign r_data1 = mem[r_addr1/*addr_reg1*/];
   assign r_data2 = mem[r_addr2/*addr_reg2*/];

   endmodule
   
