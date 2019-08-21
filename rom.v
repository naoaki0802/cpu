module rom(clk, r_addr, r_data);//data memory
  input clk;
   input [31:0] r_addr;//4-31
   output [31:0] r_data;
 //  wire [31:0] test;
  // wire [31:0] test1;
   reg [31:0] 	 addr_reg; //4-31
  //reg [31:0] 	 mem [0:8095];
    reg[31:0] mem[0:65535];

initial $readmemh("/home/denjo/b3exp/benchmarks/tests/IntRegImm/code.hex",mem);//通った
//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/ControlTransfer/code.hex",mem);//失敗
//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/IntRegReg/code.hex",mem);//失敗
//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/LoadAndStore/code.hex",mem);//失敗
//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/MemoryDependent/code.hex",mem);//失敗
//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/ZeroRegister/code.hex",mem);//失敗

/*nteger i;
initial begin 
    for(i=0; i <65536; i=i+1)
        mem[i] <= 0; 
end*/
   
   always@(posedge clk) begin
      addr_reg <= r_addr;
   end
  assign r_data = mem[r_addr[31:2]];
  //assign r_data = 0;//mem[0];//r_data = mem[r_addr[31:2]];
 /* assign test = 0;
  assign test1 = mem[0];*/
  
   endmodule

   
