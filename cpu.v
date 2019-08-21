module cpu(clk, rst);
   input clk, rst;
   
   wire [5:0] dec_out_alucode;
   wire  [1:0] dec_out_op1;
   wire  [1:0] dec_out_op2;
   wire  [31:0] dec_out_alu_result;//alu_out_result
   wire  dec_out_br_taken; //1bit
   wire  [31:0] dec_out_imm;
   wire  [1:0] dec_out_alu1_type;
   wire  [1:0] dec_out_alu2_type;
   wire  [4:0] dec_out_dstreg_num;//from decoder
   wire  [4:0] dec_out_srcreg1_num;//from decoder
   wire  [4:0] dec_out_srcreg2_num;

   wire  [31:0] alu_out_result;//保留
   


   
   wire  [31:0] rom_out_data;//to decoder and from rom
   
   wire [31:0] 	ram_out_data;
   

   wire  [31:0] load_out;
   
   wire we;//1bit reg-decoder
   
   
   
    
 /*  wire [4:0] reg_out_data1; *///selectのsrcreg1_num
   //wire  [4:0] reg_out_data2;
   wire [31:0] reg_out1;
   wire [31:0] reg_out2;

   wire [31:0]  pc_out_pc_result;//pc to rom
   wire [31:0] pc_out_pc_default;//pc
   
   wire  [31:0] adder_out_next_pc;
   
   wire [31:0] select_out_alu1;
   wire [31:0] select_out_alu2;
   wire [31:0] select_out_adder1;
   wire [31:0] select_out_adder2;
   
   


   alu alu0(
.alucode(dec_out_alucode),
.op1(select_out_alu1),
.op2(select_out_alu2),
.alu_result(alu_out_result),
.br_taken(dec_out_br_taken)
);

   select select0(
   .aluop1_type(dec_out_op1),
   .aluop2_type(dec_out_op2),
   .srcreg1_num(reg_out1),
   .srcreg2_num(reg_out2),
   .imm(dec_out_imm),
   .pc(pc_out_pc_result),
   .alucode(dec_out_alucode),
  // .aluop2_type(dec_out_op2),
   .op1foralu(select_out_alu1),
   .op2foralu(select_out_alu2),
   .op1foradder(select_out_adder1),
   .op2foradder(select_out_adder2)
);
   pc pc0(
.rst(rst),
.clk(clk),   
.br_taken(dec_out_br_taken),
.pc_default(pc_out_pc_default),
.pc_branch(adder_out_next_pc),//nextpcから来る
.pc_result(pc_out_pc_result),//,//selectとrom(instruction memory)に入る
.pc_default_out(pc_out_pc_default) //pc_defaultから来る
 );
   adder adder0(
.alucode(dec_out_alucode), //dec_out_alucode 
.op1(select_out_adder1),
.op2(select_out_adder2),
.cpu_result(adder_out_next_pc)
);
   
   decoder decoder0(
.ir(rom_out_data),
.srcreg1_num(dec_out_srcreg1_num),
.srcreg2_num(dec_out_srcreg2_num),
.dstreg_num(dec_out_dstreg_num),
.imm(dec_out_imm),
.alucode(dec_out_alucode),
.aluop1_type(dec_out_op1),
.aluop2_type(dec_out_op2),
.reg_we(we)//,
//.is_load(),
//.is_store(),
//.is_halt()

);
   rom rom0(
.clk(clk),
.r_addr(pc_out_pc_result),// input
.r_data(rom_out_data)//output
);
   block_ram block_ram0(
.clk(clk),
.r_addr(alu_out_result),
.r_data(ram_out_data),//rom_out_data - ram_out_data
.w_addr(alu_out_result),
.w_data(reg_out2),
.alucode(dec_out_alucode),
.rst(rst)
);
 regi reg0(
.clk(clk),
.we(we),
.r_addr1(dec_out_srcreg1_num),
.r_addr2(dec_out_srcreg2_num),
.r_data1(reg_out1),
.r_data2(reg_out2),
.w_addr(dec_out_dstreg_num),
.w_data(load_out)
);
   load load0(
.alucode(dec_out_alucode),
.load_data(ram_out_data),//ram_out_dataに変更
.alu_result(alu_out_result),
.load_result(load_out)
);
endmodule // cpu
   
   
