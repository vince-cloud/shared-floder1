/////////////////////////////////////////////////////////////////////////////
//特权同学 携手 威视锐V3学院 精心打造 Xilinx FPGA开发板系列
//工程硬件平台： Xilinx Artix7 FPGA 
//开发套件型号： STAR 入门FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供STAR开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
//最新资料下载： http://pan.baidu.com/s/1kU4WWvH
/////////////////////////////////////////////////////////////////////////////
module ddr3_cache(
				//DDR3控制器IP的用户接口信号：时钟与复位
			input clk,	//时钟信号，是DDR3时钟（400MHz）的1/4，即100MHz
			input clk_33m,	//LCD驱动时钟33MHz
			input rst_n,	//复位信号
			
			//DDR3 Controller IP接口
				//DDR3控制器IP的用户接口信号：控制信号
			(*mark_debug = "true"*) output reg[27:0] app_addr,	//DDR3地址总线
			output reg[2:0] app_cmd,		//DDR3命令总线，3‘b000--写；3'b001--读；3‘b011--wr_bytes（With ECC enabled, the wr_bytes operation is required for writes with any non-zero app_wdf_mask bits.）
			(*mark_debug = "true"*) output reg app_en,	//DDR3操作请求信号，高电平有效
			(*mark_debug = "true"*) input app_rdy,	//DDR3操作响应信号，表示当前的app_en请求已经获得响应，可以继续操作
				//DDR3控制器IP的用户接口信号：写数据信号
			output[127:0] app_wdf_data,	//DDR3写入数据总线
			(*mark_debug = "true"*) output reg app_wdf_end,	//DDR3最后一个字节写入指示信号，与app_wdf_data同步指示当前操作为最后一个数据写入
			(*mark_debug = "true"*) output reg app_wdf_wren,	//DDR3写入数据使能信号，表示当前写入数据有效
			(*mark_debug = "true"*) input app_wdf_rdy,	//DDR3可以执行写入数据操作，该信号拉高表示写数据FIFO已经准备好接收数据
				//DDR3控制器IP的用户接口信号：读数据信号
			input[127:0] app_rd_data,	//DDR3读取数据总线
			(*mark_debug = "true"*) input app_rd_data_end,	//DDR3最有一个字节读取指示信号，与app_rd_data同步指示当前操作为最后一个数据读出
			(*mark_debug = "true"*) input app_rd_data_valid,	//DDR3读出数据使能信号，表示当前读出数据有效
			
				//ImageSensor数据写入DDR3接口
			input image_pclk,
			input image_ddr3_wren,
			input image_ddr3_clr,
			input[15:0] image_ddr3_wrdb,
			
				//LCD模块读DDR3数据接口
			(*mark_debug = "true"*) output[15:0] lcd_ddr3_rfdb,	//输出到LCD模块待显示的DDR3读出数据
			(*mark_debug = "true"*) input lcd_ddr3_rfreq,		//LCD模块发出的读FIFO请求信号，高电平有效
			(*mark_debug = "true"*) input lcd_ddr3_rfclr		//LCD模块发出的读FIFO复位，低电平有效
			
		);
		
////////////////////////////////////////////////////
//DDR3的单次操作数据量：32*128bit = 256*16bit数据
parameter BURST_WR_128BIT = 10'd8;//10'd256;	//burst写数据数量
parameter BURST_RD_128BIT = 10'd256;	//burst读数据数量		

////////////////////////////////////////////////////
//image_ddr3_clr同步到clk时钟域
wire image_ddr3_clr_r;

register_diff_clk		register_diff_clk_dc1(
							.clk(clk),		
							.rst_n(rst_n),	
							.in_a(image_ddr3_clr),
							.out_b(image_ddr3_clr_r)	
						);

////////////////////////////////////////////////////
//写数据FIFO
//当该FIFO数据大等于32*128bit时就发起写DDR3操作	
(*mark_debug = "true"*) wire[9:0] wfifo_rd_data_count;
wire[12:0] wfifo_wr_data_count;
wire[127:0] wfifo_rd_data;
reg wfifo_rd_en;
	
