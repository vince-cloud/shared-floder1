`timescale  1 ns/10ps
/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module axi_hp0_wr#(
				parameter STAR_ADDR = 32'h0100_0000)
			(
				//系统信号
			input				rst_n,                   
				//写入DDR3的数据         
			input				i_clk,
			input 				i_data_rst_n,			
			input				i_data_en,
			input[15:0]			i_data,
			
				//AXI总线时钟
			input				AXI_clk,
				//AXI写地址通道
			output reg[31:0]	AXI_awaddr,		
			output[3:0] 		AXI_awlen,		
			output[2:0] 		AXI_awsize,		
			output[1:0] 		AXI_awburst,	
			output[1:0]			AXI_awlock,		
			output[3:0] 		AXI_awcache,	
			output[2:0] 		AXI_awprot,		
			output[3:0] 		AXI_awqos,		
			output reg			AXI_awvalid,	
			input 				AXI_awready,	
				//AXI写数据通道
			output[63:0] 		AXI_wdata,		
			output[7:0] 		AXI_wstrb,		
			output reg			AXI_wlast,		
			output reg			AXI_wvalid,		
			input 				AXI_wready,	
				//AXI写响应通道
			input[5:0] 			AXI_bid,
			input[1:0] 			AXI_bresp,
			input 				AXI_bvalid,	
			output 				AXI_bready		
		);
 
//------------------------------------------------------------------------------------
//内部信号申明
wire[7:0] 	wrfifo_data_count;	//FIFO可读数据数量
reg 		wrfifo_rden;		//FIFO读数据使能信号
reg[7:0] 	wrdata_num;			//写入DDR3数据计数器
reg[3:0]    cstate,nstate;		//状态寄存器

parameter AXI_BURST_LEN	= 16;
parameter STATE_RST  = 4'h0;	
parameter STATE_IDLE = 4'h1; 
parameter STATE_WADD = 4'h2;
parameter STATE_WDAT = 4'h3; 	 
parameter WRITE_DONE = 4'h4;    

//-------------------------------------------------------------------------------
//缓存FIFO，将数据从i_clk转到AXI_clk时钟域，位宽从16bit转到64bit

fifo_generator_0 uut_fifo_generator_0 (
  .rst(~i_data_rst_n),                      // input wire rst
  .wr_clk(i_clk),                // input wire wr_clk
  .rd_clk(AXI_clk),                // input wire rd_clk
  .din(i_data),                      // input wire [15 : 0] din
  .wr_en(i_data_en),                  // input wire wr_en
  .rd_en(wrfifo_rden),                  // input wire rd_en
  .dout(AXI_wdata),                    // output wire [63 : 0] dout
  .full(),                    // output wire full
  .empty(),                  // output wire empty
  .rd_data_count(wrfifo_data_count)  // output wire [7 : 0] rd_data_count
);

//------------------------------------------------------------------------------------
//将i_data_rst_n在AXI_clk时钟域打一拍
reg w_data_rst_n;

always @(posedge AXI_clk)
	w_data_rst_n <= i_data_rst_n; 		

//-------------------------------------------------------------------------------
//AXI写状态机

always @(posedge AXI_clk or negedge rst_n) begin
	if(~rst_n)begin
		cstate <= STATE_RST;
	end
	else begin
		cstate <= nstate;
	end
end 
                                                     																										
always @( * ) begin
	case(cstate)
    STATE_RST: begin
        if(w_data_rst_n) nstate = STATE_IDLE;
        else nstate = STATE_RST;
    end
    STATE_IDLE: begin
		if(!w_data_rst_n) nstate = STATE_RST;
		else if(wrfifo_data_count >= 8'd16) nstate = STATE_WADD;
        else nstate = STATE_IDLE;
    end
	
	STATE_WADD: begin
		if(AXI_awvalid && AXI_awready) nstate = STATE_WDAT;
		else nstate = STATE_WADD;
	end    
    
	STATE_WDAT: begin
		if(wrdata_num >= (AXI_BURST_LEN+1)) nstate = WRITE_DONE;
        else nstate = STATE_WDAT;
    end
	WRITE_DONE: begin
		nstate = STATE_IDLE;
	end
    
    default: begin
        nstate = STATE_RST;
    end
endcase
end

	//1个burst写入数据的个数计数
always @(posedge AXI_clk) begin                                                                
	if (!rst_n) wrdata_num <= 'b0;                                                           
	else if(cstate == STATE_WDAT) begin 
		if(wrdata_num == 8'd0) wrdata_num <= wrdata_num + 1'b1; 
		else if((wrdata_num <= AXI_BURST_LEN) && AXI_wready && AXI_wvalid) wrdata_num <= wrdata_num + 1'b1;              
		else wrdata_num <= wrdata_num;
	end                                                              
	else wrdata_num <= 'b0;                                               
end 
	
//-------------------------------------------------------------------------------
//FIFO读取使能信号产生

always @(*) begin                                                                
	if (cstate == STATE_WDAT) begin
		if(wrdata_num == 8'd0) wrfifo_rden <= 1'b1;
		else if((wrdata_num >= 8'd1) && (wrdata_num < AXI_BURST_LEN) && AXI_wready && AXI_wvalid) wrfifo_rden <= 1'b1;
		else wrfifo_rden <= 1'b0;
	end
	else wrfifo_rden <= 1'b0;                                 
end

//-------------------------------------------------------------------------------
//AXI总线写数据时序产生

	//写地址产生
always @(posedge AXI_clk)begin
	if(cstate == STATE_RST) AXI_awaddr <= STAR_ADDR;
	else if(AXI_awvalid && AXI_awready) AXI_awaddr <= AXI_awaddr + AXI_BURST_LEN * 8;
end

	//写地址有效信号产生
always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_awvalid <= 1'b0;                                                               
	else if(cstate == STATE_WADD) begin
		if(AXI_awvalid && AXI_awready) AXI_awvalid <= 1'b0;                                                        
		else AXI_awvalid <= 1'b1;
	end
	else AXI_awvalid <= 1'b0;                                 
end    

	//写数据有效信号产生
always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_wvalid <= 1'b0;
	else if((wrdata_num >= 8'd1) && (wrdata_num < AXI_BURST_LEN)) AXI_wvalid <= 1'b1; 
	else if((wrdata_num == AXI_BURST_LEN) && !AXI_wready) AXI_wvalid <= 1'b1;
	else AXI_wvalid <= 1'b0;                                 
end

	//写最后一个数据有效信号产生
always @(posedge AXI_clk) begin                                                                
	if (!rst_n) AXI_wlast <= 1'b0;                                                               
	else if((wrdata_num == (AXI_BURST_LEN - 1)) && AXI_wready && AXI_wvalid) AXI_wlast <= 1'b1;  
	else if((wrdata_num == AXI_BURST_LEN) && !AXI_wready) AXI_wlast <= 1'b1;
	else AXI_wlast <= 1'b0;                                 
end

//-------------------------------------------------------------------------------
//AXI HP总线固定赋值设置

assign AXI_awsize	= 3'b011;	//8 Bytes per burst
assign AXI_awburst	= 2'b01;
assign AXI_awlock	= 2'b00;
assign AXI_awcache	= 4'b0010;
assign AXI_awprot	= 3'h0;
assign AXI_awqos	= 4'h0;
assign AXI_wstrb	= 8'hff;
assign AXI_bready 	= 1'b1;
assign AXI_awlen 	= AXI_BURST_LEN - 1; 
	
	
endmodule

