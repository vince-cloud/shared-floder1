/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module register_diff_clk(
			input clk,		
			input rst_n,	
			input in_a,
			output out_b	
		);
	
reg[1:0] temp;

always @(posedge clk or negedge rst_n)	
	if(!rst_n) temp <= 2'b00;
	else temp <= {temp[0],in_a};

assign out_b = temp[1];	

endmodule

