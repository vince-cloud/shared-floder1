`timescale  1 ns/10ps
/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module axi_hp0_rd(
				//系统信号
			input				rst_n,                   
				//写入DDR3的数据         
			input				i_clk,
			input 				i_data_rst_n,
			input				i_data_rden,
			output[15:0]		o_data,
			
				//AXI总线时钟
			input				AXI_clk,
				//AXI读地址通道
			output reg[31:0]	AXI_araddr,
			output[1:0]			AXI_arburst,
			output[3:0]			AXI_arcache,			
			output[3:0]			AXI_arlen,
			output[1:0]			AXI_arlock,
			output[2:0]			AXI_arprot,
			output[3:0]			AXI_arqos,
			input				AXI_arready,
			output[2:0]			AXI_arsize,
			output reg			AXI_arvalid,
				//AXI读数据通道
			input[63:0]			AXI_rdata,
			input[5:0]			AXI_rid,
			input 				AXI_rlast,
			output 				AXI_rready,
			input[1:0]			AXI_rresp,
			input 				AXI_rvalid			
		);
		
//------------------------------------------------------------------------------------
//参数、信号申明 

parameter STAR_ADDR = 32'h0100_0000;
parameter AXI_BURST_LEN	= 16;

parameter STATE_RST  = 4'h0;	
parameter STATE_IDLE = 4'h1; 
parameter STATE_RADD = 4'h2; 	 
parameter READ_DONE = 4'h3; 
reg[3:0]    cstate,nstate;

wire[7:0] fifo_wrdata_count;

//------------------------------------------------------------------------------------
//将i_data_rst_n在AXI_clk时钟域打2拍

wire w_data_rst_n,pos_data_rst_n,neg_data_rst_n;	
	
pulse_detection		uut_pulse_detection_odrn(
						.clk(AXI_clk),       	
						.in_sig(i_data_rst_n),	//输入信号
						.out_sig(w_data_rst_n),	//将输入信号同步到本地时钟域后的输出
						.pos_sig(pos_data_rst_n),	//输入信号的上升沿检测，高脉冲保持一个时钟周期
						.neg_sig(neg_data_rst_n)	//输入信号的下降沿检测，高脉冲保持一个时钟周期
					);

//-------------------------------------------------------------------------------
//AXI读状态机

always @(posedge AXI_clk or negedge rst_n)begin
	if(~rst_n)begin
		cstate <= STATE_RST;
	end
	else begin
		cstate <= nstate;
	end
end 
                                                     																										
always @( * )begin
	case(cstate)
    STATE_RST: begin
        if(w_data_rst_n) nstate = STATE_IDLE;
        else nstate = STATE_RST;
    end
    STATE_IDLE: begin
		if(!w_data_rst_n) nstate = STATE_RST;
		else if(fifo_wrdata_count < 8'd128) nstate = STATE_RADD;
		else nstate = STATE_IDLE;
    end
	
	STATE_RADD: begin
		if(AXI_arready) nstate = READ_DONE;
		else nstate = STATE_RADD;
	end    
    
	READ_DONE: begin
		if(AXI_rlast) nstate = STATE_IDLE;
		else nstate = READ_DONE;
	end
    
    default: begin
        nstate = STATE_RST;
    end
endcase
end


//------------------------------------------------------------------------------------
//AXI HP读时序产生

	//读地址有效信号产生
always @(posedge AXI_clk)begin
	if(nstate == STATE_RADD) AXI_arvalid <= 1'b1;
	else AXI_arvalid <= 1'b0;
end

	//读地址产生
always @(posedge AXI_clk)begin
	if(cstate == STATE_RST) AXI_araddr <= STAR_ADDR;
	else if(AXI_arvalid && AXI_arready) AXI_araddr <= AXI_araddr + AXI_BURST_LEN * 8; 
end	

//------------------------------------------------------------------------------------
//DDR3读出数据缓存到FIFO，LCD显示模块读取FIFO数据，位宽从64bit转16bit

fifo_generator_2 uut_fifo_generator_2 (
  .rst(~i_data_rst_n),                      // input wire rst
  .wr_clk(AXI_clk),                // input wire wr_clk
  .rd_clk(i_clk),                // input wire rd_clk
  .din(AXI_rdata),                      // input wire [63 : 0] din
  .wr_en(AXI_rvalid),                  // input wire wr_en
  .rd_en(i_data_rden),                  // input wire rd_en
  .dout(o_data),                    // output wire [15 : 0] dout
  .full(full),                    // output wire full
  .empty(empty),                  // output wire empty
  .wr_data_count(fifo_wrdata_count)  // output wire [7 : 0] wr_data_count
);

//------------------------------------------------------------------------------------
//AXI HP总线固定配置

assign AXI_arsize	= 3'b011;	//8 Bytes per burst
assign AXI_arburst	= 2'b01;
assign AXI_arlock	= 2'b00;
assign AXI_arcache	= 4'b0010;
assign AXI_arprot	= 3'h0;
assign AXI_arqos	= 4'h0;
assign AXI_rready 	= 1'b1;
assign AXI_arlen 	= AXI_BURST_LEN - 1; 
	
endmodule

