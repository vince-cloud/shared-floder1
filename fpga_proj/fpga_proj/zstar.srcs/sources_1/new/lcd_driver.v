/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module lcd_driver(	
				//系统时钟与复位信号
			input clk_25m,
			input clk_50m,
			input clk_65m,
			input clk_75m,
			input clk_108m,
			input clk_130m,
			input rst_n,
				//VGA驱动接口
			output[4:0] vga_r,
			output[5:0] vga_g,
			output[4:0] vga_b,
			output[2:0] vga_rgb,
			output reg vga_hsy,vga_vsy,
			output vga_clk,
			output adv7123_blank_n,
			output adv7123_sync_n,
				//LCD与FIFO的接口
			output lcd_synclk,	
			input[15:0] lcd_rfdb1,	//FIFO读出数据总线
			input[15:0] lcd_rfdb2,	//FIFO读出数据总线
			output reg lcd_rfreq1,		//FIFO读请求信号
			output reg lcd_rfreq2,		//FIFO读请求信号
			output reg lcd_rfclr		//FIFO复位信号，高电平有效
			);


//-----------------------------------------------------------
wire clk;
assign vga_clk = ~clk;
assign lcd_synclk = clk;
assign vga_rgb = 3'b000;

//-----------------------------------------------------------
//`define VGA_640_480
//`define VGA_800_600
//`define VGA_1024_768
`define VGA_1280_720
//`define VGA_1280_960
//`define VGA_1280_1024
//`define VGA_1920_1080

//-----------------------------------------------------------
`ifdef VGA_640_480
	//VGA Timing 640*480 & 25MHz & 60Hz
	assign clk = clk_25m;
		
	parameter VGA_HTT = 12'd800-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd96;		//Hor Sync  Time
	parameter VGA_HBP = 12'd48;//+12'd16;		//Hor Back Porch
	parameter VGA_HVT = 12'd640;	//Hor Valid Time
	parameter VGA_HFP = 12'd16;		//Hor Front Porch

	parameter VGA_VTT = 12'd525-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd2;		//Ver Sync Time
	parameter VGA_VBP = 12'd33;//-12'd4;		//Ver Back Porch
	parameter VGA_VVT = 12'd480;	//Ver Valid Time
	parameter VGA_VFP = 12'd10;		//Ver Front Porch
`endif

`ifdef VGA_800_600
	//VGA Timing 800*600 & 50MHz & 72Hz
	assign clk = clk_50m;

	parameter VGA_HTT = 12'd1040-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd120;		//Hor Sync  Time
	parameter VGA_HBP = 12'd64;		//Hor Back Porch
	parameter VGA_HVT = 12'd800;	//Hor Valid Time
	parameter VGA_HFP = 12'd56;		//Hor Front Porch

	parameter VGA_VTT = 12'd666-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd6;		//Ver Sync Time
	parameter VGA_VBP = 12'd23;		//Ver Back Porch
	parameter VGA_VVT = 12'd600;	//Ver Valid Time
	parameter VGA_VFP = 12'd37;		//Ver Front Porch
`endif

`ifdef VGA_1024_768
	//VGA Timing 1024*768 & 65MHz & 60Hz
	assign clk = clk_65m;

	parameter VGA_HTT = 12'd1344-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd136;		//Hor Sync  Time
	parameter VGA_HBP = 12'd160;		//Hor Back Porch
	parameter VGA_HVT = 12'd1024;	//Hor Valid Time
	parameter VGA_HFP = 12'd24;		//Hor Front Porch

	parameter VGA_VTT = 12'd806-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd6;		//Ver Sync Time
	parameter VGA_VBP = 12'd29;		//Ver Back Porch
	parameter VGA_VVT = 12'd768;	//Ver Valid Time
	parameter VGA_VFP = 12'd3;		//Ver Front Porch
`endif

