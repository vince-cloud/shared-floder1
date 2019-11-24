`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2019 02:40:24 PM
// Design Name: 
// Module Name: at7
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module gamma_correction(
		input clk,
		input rst_n,
		
		//input i_rgb_image_rst,
		input i_rgb_image_vld,
		input[23:0] i_rgb_image_data,

		output reg o_gamma_image_vld,
		output[23:0] o_gamma_image_data			
		
    );

////////////////////////////////////////////////////	
//输出使能信号产生
reg r_rgb_image_vld;

always @(posedge clk)	
	if(!rst_n) r_rgb_image_vld <= 1'b0;
	else r_rgb_image_vld <= i_rgb_image_vld;

always @(posedge clk)	
	if(!rst_n) o_gamma_image_vld <= 1'b0;
	else o_gamma_image_vld <= r_rgb_image_vld;
	
////////////////////////////////////////////////////
//gamma LUT ROM for R
	
blk_mem_gen_0 	uut_blk_mem_gen_r (
  .clka(clk),    // input wire clka
  .ena(i_rgb_image_vld),      // input wire ena
  .addra(i_rgb_image_data[23:16]),  // input wire [7 : 0] addra
  .douta(o_gamma_image_data[23:16])  // output wire [7 : 0] douta
);	

////////////////////////////////////////////////////
//gamma LUT ROM for G
	
blk_mem_gen_0 	uut_blk_mem_gen_g (
  .clka(clk),    // input wire clka
  .ena(i_rgb_image_vld),      // input wire ena
  .addra(i_rgb_image_data[7:0]),  // input wire [7 : 0] addra
  .douta(o_gamma_image_data[7:0])  // output wire [7 : 0] douta
);	

////////////////////////////////////////////////////
//gamma LUT ROM for B
	
blk_mem_gen_0 	uut_blk_mem_gen_b (
  .clka(clk),    // input wire clka
  .ena(i_rgb_image_vld),      // input wire ena
  .addra(i_rgb_image_data[15:8]),  // input wire [7 : 0] addra
  .douta(o_gamma_image_data[15:8])  // output wire [7 : 0] douta
);	
	
	
endmodule