fifo_generator_1 	fifo_for_ddr3_write (
  .rst(!rst_n || image_ddr3_clr_r),                	// input wire rst
  .wr_clk(image_pclk),         	// input wire wr_clk
  .rd_clk(clk),                	// input wire rd_clk
  .din(image_ddr3_wrdb),       	// input wire [15 : 0] din
  .wr_en(image_ddr3_wren),     	// input wire wr_en
  .rd_en(wfifo_rd_en),         	// input wire rd_en
  .dout(wfifo_rd_data),        	// output wire [127 : 0] dout
  .full(),                   	// output wire full
  .empty(),                  	// output wire empty
  .rd_data_count(wfifo_rd_data_count),  // output wire [6 : 0] rd_data_count
  .wr_data_count(wfifo_wr_data_count)  // output wire [9 : 0] wr_data_count
);		
/*		
reg[16:0] user_ddr3_write_addr;	//DDR3写入地址
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_write_addr <= 17'd0;
	else if(image_ddr3_clr_r) user_ddr3_write_addr <= 17'd0;
	else if(cstate == SWRED) user_ddr3_write_addr <= user_ddr3_write_addr+1'b1;		
*/
reg[21:0] user_ddr3_write_addr;	//DDR3写入地址
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_write_addr <= 22'd0;
	else if(image_ddr3_clr_r) user_ddr3_write_addr <= 22'd0;
	else if(cstate == SWRED) user_ddr3_write_addr <= user_ddr3_write_addr+1'b1;	
	
////////////////////////////////////////////////////
//lcd_ddr3_rfclr同步到clk时钟域
wire lcd_ddr3_rfclr_r;

register_diff_clk		register_diff_clk_dc2(
							.clk(clk),		
							.rst_n(rst_n),	
							.in_a(lcd_ddr3_rfclr),
							.out_b(lcd_ddr3_rfclr_r)	
						);
		
////////////////////////////////////////////////////
//读数据FIFO
//当该FIFO数据少于128*128bit时就发起读DDR3操作	
wire[12:0] rfifo_rd_data_count;
(*mark_debug = "true"*) wire[9:0] rfifo_wr_data_count;
		
