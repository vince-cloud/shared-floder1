`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
//��Ȩͬѧ ���Ĵ��� Xilinx Zynq FPGA������ϵ��
//����Ӳ��ƽ̨�� Xilinx Zynq FPGA 
//�����׼��ͺţ� Zstar FPGA�����׼�
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����Zstar�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
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
		//ImageSensorͼ��ӿ�
	output image_sensor_xclk,	//���ʱ��
	input image_sensor_pclk,	//��Ƶʱ��
	input image_sensor_vsync,	//��Ƶ��ͬ���źţ��ߵ�ƽ��Ч����Ч��Ƶ����ʱ���ź����ͣ�
	input image_sensor_href,	//��Ƶ��ͬ���ź�
	input[7:0] image_sensor_data,	//��Ƶ��������
	output image_sensor_scl,	//��������IICʱ���ź�
	inout image_sensor_sda,		//��������IIC�����ź�	
	output image_sensor_reset_n,	//��λ�ӿڣ��͵�ƽ��Ч
	output image_sensor_pwdn,	//�͹���ʹ���źţ��ߵ�ƽ��Ч	
		//ImageSensor2ͼ��ӿ�
	output image2_sensor_xclk,	//���ʱ��
	input image2_sensor_pclk,	//��Ƶʱ��
	input image2_sensor_vsync,	//��Ƶ��ͬ���źţ��ߵ�ƽ��Ч����Ч��Ƶ����ʱ���ź����ͣ�
	input image2_sensor_href,	//��Ƶ��ͬ���ź�
	input[7:0] image2_sensor_data,	//��Ƶ��������
	output image2_sensor_scl,	//��������IICʱ���ź�
	inout image2_sensor_sda,		//��������IIC�����ź�	
	output image2_sensor_reset_n,	//��λ�ӿڣ��͵�ƽ��Ч
	output image2_sensor_pwdn,	//�͹���ʹ���źţ��ߵ�ƽ��Ч	
		//VGA�����ӿ�
	output[4:0] vga_r,
	output[5:0] vga_g,
	output[4:0] vga_b,
	output[2:0] vga_rgb,
	output vga_hsy,vga_vsy,
	output vga_clk,
	output adv7123_blank_n,
	output adv7123_sync_n,			
		//LEDָʾ�ƽӿ�
	output[0:0] led		//���ڲ��Ե�LEDָʾ��	  
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
//PSϵͳ

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
//ImageSensorͼ��ɼ�����ģ��
	//ImageSensor����д��DDR3�ӿ�
wire image_ddr3_wren;
wire image_ddr3_line_end;
wire image_ddr3_clr;
wire[15:0] image_ddr3_wrdb;
wire image_ddr3_wready;
wire image_ddr3_frame_start;
wire image_ddr3_frame_end;

image_controller	u2_image_controller(
			.clk(clk_50m),	//ʱ���ź�
			.rst_n(sys_rst_n),	//��λ�ź�
				//ImageSensorͼ��ɼ��ӿ�
			.image_sensor_pclk(image_sensor_pclk),
			.image_sensor_vsync(~image_sensor_vsync),
			.image_sensor_href(image_sensor_href),
			.image_sensor_data(image_sensor_data),
				//ImageSensor�������ýӿ�
			.image_sensor_scl(image_sensor_scl),
			.image_sensor_sda(image_sensor_sda),	
				//ImageSensor��λ��͹��Ľӿ�
			.image_sensor_reset_n(image_sensor_reset_n),
			.image_sensor_pwdn(image_sensor_pwdn),
				//ImageSensor����д��DDR3�ӿ�
			.image_ddr3_wready(image_ddr3_wready),	
			.image_ddr3_wren(image_ddr3_wren),
			.image_ddr3_wrdb(image_ddr3_wrdb),	
			.image_ddr3_line_end(image_ddr3_line_end),
			.image_ddr3_frame_start(image_ddr3_frame_start),
			.image_ddr3_frame_end(image_ddr3_frame_end),
			.image_ddr3_clr(image_ddr3_clr)		
		);		
	 
//////////////////////////////////////////////////////////////////////////////////
//Bayer2RGB����ģ��
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
//AXI HP0����--д
	
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
//ImageSensorͼ����ǿ����
	//ImageSensor����д��DDR3�ӿ�
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
		 					
		//Gammaͼ��laplace transform�񻯴���
	//Gamma����д��DDR3�ӿ�
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
//AXI HP1����--д
	
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
//Һ����ʾ����ģ��
wire lcd_synclk;		//LCD����ģ��ͬ��ʱ��
wire[15:0] lcd_rfdb1;	//�����LCDģ�����ʾ��DDR3��������
wire[15:0] lcd_rfdb2;	//�����LCDģ�����ʾ��DDR3��������
wire lcd_rfreq1;		//LCDģ�鷢���Ķ�FIFO�����źţ��ߵ�ƽ��Ч
wire lcd_rfreq2;		//LCDģ�鷢���Ķ�FIFO�����źţ��ߵ�ƽ��Ч
wire lcd_rfclr;		//LCDģ�鷢���Ķ�FIFO��λ���͵�ƽ��Ч	
	
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
//AXI HP0����--��

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
//AXI HP1����--��

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
//LED��˸�߼�����ģ������

led_controller		u10_led_controller(
						.clk(clk_25m),			
						.rst_n(sys_rst_n),
						.led(led[0])
					);			
	
		
endmodule

