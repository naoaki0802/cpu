`include "define.vh"

module block_ram(clk, r_addr, r_data, w_addr, w_data, alucode, rst);
   input clk, rst;
   input [31:0] r_addr, w_addr;
   input [31:0] w_data;
   input [5:0] 	alucode;
   
   output [31:0] r_data;
   //output [31:0] uart_data;
   
   reg [4:0] 	 addr_reg;
   //reg [31:0] 	 mem [0:31];
   reg[31:0] mem[0:65535];

  // wire 	 uart_we;
   //instruction memory
   // w = we
 //  uart uart0(
//.uart_tx(uart_data),
//.uart_wr_i(uart_we),
//.uart_dat_i(w_data),
//sys_clk_i(clk),
//sys_rstn_i(rst)
//);
   

//initial $readmemh("/home/denjo/b3exp/benchmarks/tests/IntRegImm/code.hex",mem);

   
   always @(posedge clk) begin
      case(alucode)
//                mem[w_addr] <= w_data;
	`ALU_SB : mem[w_addr] <= w_data[7:0];
	`ALU_SH : mem[w_addr] <= w_data[15:0];
	`ALU_SW : mem[w_addr] <= w_data[31:0];
	
      endcase // case (alucode)

	addr_reg <= r_addr;

      //if(r_addr == 32'hf6fff070)
	//begin
	//w <= 1;
	//end
      
    //  else
	//begin
	//w <= 0;
	//end
      
   end
   
   assign r_data = mem[addr_reg];
endmodule // ram