fifo_generator_0 		fifo_for_ddr3_read (
  .rst(!rst_n || lcd_ddr3_rfclr),                      // input wire rst
  .wr_clk(clk),                // input wire wr_clk
  .rd_clk(clk_33m),                // input wire rd_clk
  .din(app_rd_data),                  // input wire [127 : 0] din		//DDR3读出数据
  .wr_en(app_rd_data_valid),          // input wire wr_en			//DDR3读出数据有效信号
  .rd_en(lcd_ddr3_rfreq),                  // input wire rd_en
  .dout(lcd_ddr3_rfdb),                    // output wire [15 : 0] dout
  .full(),                    // output wire full
  .empty(),                  // output wire empty
  .valid(),                  // output wire valid
  .rd_data_count(rfifo_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(rfifo_wr_data_count)  // output wire [6 : 0] wr_data_count
);		
			
reg[16:0] user_ddr3_read_addr;		//DDR3读取地址
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_read_addr <= 17'd0;
	else if(lcd_ddr3_rfclr_r) user_ddr3_read_addr <= 17'd0;
	else if(cstate == SRDED) user_ddr3_read_addr <= user_ddr3_read_addr+1'b1;
	
////////////////////////////////////////////////////
//产生读写DDR3操作的状态
parameter SIDLE = 4'd0;
parameter SWRDB = 4'd1;
parameter SRDDB = 4'd2;
parameter SWRED = 4'd3;
parameter SRDED = 4'd4;
parameter SSTOP = 4'd5;
	
reg[3:0] nstate,cstate;
reg[9:0] num;
reg[9:0] wrnum;

always @(posedge clk or negedge rst_n)
	if(!rst_n) cstate <= SIDLE;
	else cstate <= nstate;

	//数据读写仲裁控制状态机
always @(cstate or rfifo_wr_data_count or wfifo_rd_data_count or num or wrnum) begin
	case(cstate)
		SIDLE: begin
			if((rfifo_wr_data_count < BURST_RD_128BIT) && !lcd_ddr3_rfclr_r) nstate <= SRDDB;		
			else if((wfifo_rd_data_count >= BURST_WR_128BIT) && !image_ddr3_clr_r) nstate <= SWRDB;
			else nstate <= SIDLE;
		end
		SWRDB: begin	//写数据
			if((wrnum > (BURST_WR_128BIT+1)) && (num > BURST_WR_128BIT)) nstate <= SWRED;
			else nstate <= SWRDB;
		end
		SWRED: nstate <= SSTOP;
		SRDDB: begin	//读数据
			if(num > BURST_RD_128BIT) nstate <= SRDED;
			else nstate <= SRDDB;
		end
		SRDED: nstate <= SSTOP;		
		SSTOP: nstate <= SIDLE;
		default: nstate <= SIDLE;
	endcase
end

////////////////////////////////////////////////////	
//读或写数据数量计数器

always @(posedge clk or negedge rst_n)
	if(!rst_n) num <= 10'd0;
	else if(cstate == SWRDB) begin
		if(app_rdy) num <= num+1'b1;
		else ;
	end
	else if(cstate == SRDDB) begin
		if(app_rdy) num <= num+1'b1;
		else ;
	end
	else num <= 10'd0;
	
////////////////////////////////////////////////////	
//写数据控制信号计数器

always @(posedge clk or negedge rst_n)
	if(!rst_n) wrnum <= 10'd0;
	else if(cstate == SWRDB) begin
		if(app_wdf_rdy) wrnum <= wrnum+1'b1;
		else ;
	end
	else wrnum <= 10'd0;	

always @(posedge clk or negedge rst_n)
	if(!rst_n) app_wdf_end <= 1'b0;
	else if(cstate == SWRDB) begin
		if(app_wdf_rdy && (wrnum <= BURST_WR_128BIT)) app_wdf_end <= 1'b1;
		else app_wdf_end <= 1'b0;
	end
	else app_wdf_end <= 1'b0;	
		
////////////////////////////////////////////////////
//读写数据控制时序产生
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
		app_cmd <= 3'd0;
		app_en <= 1'b0;
		app_addr <= 28'd0;		
	end
	else if(cstate == SWRDB) begin	//写DDR3
		app_cmd <= 3'b000;		
		
		if(app_rdy) begin										
			if(num < BURST_WR_128BIT) app_en <= 1'b1;
			else app_en <= 1'b0;
		end
		else ;
		
		//{app_addr[27:11],app_addr[2:0]} <= {user_ddr3_write_addr,3'd0};	
		//if(app_rdy) app_addr[10:3] <= num[7:0];		
		{app_addr[27:6],app_addr[2:0]} <= {user_ddr3_write_addr,3'd0};	
		if(app_rdy) app_addr[5:3] <= num[2:0];				
		else ;		
	end
	else if(cstate == SRDDB) begin	//读DDR3
		app_cmd <= 3'b001;

		if(app_rdy) begin		
			if(num < BURST_RD_128BIT) app_en <= 1'b1;	
			else app_en <= 1'b0;
		end
		else ;
		
		{app_addr[27:11],app_addr[2:0]} <= {user_ddr3_read_addr,3'd0};	
		if(app_rdy) app_addr[10:3] <= num[7:0];
		else ;			
	end
	else begin
		app_cmd <= 3'd0;
		app_en <= 1'b0;
		app_addr <= 28'd0;	
	end
	
	
////////////////////////////////////////////////////
//写数据控制时序产生
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) wfifo_rd_en <= 1'b0; 	
	else if((cstate == SWRDB) && app_wdf_rdy && (wrnum < BURST_WR_128BIT)) wfifo_rd_en <= 1'b1;
	else wfifo_rd_en <= 1'b0; 

	//写DDR3数据使能
always @(posedge clk or negedge rst_n)
	if(!rst_n) app_wdf_wren <= 1'b0;
	else if((cstate == SWRDB) && app_wdf_rdy && (wrnum > 10'd0) && (wrnum <= BURST_WR_128BIT)) app_wdf_wren <= 1'b1;
	else app_wdf_wren <= 1'b0;

assign app_wdf_data = wfifo_rd_data;


endmodule

