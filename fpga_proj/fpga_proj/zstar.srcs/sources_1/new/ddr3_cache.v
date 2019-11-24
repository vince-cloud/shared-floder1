/////////////////////////////////////////////////////////////////////////////
//��Ȩͬѧ Я�� ������V3ѧԺ ���Ĵ��� Xilinx FPGA������ϵ��
//����Ӳ��ƽ̨�� Xilinx Artix7 FPGA 
//�����׼��ͺţ� STAR ����FPGA�����׼�
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����STAR�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
//�����������أ� http://pan.baidu.com/s/1kU4WWvH
/////////////////////////////////////////////////////////////////////////////
module ddr3_cache(
				//DDR3������IP���û��ӿ��źţ�ʱ���븴λ
			input clk,	//ʱ���źţ���DDR3ʱ�ӣ�400MHz����1/4����100MHz
			input clk_33m,	//LCD����ʱ��33MHz
			input rst_n,	//��λ�ź�
			
			//DDR3 Controller IP�ӿ�
				//DDR3������IP���û��ӿ��źţ������ź�
			(*mark_debug = "true"*) output reg[27:0] app_addr,	//DDR3��ַ����
			output reg[2:0] app_cmd,		//DDR3�������ߣ�3��b000--д��3'b001--����3��b011--wr_bytes��With ECC enabled, the wr_bytes operation is required for writes with any non-zero app_wdf_mask bits.��
			(*mark_debug = "true"*) output reg app_en,	//DDR3���������źţ��ߵ�ƽ��Ч
			(*mark_debug = "true"*) input app_rdy,	//DDR3������Ӧ�źţ���ʾ��ǰ��app_en�����Ѿ������Ӧ�����Լ�������
				//DDR3������IP���û��ӿ��źţ�д�����ź�
			output[127:0] app_wdf_data,	//DDR3д����������
			(*mark_debug = "true"*) output reg app_wdf_end,	//DDR3���һ���ֽ�д��ָʾ�źţ���app_wdf_dataͬ��ָʾ��ǰ����Ϊ���һ������д��
			(*mark_debug = "true"*) output reg app_wdf_wren,	//DDR3д������ʹ���źţ���ʾ��ǰд��������Ч
			(*mark_debug = "true"*) input app_wdf_rdy,	//DDR3����ִ��д�����ݲ��������ź����߱�ʾд����FIFO�Ѿ�׼���ý�������
				//DDR3������IP���û��ӿ��źţ��������ź�
			input[127:0] app_rd_data,	//DDR3��ȡ��������
			(*mark_debug = "true"*) input app_rd_data_end,	//DDR3����һ���ֽڶ�ȡָʾ�źţ���app_rd_dataͬ��ָʾ��ǰ����Ϊ���һ�����ݶ���
			(*mark_debug = "true"*) input app_rd_data_valid,	//DDR3��������ʹ���źţ���ʾ��ǰ����������Ч
			
				//ImageSensor����д��DDR3�ӿ�
			input image_pclk,
			input image_ddr3_wren,
			input image_ddr3_clr,
			input[15:0] image_ddr3_wrdb,
			
				//LCDģ���DDR3���ݽӿ�
			(*mark_debug = "true"*) output[15:0] lcd_ddr3_rfdb,	//�����LCDģ�����ʾ��DDR3��������
			(*mark_debug = "true"*) input lcd_ddr3_rfreq,		//LCDģ�鷢���Ķ�FIFO�����źţ��ߵ�ƽ��Ч
			(*mark_debug = "true"*) input lcd_ddr3_rfclr		//LCDģ�鷢���Ķ�FIFO��λ���͵�ƽ��Ч
			
		);
		
////////////////////////////////////////////////////
//DDR3�ĵ��β�����������32*128bit = 256*16bit����
parameter BURST_WR_128BIT = 10'd8;//10'd256;	//burstд��������
parameter BURST_RD_128BIT = 10'd256;	//burst����������		

////////////////////////////////////////////////////
//image_ddr3_clrͬ����clkʱ����
wire image_ddr3_clr_r;

register_diff_clk		register_diff_clk_dc1(
							.clk(clk),		
							.rst_n(rst_n),	
							.in_a(image_ddr3_clr),
							.out_b(image_ddr3_clr_r)	
						);

////////////////////////////////////////////////////
//д����FIFO
//����FIFO���ݴ����32*128bitʱ�ͷ���дDDR3����	
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
reg[16:0] user_ddr3_write_addr;	//DDR3д���ַ
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_write_addr <= 17'd0;
	else if(image_ddr3_clr_r) user_ddr3_write_addr <= 17'd0;
	else if(cstate == SWRED) user_ddr3_write_addr <= user_ddr3_write_addr+1'b1;		
