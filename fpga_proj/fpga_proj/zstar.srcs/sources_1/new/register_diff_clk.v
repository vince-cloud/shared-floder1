/////////////////////////////////////////////////////////////////////////////
//��Ȩͬѧ ���Ĵ��� Xilinx Zynq FPGA������ϵ��
//����Ӳ��ƽ̨�� Xilinx Zynq FPGA 
//�����׼��ͺţ� Zstar FPGA�����׼�
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����Zstar�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
/////////////////////////////////////////////////////////////////////////////
module register_diff_clk(
			input clk,		
			input rst_n,	
			input in_a,
			output out_b	
		);
	
reg[1:0] temp;

always @(posedge clk or negedge rst_n)	
	if(!rst_n) temp <= 2'b00;
	else temp <= {temp[0],in_a};

assign out_b = temp[1];	

endmodule

