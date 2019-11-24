
module sim_laplace_transform(
		
		);

reg clk;		//50MHz时钟
reg rst_n;	//复位信号，低电平有效
	//Image Data flow from Image Sensor
reg i_image_ddr3_wren;
reg i_image_ddr3_line_end;
reg i_image_ddr3_clr;
reg[15:0] i_image_ddr3_wrdb;			
	//Image Data flow after laplace transform
wire o_image_ddr3_wren;
wire[15:0] o_image_ddr3_wrdb;			
		
		
laplace_transform		uut_laplace_transform(		
		 // Outputs
		 .o_image_ddr3_wren	(o_image_ddr3_wren),
		 .o_image_ddr3_wrdb	(o_image_ddr3_wrdb),
		 // Inputs
		 .clk			(clk),
		 .rst_n			(rst_n),
		 .i_image_ddr3_wren	(i_image_ddr3_wren),
		 .i_image_ddr3_line_end	(i_image_ddr3_line_end),
		 .i_image_ddr3_clr	(i_image_ddr3_clr),
		 .i_image_ddr3_wrdb	(i_image_ddr3_wrdb[15:0]));		
		
////////////////////////////////////////////////////
//初始化
integer i,j;

initial begin
	clk = 0;
	rst_n = 0;

	i_image_ddr3_wren <= 1'b0;
	i_image_ddr3_line_end <= 1'b0;
	i_image_ddr3_clr <= 1'b1;
	i_image_ddr3_wrdb <= 16'd0;	
	
	#1000;
	rst_n = 1;
	#1000; @(posedge clk);	
	i_image_ddr3_clr <= 1'b1;
	#1000; @(posedge clk);
	i_image_ddr3_clr <= 1'b0;	
	#1000; @(posedge clk);
	
	for(i=0;i<480;i=i+1) begin
		for(j=0;j<640;j=j+1) begin
			@(posedge clk);
			i_image_ddr3_wren <= 1'b1;
			i_image_ddr3_wrdb <= $random;
		end
		@(posedge clk);
		i_image_ddr3_wren <= 1'b0;
		repeat(14) @(posedge clk);
		i_image_ddr3_line_end <= 1'b1;
		@(posedge clk);
		i_image_ddr3_line_end <= 1'b0;
	end
	
	#100_000;
	$stop;
end		
		
always #10 clk = ~clk;		
		
/*

add_wave {{/sim_laplace_transform/uut_laplace_transform/r_line_cnt}} {{/sim_laplace_transform/uut_laplace_transform/laplace_result}} 

*/		
		
		


endmodule