`ifdef VGA_1280_720
	//VGA Timing 1280*720 & 75MHz & 60Hz
	assign clk = clk_75m;

	parameter VGA_HTT = 12'd1648-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd80;		//Hor Sync  Time
	parameter VGA_HBP = 12'd216;		//Hor Back Porch
	parameter VGA_HVT = 12'd1280;	//Hor Valid Time
	parameter VGA_HFP = 12'd72;		//Hor Front Porch

	parameter VGA_VTT = 12'd750-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd5;		//Ver Sync Time
	parameter VGA_VBP = 12'd22;		//Ver Back Porch
	parameter VGA_VVT = 12'd720;	//Ver Valid Time
	parameter VGA_VFP = 12'd3;		//Ver Front Porch
`endif

`ifdef VGA_1280_1024
	//VGA Timing 1280*960 & 108MHz & 60Hz
	assign clk = clk_108m;

	parameter VGA_HTT = 12'd1688-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd112;		//Hor Sync  Time
	parameter VGA_HBP = 12'd248;		//Hor Back Porch
	parameter VGA_HVT = 12'd1280;	//Hor Valid Time
	parameter VGA_HFP = 12'd48;		//Hor Front Porch

	parameter VGA_VTT = 12'd1066-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd3;		//Ver Sync Time
	parameter VGA_VBP = 12'd38;		//Ver Back Porch
	parameter VGA_VVT = 12'd1024;	//Ver Valid Time
	parameter VGA_VFP = 12'd1;		//Ver Front Porch
`endif

`ifdef VGA_1280_960
	//VGA Timing 1280*1024 & 108MHz & 60Hz
	assign clk = clk_108m;

	parameter VGA_HTT = 12'd1800-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd112;		//Hor Sync  Time
	parameter VGA_HBP = 12'd312;		//Hor Back Porch
	parameter VGA_HVT = 12'd1280;	//Hor Valid Time
	parameter VGA_HFP = 12'd96;		//Hor Front Porch

	parameter VGA_VTT = 12'd1000-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd3;		//Ver Sync Time
	parameter VGA_VBP = 12'd36;		//Ver Back Porch
	parameter VGA_VVT = 12'd960;	//Ver Valid Time
	parameter VGA_VFP = 12'd1;		//Ver Front Porch
`endif

`ifdef VGA_1920_1080
	//VGA Timing 1920*1080 & 130MHz & 60Hz
	assign clk = clk_130m;

	parameter VGA_HTT = 12'd2000-12'd1;	//Hor Total Time
	parameter VGA_HST = 12'd12;		//Hor Sync  Time
	parameter VGA_HBP = 12'd40;		//Hor Back Porch
	parameter VGA_HVT = 12'd1920;	//Hor Valid Time
	parameter VGA_HFP = 12'd28;		//Hor Front Porch

	parameter VGA_VTT = 12'd1105-12'd1;	//Ver Total Time
	parameter VGA_VST = 12'd4;		//Ver Sync Time
	parameter VGA_VBP = 12'd18;		//Ver Back Porch
	parameter VGA_VVT = 12'd1080;	//Ver Valid Time
	parameter VGA_VFP = 12'd3;		//Ver Front Porch
`endif

//-----------------------------------------------------------
	//x and y counter
reg[11:0] xcnt;
reg[11:0] ycnt;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) xcnt <= 12'd0;
	else if(xcnt >= VGA_HTT) xcnt <= 12'd0;
	else xcnt <= xcnt+1'b1;

always @(posedge clk or negedge rst_n)
	if(!rst_n) ycnt <= 12'd0;
	else if(xcnt == VGA_HTT) begin
		if(ycnt >= VGA_VTT) ycnt <= 12'd0;
		else ycnt <= ycnt+1'b1;
	end
	else ;
		
//-----------------------------------------------------------
	//hsy and vsy generate	
always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_hsy <= 1'b0;
	else if(xcnt < VGA_HST) vga_hsy <= 1'b1;
	else vga_hsy <= 1'b0;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_vsy <= 1'b0;
	else if(ycnt < VGA_VST) vga_vsy <= 1'b1;
	else vga_vsy <= 1'b0;	
	
//-----------------------------------------------------------	
	//vga valid signal generate
