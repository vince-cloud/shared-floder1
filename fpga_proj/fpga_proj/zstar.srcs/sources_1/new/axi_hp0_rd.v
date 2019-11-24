`timescale  1 ns/10ps
/////////////////////////////////////////////////////////////////////////////
//��Ȩͬѧ ���Ĵ��� Xilinx Zynq FPGA������ϵ��
//����Ӳ��ƽ̨�� Xilinx Zynq FPGA 
//�����׼��ͺţ� Zstar FPGA�����׼�
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����Zstar�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module axi_hp0_rd(
				//ϵͳ�ź�
			input				rst_n,                   
				//д��DDR3������         
			input				i_clk,
			input 				i_data_rst_n,
			input				i_data_rden,
			output[15:0]		o_data,
			
				//AXI����ʱ��
			input				AXI_clk,
				//AXI����ַͨ��
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
				//AXI������ͨ��
			input[63:0]			AXI_rdata,
			input[5:0]			AXI_rid,
			input 				AXI_rlast,
			output 				AXI_rready,
			input[1:0]			AXI_rresp,
			input 				AXI_rvalid			
		);
		
//------------------------------------------------------------------------------------
//�������ź����� 

parameter STAR_ADDR = 32'h0100_0000;
parameter AXI_BURST_LEN	= 16;

parameter STATE_RST  = 4'h0;	
parameter STATE_IDLE = 4'h1; 
parameter STATE_RADD = 4'h2; 	 
parameter READ_DONE = 4'h3; 
reg[3:0]    cstate,nstate;

wire[7:0] fifo_wrdata_count;

//------------------------------------------------------------------------------------
//��i_data_rst_n��AXI_clkʱ�����2��

wire w_data_rst_n,pos_data_rst_n,neg_data_rst_n;	
	
pulse_detection		uut_pulse_detection_odrn(
						.clk(AXI_clk),       	
						.in_sig(i_data_rst_n),	//�����ź�
						.out_sig(w_data_rst_n),	//�������ź�ͬ��������ʱ���������
						.pos_sig(pos_data_rst_n),	//�����źŵ������ؼ�⣬�����屣��һ��ʱ������
						.neg_sig(neg_data_rst_n)	//�����źŵ��½��ؼ�⣬�����屣��һ��ʱ������
					);

//-------------------------------------------------------------------------------
//AXI��״̬��

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
//AXI HP��ʱ�����

	//����ַ��Ч�źŲ���
always @(posedge AXI_clk)begin
	if(nstate == STATE_RADD) AXI_arvalid <= 1'b1;
	else AXI_arvalid <= 1'b0;
end

	//����ַ����
always @(posedge AXI_clk)begin
	if(cstate == STATE_RST) AXI_araddr <= STAR_ADDR;
	else if(AXI_arvalid && AXI_arready) AXI_araddr <= AXI_araddr + AXI_BURST_LEN * 8; 
end	

//------------------------------------------------------------------------------------
//DDR3�������ݻ��浽FIFO��LCD��ʾģ���ȡFIFO���ݣ�λ���64bitת16bit

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
//AXI HP���߹̶�����

assign AXI_arsize	= 3'b011;	//8 Bytes per burst
assign AXI_arburst	= 2'b01;
assign AXI_arlock	= 2'b00;
assign AXI_arcache	= 4'b0010;
assign AXI_arprot	= 3'h0;
assign AXI_arqos	= 4'h0;
assign AXI_rready 	= 1'b1;
assign AXI_arlen 	= AXI_BURST_LEN - 1; 
	
endmodule

