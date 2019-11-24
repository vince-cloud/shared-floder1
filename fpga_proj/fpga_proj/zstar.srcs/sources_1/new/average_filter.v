`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
//��Ȩͬѧ ���Ĵ��� Xilinx Zynq FPGA������ϵ��
//����Ӳ��ƽ̨�� Xilinx Zynq FPGA 
//�����׼��ͺţ� Zstar FPGA�����׼�
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����Zstar�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
/*
��ͼ����о�ֵ�˲�ƽ������
��1�С����1�С���1�С����1�в�������ʹ��ԭʼͼ������ֵ�����
������ͼ�����ص㣬����Χ���ص����������㣺
%           	1    2    1
%   1/16 *  	2    4    2
%           	1    2    1
*/
module average_filter(
			input clk,		//50MHzʱ��
			input rst_n,	//��λ�źţ��͵�ƽ��Ч
				//Image Data flow from Image Sensor
			input i_image_ddr3_wren,
			input i_image_ddr3_line_end,
			input i_image_ddr3_clr,
			input[15:0] i_image_ddr3_wrdb,			
				//Image Data flow after average transform
			output reg o_image_ddr3_wren,
			output[15:0] o_image_ddr3_wrdb			
		);

parameter IMAGE_WIDTH	= 10'd640;	
parameter IMAGE_HIGHT	= 10'd480;	
			
////////////////////////////////////////////////////
//�����м�����
reg[9:0] r_line_cnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n) r_line_cnt <= 10'd0;
	else if(i_image_ddr3_clr) r_line_cnt <= 10'd0;
	else if(i_image_ddr3_line_end) r_line_cnt <= r_line_cnt+1'b1;
	else ;

////////////////////////////////////////////////////
//FIFO for cache 1 line image data
reg r_fifo1_rd_en;
wire[15:0] w_fifo1_dout;
wire[9:0] w_fifo1_data_count;

fifo_generator_3 	uut1_fifo_generator_3 (
  .clk(clk),                // input wire clk
  .srst(!rst_n || i_image_ddr3_clr),              // input wire srst
  .din(i_image_ddr3_wrdb),                // input wire [15 : 0] din
  .wr_en(i_image_ddr3_wren),            // input wire wr_en
  .rd_en(r_fifo1_rd_en),            // input wire rd_en
  .dout(w_fifo1_dout),              // output wire [15 : 0] dout
  .full(),              // output wire full
  .empty(),            // output wire empty
  .data_count(w_fifo1_data_count)  // output wire [9 : 0] data_count
);

reg r_fifo2_wr_en;
reg r_fifo2_rd_en;
wire[15:0] w_fifo2_dout;
wire[9:0] w_fifo2_data_count;

fifo_generator_3 	uut2_fifo_generator_3 (
  .clk(clk),                // input wire clk
  .srst(!rst_n || i_image_ddr3_clr),              // input wire srst
  .din(w_fifo1_dout),                // input wire [15 : 0] din
  .wr_en(r_fifo2_wr_en),            // input wire wr_en
  .rd_en(r_fifo2_rd_en),            // input wire rd_en
  .dout(w_fifo2_dout),              // output wire [15 : 0] dout
  .full(),              // output wire full
  .empty(),            // output wire empty
  .data_count(w_fifo2_data_count)  // output wire [9 : 0] data_count
);

////////////////////////////////////////////////////
//��������640�����ݼ�������״̬��
parameter RFIFO_RESET	= 3'd0;
parameter RFIFO_IDLE	= 3'd1;
parameter RFIFO_RDDB1	= 3'd2;
parameter RFIFO_RDDB2	= 3'd3;
parameter RFIFO_WAIT	= 3'd4;
parameter RFIFO_RDDB3	= 3'd5;
reg[2:0] rfifo_state;
reg[9:0] dcnt;	//��FIFO���ݸ���������
reg[9:0] average_num;
reg[3:0] dly_cnt;

always @(posedge clk or negedge rst_n)
	if(!rst_n) rfifo_state <= RFIFO_RESET;
	else if(i_image_ddr3_clr) rfifo_state <= RFIFO_RESET;
	else begin
		case(rfifo_state)
			RFIFO_RESET: if(w_fifo1_data_count >= IMAGE_WIDTH) rfifo_state <= RFIFO_RDDB1;
						else rfifo_state <= RFIFO_RESET;
			RFIFO_RDDB1: if(dcnt >= (IMAGE_WIDTH-1)) rfifo_state <= RFIFO_IDLE;
						else rfifo_state <= RFIFO_RDDB1;
			RFIFO_IDLE:  if(r_line_cnt >= IMAGE_HIGHT) rfifo_state <= RFIFO_WAIT;
						else if(w_fifo2_data_count >= IMAGE_WIDTH) rfifo_state <= RFIFO_RDDB2;
						else rfifo_state <= RFIFO_IDLE;			
			RFIFO_RDDB2: if(r_line_cnt >= IMAGE_HIGHT) rfifo_state <= RFIFO_WAIT;
						else if(dcnt >= (IMAGE_WIDTH-1)) rfifo_state <= RFIFO_IDLE;
						else rfifo_state <= RFIFO_RDDB2;
			RFIFO_WAIT:	 if(dly_cnt == 4'hf) rfifo_state <= RFIFO_RDDB3;	
						else rfifo_state <= RFIFO_WAIT;
			RFIFO_RDDB3: if(dcnt >= (IMAGE_WIDTH-1)) rfifo_state <= RFIFO_RESET;
						else rfifo_state <= RFIFO_RDDB3;						
			default: rfifo_state <= RFIFO_IDLE;
		endcase
	end
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) dly_cnt <= 4'd0;
	else if(rfifo_state == RFIFO_WAIT) dly_cnt <= dly_cnt+1'b1;
	else dly_cnt <= 4'd0;
	
	//��FIFO���ݸ���������
always @(posedge clk or negedge rst_n)
	if(!rst_n) dcnt <= 10'd0;
	else if((rfifo_state == RFIFO_IDLE) || (rfifo_state == RFIFO_RESET)) dcnt <= 10'd0;
	else if(((rfifo_state == RFIFO_RDDB1) || (rfifo_state == RFIFO_RDDB2)) && i_image_ddr3_wren) dcnt <= dcnt+1'b1;
	else if(rfifo_state == RFIFO_RDDB3) dcnt <= dcnt+1'b1;	
	else dcnt <= 10'd0;
	
	//average transform���ݼ�����
always @(posedge clk or negedge rst_n)
	if(!rst_n) average_num <= 10'd0;
	else if(dcnt == 10'd4) average_num <= 10'd1;
	else if(average_num != 10'd0) begin
		if(average_num < IMAGE_WIDTH) average_num <= average_num+1'b1;
		else average_num <= 10'd0;
	end
	else average_num <= 10'd0;

	//��FIFO1ʹ���źŲ����߼�
always @(posedge clk or negedge rst_n)
	if(!rst_n) r_fifo1_rd_en <= 1'b0;
	else if(((rfifo_state == RFIFO_RDDB1) || (rfifo_state == RFIFO_RDDB2)) && i_image_ddr3_wren) r_fifo1_rd_en <= 1'b1;
	else if((rfifo_state == RFIFO_RDDB3) && (dcnt < IMAGE_WIDTH)) r_fifo1_rd_en <= 1'b1;
	else r_fifo1_rd_en <= 1'b0;
	
	//дFIFO2�����źŲ����߼�
always @(posedge clk or negedge rst_n)
	if(!rst_n) r_fifo2_wr_en <= 1'b0;
	else r_fifo2_wr_en <= r_fifo1_rd_en;	
	
	//��FIFO2ʹ���źŲ����߼�	
always @(posedge clk or negedge rst_n)
	if(!rst_n) r_fifo2_rd_en <= 1'b0;
	else if(((rfifo_state == RFIFO_RDDB2) || (rfifo_state == RFIFO_RDDB3)) && i_image_ddr3_wren) r_fifo2_rd_en <= 1'b1;
	else r_fifo2_rd_en <= 1'b0;	

////////////////////////////////////////////////////
//ͼ�񻺴�3��
reg[15:0] data_temp_line_1[2:0];	
reg[15:0] data_temp_line_2[2:0];
reg[15:0] data_temp_line_3[4:0];

always @(posedge clk) begin
	data_temp_line_1[0] <= w_fifo2_dout;
	data_temp_line_1[1] <= data_temp_line_1[0];
	data_temp_line_1[2] <= data_temp_line_1[1];
end

always @(posedge clk) begin
	data_temp_line_2[0] <= w_fifo1_dout;
	data_temp_line_2[1] <= data_temp_line_2[0];
	data_temp_line_2[2] <= data_temp_line_2[1];
end

always @(posedge clk) begin
	data_temp_line_3[0] <= i_image_ddr3_wrdb;
	data_temp_line_3[1] <= data_temp_line_3[0];
	data_temp_line_3[2] <= data_temp_line_3[1];
	data_temp_line_3[3] <= data_temp_line_3[2];
	data_temp_line_3[4] <= data_temp_line_3[3];
end	
	
////////////////////////////////////////////////////
//ͼ�����average filter����
reg[9:0] sum_a_r,sum_b_r1,sum_b_r2;
reg[9:0] sum_a_g,sum_b_g1,sum_b_g2;
reg[9:0] sum_a_b,sum_b_b1,sum_b_b2;

reg[15:0] average_result;	
	
always @(posedge clk) begin
	sum_a_r <= {3'b000,data_temp_line_2[1][15:11],2'b00};
	sum_a_g <= {2'b0,data_temp_line_2[1][10:5],2'b00};
	sum_a_b <= {3'b000,data_temp_line_2[1][4:0],2'b00};
end	
	
always @(posedge clk) begin
	sum_b_r1 <= {4'd0,data_temp_line_2[0][15:11],1'b0}	+ {4'd0,data_temp_line_2[2][15:11],1'b0}+ {4'd0,data_temp_line_1[1][15:11],1'b0}+ {4'd0,data_temp_line_3[3][15:11],1'b0};
	sum_b_g1 <= {3'd0,data_temp_line_2[0][10:5],1'b0}	+ {3'd0,data_temp_line_2[2][10:5],1'b0}	+ {3'd0,data_temp_line_1[1][10:5],1'b0}	+ {3'd0,data_temp_line_3[3][10:5],1'b0};
	sum_b_b1 <= {4'd0,data_temp_line_2[0][4:0],1'b0}	+ {4'd0,data_temp_line_2[2][4:0],1'b0}	+ {4'd0,data_temp_line_1[1][4:0],1'b0}	+ {4'd0,data_temp_line_3[3][4:0],1'b0};
	
	sum_b_r2 <= {5'd0,data_temp_line_1[0][15:11]}	+ {5'd0,data_temp_line_1[2][15:11]}	+ {5'd0,data_temp_line_3[2][15:11]}	+ {5'd0,data_temp_line_3[4][15:11]};
	sum_b_g2 <= {4'd0,data_temp_line_1[0][10:5]}	+ {4'd0,data_temp_line_1[2][10:5]}	+ {4'd0,data_temp_line_3[2][10:5]}	+ {4'd0,data_temp_line_3[4][10:5]};
	sum_b_b2 <= {5'd0,data_temp_line_1[0][4:0]}		+ {5'd0,data_temp_line_1[2][4:0]}	+ {5'd0,data_temp_line_3[2][4:0]}	+ {5'd0,data_temp_line_3[4][4:0]};	
end	

wire[9:0] temp_r = sum_a_r+(sum_b_r1+sum_b_r2);
wire[9:0] temp_g = sum_a_g+(sum_b_g1+sum_b_g2);
wire[9:0] temp_b = sum_a_b+(sum_b_b1+sum_b_b2);
	
always @(posedge clk) begin
	if((average_num == 10'd1) || (average_num == IMAGE_WIDTH)) average_result <= data_temp_line_2[2];	//��1�к����1��ʹ��ԭֵ
	else begin
		average_result[15:11] = temp_r[8:4];		
		average_result[10:5] = temp_g[9:4];
		average_result[4:0] = temp_b[8:4];	
	end
end	
	
////////////////////////////////////////////////////
//ͼ�������Ч�źŲ���
reg r_image_ddr3_wren;
reg[3:0] r_average_line_wren;
reg r_last_line_wren;

always @(posedge clk or negedge rst_n)
	if(!rst_n) r_last_line_wren <= 1'b0;
	else if((rfifo_state == RFIFO_RDDB3) && (dcnt < IMAGE_WIDTH)) r_last_line_wren <= 1'b1;
	else r_last_line_wren <= 1'b0;

always @(posedge clk or negedge rst_n)
	if(!rst_n) r_average_line_wren <= 4'd0;
	else begin
		r_average_line_wren[3:1] <= r_average_line_wren[2:0];
		if((rfifo_state == RFIFO_RDDB2) && (r_line_cnt > 10'd1) && i_image_ddr3_wren) r_average_line_wren[0] <= 1'b1;
		else r_average_line_wren[0] <= 1'b0;
	end	
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) r_image_ddr3_wren <= 1'b0;
	else if(r_average_line_wren[3]) r_image_ddr3_wren <= 1'b1;
	else if(r_last_line_wren) r_image_ddr3_wren <= 1'b1;
	else r_image_ddr3_wren <= 1'b0;

always @(posedge clk or negedge rst_n)
	if(!rst_n) o_image_ddr3_wren <= 1'b0;
	else if((r_line_cnt == 10'd0) && i_image_ddr3_wren) o_image_ddr3_wren <= 1'b1;
	else if(r_image_ddr3_wren) o_image_ddr3_wren <= 1'b1;
	else o_image_ddr3_wren <= 1'b0;

////////////////////////////////////////////////////
//ͼ���������
reg[15:0] r_image_ddr3_wrdb;		

always @(posedge clk or negedge rst_n)
	if(!rst_n) r_image_ddr3_wrdb <= 16'd0;
	else if(r_line_cnt == 10'd0) r_image_ddr3_wrdb <= i_image_ddr3_wrdb;
	else if(r_image_ddr3_wren && (r_line_cnt >= IMAGE_HIGHT)) r_image_ddr3_wrdb <= w_fifo1_dout;
	else ;

reg output_link;	
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) output_link <= 1'b0;
	else if(r_line_cnt == 10'd0) output_link <= 1'b1;
	else if(r_image_ddr3_wren && (r_line_cnt >= IMAGE_HIGHT)) output_link <= 1'b1;
	else output_link <= 1'b0;	

assign o_image_ddr3_wrdb = output_link ? r_image_ddr3_wrdb:average_result;


endmodule