reg vga_valid;

always @(posedge clk or negedge rst_n)
	if(!rst_n) vga_valid <= 1'b0;
	else if((xcnt >= (VGA_HST+VGA_HBP)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT))
				&& (ycnt >= (VGA_VST+VGA_VBP)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT)))
		 vga_valid <= 1'b1;
	else vga_valid <= 1'b0;

assign adv7123_blank_n = vga_valid;
assign adv7123_sync_n = 1'b0;

//--------------------------------------------------
	//FIFO读请求信号和复位信号产生

always @(posedge clk or negedge rst_n)
	if(!rst_n) lcd_rfreq1 <= 1'b0;
	else if((xcnt >= (VGA_HST+VGA_HBP-2)) && (xcnt < (VGA_HST+VGA_HBP+640-2))
				&& (ycnt >= (VGA_VST+VGA_VBP+120)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT-120)))
		 lcd_rfreq1 <= 1'b1;
	else lcd_rfreq1 <= 1'b0;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) lcd_rfreq2 <= 1'b0;
	else if((xcnt >= (VGA_HST+VGA_HBP+640-2)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT-2))
				&& (ycnt >= (VGA_VST+VGA_VBP+120)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT-120)))
		 lcd_rfreq2 <= 1'b1;
	else lcd_rfreq2 <= 1'b0;	

always @(posedge clk or negedge rst_n)
	if(!rst_n) lcd_rfclr <= 1'b1;
	else if(ycnt == 12'd0) lcd_rfclr <= 1'b1;
	else lcd_rfclr <= 1'b0;

//-----------------------------------------------------------
	//display corlor generate
reg[4:0] vga_rdb;
reg[5:0] vga_gdb;
reg[4:0] vga_bdb;

reg[15:0] lcd_db_rgb;	// LCD色彩显示寄存器

always @ (posedge clk or negedge rst_n)
	if(!rst_n) {vga_rdb,vga_gdb,vga_bdb} <= 16'd0;
	else if((ycnt >= (VGA_VST+VGA_VBP)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT)) && (xcnt >= (VGA_HST+VGA_HBP-1)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT-1))) begin
		if((ycnt >= (VGA_VST+VGA_VBP+120)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT-120))) begin	
			if((xcnt >= (VGA_HST+VGA_HBP-1)) && (xcnt < (VGA_HST+VGA_HBP+640-1))) {vga_rdb,vga_gdb,vga_bdb} <= lcd_rfdb1;
			else if((xcnt >= (VGA_HST+VGA_HBP+640-1)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT-1))) {vga_rdb,vga_gdb,vga_bdb} <= lcd_rfdb2;		
			else {vga_rdb,vga_gdb,vga_bdb} <= 16'h0000;
		end
		else {vga_rdb,vga_gdb,vga_bdb} <= {5'h10,6'h20,5'h10};
	end
	else {vga_rdb,vga_gdb,vga_bdb} <= 16'd0;
	/*else if((ycnt >= (VGA_VST+VGA_VBP+120)) && (ycnt < (VGA_VST+VGA_VBP+VGA_VVT-120))) begin
		if((xcnt >= (VGA_HST+VGA_HBP-1)) && (xcnt < (VGA_HST+VGA_HBP+640-1))) {vga_rdb,vga_gdb,vga_bdb} <= lcd_rfdb1;
		else if((xcnt >= (VGA_HST+VGA_HBP+640-1)) && (xcnt < (VGA_HST+VGA_HBP+VGA_HVT-1))) {vga_rdb,vga_gdb,vga_bdb} <= lcd_rfdb2;
		else {vga_rdb,vga_gdb,vga_bdb} <= 16'd0;
	end
	else {vga_rdb,vga_gdb,vga_bdb} <= 16'd0;*/

//-----------------------------------------------------------
	//corlor data and clock generate
assign vga_r = vga_valid ? vga_rdb:5'd0;
assign vga_g = vga_valid ? vga_gdb:6'd0;	
assign vga_b = vga_valid ? vga_bdb:5'd0;	


endmodule

