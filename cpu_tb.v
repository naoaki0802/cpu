module cpu_tb;
   reg clk;
   reg rst_n;
   //wire uart_tx;

   parameter CYCLE = 100;

   always #(CYCLE/2) clk = ~clk;

   cpu cpu0(
.clk(clk),
.rst(rst_n)
//.uart_tx(uart_tx)
	    );
   initial begin
      #10 clk = 1'd0;
      rst_n = 1'd0;

      #(CYCLE) rst_n = 1'd1;

      #(300000)  $finish;

   end
endmodule // cpu_tb
