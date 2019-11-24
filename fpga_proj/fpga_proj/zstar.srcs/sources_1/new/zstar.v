`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
//特权同学 精心打造 Xilinx Zynq FPGA开发板系列
//工程硬件平台： Xilinx Zynq FPGA 
//开发套件型号： Zstar FPGA开发套件
//版   权  申   明： 本例程由《深入浅出玩转FPGA》作者“特权同学”原创，
//				仅供Zstar开发套件学习使用，谢谢支持
//官方淘宝店铺： http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module zstar(
	inout [14:0]DDR_addr,
	inout [2:0]DDR_ba,
	inout DDR_cas_n,
	inout DDR_ck_n,
	inout DDR_ck_p,
	inout DDR_cke,
	inout DDR_cs_n,
	inout [3:0]DDR_dm,
	inout [31:0]DDR_dq,
	inout [3:0]DDR_dqs_n,
	inout [3:0]DDR_dqs_p,
	inout DDR_odt,
	inout DDR_ras_n,
	inout DDR_reset_n,
	inout DDR_we_n,  
		//ImageSensor图像接口
	output image_sensor_xclk,	//输出时钟
	input image_sensor_pclk,	//视频时钟
	input image_sensor_vsync,	//视频场同步信号，高电平有效（有效视频传输时该信号拉低）
	input image_sensor_href,	//视频行同步信号
	input[7:0] image_sensor_data,	//视频数据总线
	output image_sensor_scl,	//串行配置IIC时钟信号
	inout image_sensor_sda,		//串行配置IIC数据信号	
	output image_sensor_reset_n,	//复位接口，低电平有效
	output image_sensor_pwdn,	//低功耗使能信号，高电平有效	
		//ImageSensor2图像接口
	output image2_sensor_xclk,	//输出时钟
	input image2_sensor_pclk,	//视频时钟
	input image2_sensor_vsync,	//视频场同步信号，高电平有效（有效视频传输时该信号拉低）
	input image2_sensor_href,	//视频行同步信号
	input[7:0] image2_sensor_data,	//视频数据总线
	output image2_sensor_scl,	//串行配置IIC时钟信号
	inout image2_sensor_sda,		//串行配置IIC数据信号	
	output image2_sensor_reset_n,	//复位接口，低电平有效
	output image2_sensor_pwdn,	//低功耗使能信号，高电平有效	
		//VGA驱动接口
	output[4:0] vga_r,
	output[5:0] vga_g,
	output[4:0] vga_b,
	output[2:0] vga_rgb,
	output vga_hsy,vga_vsy,
	output vga_clk,
	output adv7123_blank_n,
	output adv7123_sync_n,			
		//LED指示灯接口
	output[0:0] led		//用于测试的LED指示灯	  
    );
	  
wire clk_25m;
wire clk_50m;
wire clk_100m;  
wire clk_75m;
wire sys_rst_n;
  
wire AXI_HP0_ACLK;
wire [31:0]AXI_HP0_araddr;
wire [1:0]AXI_HP0_arburst;
wire [3:0]AXI_HP0_arcache;
wire [5:0]AXI_HP0_arid;
wire [3:0]AXI_HP0_arlen;
wire [1:0]AXI_HP0_arlock;
wire [2:0]AXI_HP0_arprot;
wire [3:0]AXI_HP0_arqos;
wire AXI_HP0_arready;
wire [2:0]AXI_HP0_arsize;
wire AXI_HP0_arvalid;
wire [31:0]AXI_HP0_awaddr;
wire [1:0]AXI_HP0_awburst;
wire [3:0]AXI_HP0_awcache;
wire [5:0]AXI_HP0_awid;
wire [3:0]AXI_HP0_awlen;
wire [1:0]AXI_HP0_awlock;
wire [2:0]AXI_HP0_awprot;
wire [3:0]AXI_HP0_awqos;
wire AXI_HP0_awready;
wire [2:0]AXI_HP0_awsize;
wire AXI_HP0_awvalid;
wire [5:0]AXI_HP0_bid;
wire AXI_HP0_bready;
wire [1:0]AXI_HP0_bresp;
wire AXI_HP0_bvalid;
wire [63:0]AXI_HP0_rdata;
wire [5:0]AXI_HP0_rid;
wire AXI_HP0_rlast;
wire AXI_HP0_rready;
wire [1:0]AXI_HP0_rresp;
wire AXI_HP0_rvalid;
wire [63:0]AXI_HP0_wdata;
wire [5:0]AXI_HP0_wid;
wire AXI_HP0_wlast;
wire AXI_HP0_wready;
wire [7:0]AXI_HP0_wstrb;
wire AXI_HP0_wvalid;	

wire AXI_HP1_ACLK;
wire [31:0]AXI_HP1_araddr;
wire [1:0]AXI_HP1_arburst;
wire [3:0]AXI_HP1_arcache;
wire [5:0]AXI_HP1_arid;
wire [3:0]AXI_HP1_arlen;
wire [1:0]AXI_HP1_arlock;
wire [2:0]AXI_HP1_arprot;
wire [3:0]AXI_HP1_arqos;
wire AXI_HP1_arready;
wire [2:0]AXI_HP1_arsize;
wire AXI_HP1_arvalid;
wire [31:0]AXI_HP1_awaddr;
wire [1:0]AXI_HP1_awburst;
wire [3:0]AXI_HP1_awcache;
wire [5:0]AXI_HP1_awid;
wire [3:0]AXI_HP1_awlen;
wire [1:0]AXI_HP1_awlock;
wire [2:0]AXI_HP1_awprot;
wire [3:0]AXI_HP1_awqos;
wire AXI_HP1_awready;
wire [2:0]AXI_HP1_awsize;
wire AXI_HP1_awvalid;
wire [5:0]AXI_HP1_bid;
wire AXI_HP1_bready;
wire [1:0]AXI_HP1_bresp;
wire AXI_HP1_bvalid;
wire [63:0]AXI_HP1_rdata;
wire [5:0]AXI_HP1_rid;
wire AXI_HP1_rlast;
wire AXI_HP1_rready;
wire [1:0]AXI_HP1_rresp;
wire AXI_HP1_rvalid;
wire [63:0]AXI_HP1_wdata;
wire [5:0]AXI_HP1_wid;
wire AXI_HP1_wlast;
wire AXI_HP1_wready;
wire [7:0]AXI_HP1_wstrb;
wire AXI_HP1_wvalid;

assign AXI_HP0_awid = 6'b00_0001;
assign AXI_HP0_wid 	= 6'b00_0001;
assign AXI_HP0_arid = 6'b00_0001;

assign AXI_HP1_awid = 6'b00_0010;
assign AXI_HP1_wid 	= 6'b00_0010;
assign AXI_HP1_arid = 6'b00_0010;

assign AXI_HP0_ACLK = clk_100m;
assign AXI_HP1_ACLK = clk_100m;

assign image_sensor_xclk = clk_25m;
assign image2_sensor_xclk = clk_25m;


//////////////////////////////////////////////////////////////////////////////////
//PS系统

  zstar_zynq_ps 	u1_zstar_zynq_ps_i(
        .AXI_HP0_ACLK(AXI_HP0_ACLK),
        .AXI_HP0_araddr(AXI_HP0_araddr),
        .AXI_HP0_arburst(AXI_HP0_arburst),
        .AXI_HP0_arcache(AXI_HP0_arcache),
        .AXI_HP0_arid(AXI_HP0_arid),
        .AXI_HP0_arlen(AXI_HP0_arlen),
        .AXI_HP0_arlock(AXI_HP0_arlock),
        .AXI_HP0_arprot(AXI_HP0_arprot),
        .AXI_HP0_arqos(AXI_HP0_arqos),
        .AXI_HP0_arready(AXI_HP0_arready),
        .AXI_HP0_arsize(AXI_HP0_arsize),
        .AXI_HP0_arvalid(AXI_HP0_arvalid),
        .AXI_HP0_awaddr(AXI_HP0_awaddr),
        .AXI_HP0_awburst(AXI_HP0_awburst),
        .AXI_HP0_awcache(AXI_HP0_awcache),
        .AXI_HP0_awid(AXI_HP0_awid),
        .AXI_HP0_awlen(AXI_HP0_awlen),
        .AXI_HP0_awlock(AXI_HP0_awlock),
        .AXI_HP0_awprot(AXI_HP0_awprot),
        .AXI_HP0_awqos(AXI_HP0_awqos),
        .AXI_HP0_awready(AXI_HP0_awready),
        .AXI_HP0_awsize(AXI_HP0_awsize),
        .AXI_HP0_awvalid(AXI_HP0_awvalid),
        .AXI_HP0_bid(AXI_HP0_bid),
        .AXI_HP0_bready(AXI_HP0_bready),
        .AXI_HP0_bresp(AXI_HP0_bresp),
        .AXI_HP0_bvalid(AXI_HP0_bvalid),
        .AXI_HP0_rdata(AXI_HP0_rdata),
        .AXI_HP0_rid(AXI_HP0_rid),
        .AXI_HP0_rlast(AXI_HP0_rlast),
        .AXI_HP0_rready(AXI_HP0_rready),
        .AXI_HP0_rresp(AXI_HP0_rresp),
        .AXI_HP0_rvalid(AXI_HP0_rvalid),
        .AXI_HP0_wdata(AXI_HP0_wdata),
        .AXI_HP0_wid(AXI_HP0_wid),
        .AXI_HP0_wlast(AXI_HP0_wlast),
        .AXI_HP0_wready(AXI_HP0_wready),
        .AXI_HP0_wstrb(AXI_HP0_wstrb),
        .AXI_HP0_wvalid(AXI_HP0_wvalid),		
        .AXI_HP1_ACLK(AXI_HP1_ACLK),
        .AXI_HP1_araddr(AXI_HP1_araddr),
        .AXI_HP1_arburst(AXI_HP1_arburst),
        .AXI_HP1_arcache(AXI_HP1_arcache),
        .AXI_HP1_arid(AXI_HP1_arid),
        .AXI_HP1_arlen(AXI_HP1_arlen),
        .AXI_HP1_arlock(AXI_HP1_arlock),
        .AXI_HP1_arprot(AXI_HP1_arprot),
        .AXI_HP1_arqos(AXI_HP1_arqos),
        .AXI_HP1_arready(AXI_HP1_arready),
        .AXI_HP1_arsize(AXI_HP1_arsize),
        .AXI_HP1_arvalid(AXI_HP1_arvalid),
        .AXI_HP1_awaddr(AXI_HP1_awaddr),
        .AXI_HP1_awburst(AXI_HP1_awburst),
        .AXI_HP1_awcache(AXI_HP1_awcache),
        .AXI_HP1_awid(AXI_HP1_awid),
        .AXI_HP1_awlen(AXI_HP1_awlen),
        .AXI_HP1_awlock(AXI_HP1_awlock),
        .AXI_HP1_awprot(AXI_HP1_awprot),
        .AXI_HP1_awqos(AXI_HP1_awqos),
        .AXI_HP1_awready(AXI_HP1_awready),
        .AXI_HP1_awsize(AXI_HP1_awsize),
        .AXI_HP1_awvalid(AXI_HP1_awvalid),
        .AXI_HP1_bid(AXI_HP1_bid),
        .AXI_HP1_bready(AXI_HP1_bready),
        .AXI_HP1_bresp(AXI_HP1_bresp),
        .AXI_HP1_bvalid(AXI_HP1_bvalid),
        .AXI_HP1_rdata(AXI_HP1_rdata),
        .AXI_HP1_rid(AXI_HP1_rid),
        .AXI_HP1_rlast(AXI_HP1_rlast),
        .AXI_HP1_rready(AXI_HP1_rready),
        .AXI_HP1_rresp(AXI_HP1_rresp),
        .AXI_HP1_rvalid(AXI_HP1_rvalid),
        .AXI_HP1_wdata(AXI_HP1_wdata),
        .AXI_HP1_wid(AXI_HP1_wid),
        .AXI_HP1_wlast(AXI_HP1_wlast),
        .AXI_HP1_wready(AXI_HP1_wready),
        .AXI_HP1_wstrb(AXI_HP1_wstrb),
        .AXI_HP1_wvalid(AXI_HP1_wvalid),	
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
		.FCLK_CLK_25M(clk_25m),
		.FCLK_CLK_50M(clk_50m),
        .FCLK_CLK_100M(clk_100m),
		.FCLK_CLK_75M(clk_75m),
        .FCLK_RESET_N(sys_rst_n)
	);	

//////////////////////////////////////////////////////////////////////////////////
//ImageSensor图像采集控制模块
	//ImageSensor数据写入DDR3接口
wire image_ddr3_wren;
wire image_ddr3_line_end;
wire image_ddr3_clr;
wire[15:0] image_ddr3_wrdb;
wire image_ddr3_wready;
wire image_ddr3_frame_start;
wire image_ddr3_frame_end;

image_controller	u2_image_controller(
			.clk(clk_50m),	//时钟信号
			.rst_n(sys_rst_n),	//复位信号
				//ImageSensor图像采集接口
			.image_sensor_pclk(image_sensor_pclk),
			.image_sensor_vsync(~image_sensor_vsync),
			.image_sensor_href(image_sensor_href),
			.image_sensor_data(image_sensor_data),
				//ImageSensor串行配置接口
			.image_sensor_scl(image_sensor_scl),
			.image_sensor_sda(image_sensor_sda),	
				//ImageSensor复位与低功耗接口
			.image_sensor_reset_n(image_sensor_reset_n),
			.image_sensor_pwdn(image_sensor_pwdn),
				//ImageSensor数据写入DDR3接口
			.image_ddr3_wready(image_ddr3_wready),	
			.image_ddr3_wren(image_ddr3_wren),
			.image_ddr3_wrdb(image_ddr3_wrdb),	
			.image_ddr3_line_end(image_ddr3_line_end),
			.image_ddr3_frame_start(image_ddr3_frame_start),
			.image_ddr3_frame_end(image_ddr3_frame_end),
			.image_ddr3_clr(image_ddr3_clr)		
		);		
	 
//////////////////////////////////////////////////////////////////////////////////
//Bayer2RGB处理模块
wire w_rgb_image_rst;
wire w_rgb_image_vld;
wire[23:0] w_rgb_image_data;		

bayer2rgb			u3_bayer2rgb(		 
						.clk(clk_50m),
						.rst_n(sys_rst_n),
						//input Image Data Flow
						.i_bayer_image_vld(image_ddr3_wren),
						.o_bayer_image_tready(image_ddr3_wready),
						.i_bayer_image_data(image_ddr3_wrdb[7:0]),	
						.i_bayer_image_sof(image_ddr3_frame_start),
						.i_bayer_image_eof(image_ddr3_frame_end),
						.i_bayer_image_eol(image_ddr3_line_end),
						//output Image Data Flow
						.o_rgb_image_rst(w_rgb_image_rst),
						.o_rgb_image_vld(w_rgb_image_vld),
						.o_rgb_image_data(w_rgb_image_data)
					);			
		
//////////////////////////////////////////////////////////////////////////////////
//AXI HP0主机--写
	
axi_hp0_wr	#(
				.STAR_ADDR(32'h0100_0000))
		u4_axi_hp0_wr(
		 // Outputs
		 .AXI_awaddr	(AXI_HP0_awaddr[31:0]),
		 .AXI_awlen		(AXI_HP0_awlen[3:0]),
		 .AXI_awsize	(AXI_HP0_awsize[2:0]),
		 .AXI_awburst	(AXI_HP0_awburst[1:0]),
		 .AXI_awlock	(AXI_HP0_awlock[1:0]),
		 .AXI_awcache	(AXI_HP0_awcache[3:0]),
		 .AXI_awprot	(AXI_HP0_awprot[2:0]),
		 .AXI_awqos		(AXI_HP0_awqos[3:0]),
		 .AXI_awvalid	(AXI_HP0_awvalid),
		 .AXI_wdata		(AXI_HP0_wdata[63:0]),
		 .AXI_wstrb		(AXI_HP0_wstrb[7:0]),
		 .AXI_wlast		(AXI_HP0_wlast),
		 .AXI_wvalid	(AXI_HP0_wvalid),
		 .AXI_bready	(AXI_HP0_bready),
		 // Inputs
		 .rst_n			(sys_rst_n),
		 .i_clk			(clk_50m),
		 .i_data_rst_n	(~image_ddr3_clr),
		 .i_data_en		(w_rgb_image_vld),
		 .i_data		({w_rgb_image_data[23:19],w_rgb_image_data[7:2],w_rgb_image_data[15:11]}),
		 .AXI_clk		(AXI_HP0_ACLK),
		 .AXI_awready	(AXI_HP0_awready),
		 .AXI_wready	(AXI_HP0_wready),
		 .AXI_bid		(AXI_HP0_bid[5:0]),
		 .AXI_bresp		(AXI_HP0_bresp[1:0]),
		 .AXI_bvalid	(AXI_HP0_bvalid)
	); 	

//////////////////////////////////////////////////////////////////////////////////		
//ImageSensor图像增强处理
	//ImageSensor数据写入DDR3接口
wire w_gamma_image_vld;
wire[23:0] w_gamma_image_data;	
		
gamma_correction	u5_gamma_correction(
		 // Outputs
		 .o_gamma_image_vld	(w_gamma_image_vld),
		 .o_gamma_image_data	(w_gamma_image_data[23:0]),
		 // Inputs
		 .clk			(clk_50m),
		 .rst_n			(sys_rst_n),
		 //.i_rgb_image_rst	(w_rgb_image_rst),
		 .i_rgb_image_vld	(w_rgb_image_vld),
		 .i_rgb_image_data	(w_rgb_image_data[23:0])
	);					
		 					
		//Gamma图像laplace transform锐化处理
	//Gamma数据写入DDR3接口
wire image2_ddr3_wren;
wire[15:0] image2_ddr3_wrdb;

laplace_transform		uut_laplace_transform(		
		 // Outputs
		 .o_image_ddr3_wren		(image2_ddr3_wren),
		 .o_image_ddr3_wrdb_modify		(image2_ddr3_wrdb),
		 // Inputs
		 .clk					(clk_50m),
		 .rst_n					(sys_rst_n),
		 .i_image_ddr3_wren		(w_gamma_image_vld),
		 .i_image_ddr3_line_end	(image_ddr3_line_end),
		 .i_image_ddr3_clr		(image_ddr3_clr),
		 .i_image_ddr3_wrdb		({w_gamma_image_data[23:19],w_gamma_image_data[7:2],w_gamma_image_data[15:11]}));	
		 
//////////////////////////////////////////////////////////////////////////////////
//AXI HP1主机--写
	
axi_hp0_wr	#(
				.STAR_ADDR(32'h0200_0000))
		u6_axi_hp1_wr(
		 // Outputs
		 .AXI_awaddr	(AXI_HP1_awaddr[31:0]),
		 .AXI_awlen		(AXI_HP1_awlen[3:0]),
		 .AXI_awsize	(AXI_HP1_awsize[2:0]),
		 .AXI_awburst	(AXI_HP1_awburst[1:0]),
		 .AXI_awlock	(AXI_HP1_awlock[1:0]),
		 .AXI_awcache	(AXI_HP1_awcache[3:0]),
		 .AXI_awprot	(AXI_HP1_awprot[2:0]),
		 .AXI_awqos		(AXI_HP1_awqos[3:0]),
		 .AXI_awvalid	(AXI_HP1_awvalid),
		 .AXI_wdata		(AXI_HP1_wdata[63:0]),
		 .AXI_wstrb		(AXI_HP1_wstrb[7:0]),
		 .AXI_wlast		(AXI_HP1_wlast),
		 .AXI_wvalid	(AXI_HP1_wvalid),
		 .AXI_bready	(AXI_HP1_bready),
		 // Inputs
		 .rst_n			(sys_rst_n),
		 .i_clk			(clk_50m),
		 .i_data_rst_n	(~image_ddr3_clr),
		 .i_data_en		(image2_ddr3_wren),
		 .i_data		(image2_ddr3_wrdb[15:0]),
		 .AXI_clk		(AXI_HP1_ACLK),
		 .AXI_awready	(AXI_HP1_awready),
		 .AXI_wready	(AXI_HP1_wready),
		 .AXI_bid		(AXI_HP1_bid[5:0]),
		 .AXI_bresp		(AXI_HP1_bresp[1:0]),
		 .AXI_bvalid	(AXI_HP1_bvalid)
	);	

//////////////////////////////////////////////////////////////////////////////////
//液晶显示驱动模块
wire lcd_synclk;		//LCD驱动模块同步时钟
wire[15:0] lcd_rfdb1;	//输出到LCD模块待显示的DDR3读出数据
wire[15:0] lcd_rfdb2;	//输出到LCD模块待显示的DDR3读出数据
wire lcd_rfreq1;		//LCD模块发出的读FIFO请求信号，高电平有效
wire lcd_rfreq2;		//LCD模块发出的读FIFO请求信号，高电平有效
wire lcd_rfclr;		//LCD模块发出的读FIFO复位，低电平有效	
	
lcd_driver		u7_lcd_driver(	
					.clk_25m(clk_25m),
					.clk_50m(clk_50m),
					.clk_65m(),
					.clk_75m(clk_75m),
					.clk_108m(),
					.clk_130m(),
					.rst_n(sys_rst_n),
					.vga_r(vga_r),
					.vga_g(vga_g),
					.vga_b(vga_b),
					.vga_rgb(vga_rgb),
					.vga_hsy(vga_hsy),
					.vga_vsy(vga_vsy),
					.vga_clk(vga_clk),
					.adv7123_blank_n(adv7123_blank_n),
					.adv7123_sync_n(adv7123_sync_n),
					.lcd_synclk(lcd_synclk),
					.lcd_rfdb1(lcd_rfdb1),
					.lcd_rfdb2(lcd_rfdb2),					
					.lcd_rfreq1(lcd_rfreq1),
					.lcd_rfreq2(lcd_rfreq2),
					.lcd_rfclr(lcd_rfclr)		
					);			
		
//////////////////////////////////////////////////////////////////////////////////HP0 READ
//AXI HP0主机--读

axi_hp0_rd	#(
				.STAR_ADDR(32'h0100_0000))
		u8_axi_hp0_rd(
		// Outputs
		.AXI_araddr		(AXI_HP0_araddr),
		.AXI_arburst	(AXI_HP0_arburst),
		.AXI_arcache	(AXI_HP0_arcache),			
		.AXI_arlen		(AXI_HP0_arlen),
		.AXI_arlock		(AXI_HP0_arlock),
		.AXI_arprot		(AXI_HP0_arprot),
		.AXI_arqos		(AXI_HP0_arqos),
		.AXI_arsize		(AXI_HP0_arsize),
		.AXI_arvalid	(AXI_HP0_arvalid),
		.AXI_rready		(AXI_HP0_rready),
		 // Inputs
		.rst_n			(sys_rst_n),
		.i_clk			(lcd_synclk),
		.i_data_rst_n	(~lcd_rfclr),
		.i_data_rden	(lcd_rfreq1),
		.o_data			(lcd_rfdb1),
		.AXI_clk		(AXI_HP0_ACLK),
		.AXI_arready	(AXI_HP0_arready),		
		.AXI_rdata		(AXI_HP0_rdata),
		.AXI_rid		(AXI_HP0_rid),
		.AXI_rlast		(AXI_HP0_rlast),		
		.AXI_rresp		(AXI_HP0_rresp),
		.AXI_rvalid		(AXI_HP0_rvalid)				
		);
		
//////////////////////////////////////////////////////////////////////////////////HP1 READ
//AXI HP1主机--读

axi_hp0_rd	#(
				.STAR_ADDR(32'h0200_0000))
		u9_axi_hp1_rd(
		// Outputs
		.AXI_araddr		(AXI_HP1_araddr),
		.AXI_arburst	(AXI_HP1_arburst),
		.AXI_arcache	(AXI_HP1_arcache),			
		.AXI_arlen		(AXI_HP1_arlen),
		.AXI_arlock		(AXI_HP1_arlock),
		.AXI_arprot		(AXI_HP1_arprot),
		.AXI_arqos		(AXI_HP1_arqos),
		.AXI_arsize		(AXI_HP1_arsize),
		.AXI_arvalid	(AXI_HP1_arvalid),
		.AXI_rready		(AXI_HP1_rready),
		 // Inputs
		.rst_n			(sys_rst_n),
		.i_clk			(lcd_synclk),
		.i_data_rst_n	(~lcd_rfclr),
		.i_data_rden	(lcd_rfreq2),
		.o_data			(lcd_rfdb2),
		.AXI_clk		(AXI_HP1_ACLK),
		.AXI_arready	(AXI_HP1_arready),		
		.AXI_rdata		(AXI_HP1_rdata),
		.AXI_rid		(AXI_HP1_rid),
		.AXI_rlast		(AXI_HP1_rlast),		
		.AXI_rresp		(AXI_HP1_rresp),
		.AXI_rvalid		(AXI_HP1_rvalid)				
		);
		
		
//////////////////////////////////////////////////////////////////////////////////
//LED闪烁逻辑产生模块例化

led_controller		u10_led_controller(
						.clk(clk_25m),			
						.rst_n(sys_rst_n),
						.led(led[0])
					);			
	
		
endmodule