*/
reg[21:0] user_ddr3_write_addr;	//DDR3д���ַ
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_write_addr <= 22'd0;
	else if(image_ddr3_clr_r) user_ddr3_write_addr <= 22'd0;
	else if(cstate == SWRED) user_ddr3_write_addr <= user_ddr3_write_addr+1'b1;	
	
////////////////////////////////////////////////////
//lcd_ddr3_rfclrͬ����clkʱ����
wire lcd_ddr3_rfclr_r;

register_diff_clk		register_diff_clk_dc2(
							.clk(clk),		
							.rst_n(rst_n),	
							.in_a(lcd_ddr3_rfclr),
							.out_b(lcd_ddr3_rfclr_r)	
						);
		
////////////////////////////////////////////////////
//������FIFO
//����FIFO��������128*128bitʱ�ͷ����DDR3����	
wire[12:0] rfifo_rd_data_count;
(*mark_debug = "true"*) wire[9:0] rfifo_wr_data_count;
		
fifo_generator_0 		fifo_for_ddr3_read (
  .rst(!rst_n || lcd_ddr3_rfclr),                      // input wire rst
  .wr_clk(clk),                // input wire wr_clk
  .rd_clk(clk_33m),                // input wire rd_clk
  .din(app_rd_data),                  // input wire [127 : 0] din		//DDR3��������
  .wr_en(app_rd_data_valid),          // input wire wr_en			//DDR3����������Ч�ź�
  .rd_en(lcd_ddr3_rfreq),                  // input wire rd_en
  .dout(lcd_ddr3_rfdb),                    // output wire [15 : 0] dout
  .full(),                    // output wire full
  .empty(),                  // output wire empty
  .valid(),                  // output wire valid
  .rd_data_count(rfifo_rd_data_count),  // output wire [9 : 0] rd_data_count
  .wr_data_count(rfifo_wr_data_count)  // output wire [6 : 0] wr_data_count
);		
			
reg[16:0] user_ddr3_read_addr;		//DDR3��ȡ��ַ
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) user_ddr3_read_addr <= 17'd0;
	else if(lcd_ddr3_rfclr_r) user_ddr3_read_addr <= 17'd0;
	else if(cstate == SRDED) user_ddr3_read_addr <= user_ddr3_read_addr+1'b1;
	
////////////////////////////////////////////////////
//������дDDR3������״̬
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

	//���ݶ�д�ٲÿ���״̬��
always @(cstate or rfifo_wr_data_count or wfifo_rd_data_count or num or wrnum) begin
	case(cstate)
		SIDLE: begin
			if((rfifo_wr_data_count < BURST_RD_128BIT) && !lcd_ddr3_rfclr_r) nstate <= SRDDB;		
			else if((wfifo_rd_data_count >= BURST_WR_128BIT) && !image_ddr3_clr_r) nstate <= SWRDB;
			else nstate <= SIDLE;
		end
		SWRDB: begin	//д����
			if((wrnum > (BURST_WR_128BIT+1)) && (num > BURST_WR_128BIT)) nstate <= SWRED;
			else nstate <= SWRDB;
		end
		SWRED: nstate <= SSTOP;
		SRDDB: begin	//������
			if(num > BURST_RD_128BIT) nstate <= SRDED;
			else nstate <= SRDDB;
		end
		SRDED: nstate <= SSTOP;		
		SSTOP: nstate <= SIDLE;
		default: nstate <= SIDLE;
	endcase
end

////////////////////////////////////////////////////	
//����д��������������

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
//д���ݿ����źż�����

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
//��д���ݿ���ʱ�����
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
		app_cmd <= 3'd0;
		app_en <= 1'b0;
		app_addr <= 28'd0;		
	end
	else if(cstate == SWRDB) begin	//дDDR3
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
	else if(cstate == SRDDB) begin	//��DDR3
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
//д���ݿ���ʱ�����
		
always @(posedge clk or negedge rst_n)
	if(!rst_n) wfifo_rd_en <= 1'b0; 	
	else if((cstate == SWRDB) && app_wdf_rdy && (wrnum < BURST_WR_128BIT)) wfifo_rd_en <= 1'b1;
	else wfifo_rd_en <= 1'b0; 

	//дDDR3����ʹ��
always @(posedge clk or negedge rst_n)
	if(!rst_n) app_wdf_wren <= 1'b0;
	else if((cstate == SWRDB) && app_wdf_rdy && (wrnum > 10'd0) && (wrnum <= BURST_WR_128BIT)) app_wdf_wren <= 1'b1;
	else app_wdf_wren <= 1'b0;

assign app_wdf_data = wfifo_rd_data;


endmodule

