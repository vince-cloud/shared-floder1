/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
//LED闪烁逻辑产生模块
module led_controller(
				//时钟和复位接口
			input clk,		//25MHz输入时钟	
			input rst_n,	//低电平系统复位信号输入	
				//LED指示灯接口
			output led		//用于测试的LED指示灯
		);
		
////////////////////////////////////////////////////		
//计数产生LED闪烁频率	
reg[25:0] cnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 26'd0;
	else cnt <= cnt+1'b1;

assign led = cnt[25];	
	

endmodule

