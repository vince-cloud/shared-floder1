/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )  
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2012-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Email Address 		: 		crazyfpga@vip.qq.com
Filename			:		I2C_OV5640_RAW_Config
Date				:		2012-05-11
Description			:		OV5640 I2C Config with RGB565 Format.
Modification History	:
Date			By			Version			Change Description
=========================================================================
12/05/11		CrazyBingo	1.0				Original
12/05/13		CrazyBingo	1.1				Modification
12/06/01		CrazyBingo	1.4				Modification
12/06/05		CrazyBingo	1.5				Modification
13/04/08		CrazyBingo	1.6				Modification
17/09/17		CrazyBingo	2.0				Modified for OV5640 RAW
-------------------------------------------------------------------------
|                                     Oooo								|
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/

`timescale 1ns/1ns
module	I2C_OV5640_RAW_Config
(
	input		[8:0]	LUT_INDEX,
	output	reg	[23:0]	LUT_DATA,
	output		[8:0]	LUT_SIZE
);
assign		LUT_SIZE = 9'd311;


localparam	SET_OV5640	=	2;			//SET_OV LUT Adderss

//-----------------------------------------------------------------
/////////////////////	Config Data LUT	  //////////////////////////	
always@(*)
begin
	case(LUT_INDEX)
////	OV5640 : VGA 640*480
	SET_OV5640 +  0:   	LUT_DATA	= 	24'h3008_42;
	SET_OV5640 +  1:   	LUT_DATA	= 	24'h3103_03;
	SET_OV5640 +  2:   	LUT_DATA	= 	24'h4005_1a;
	SET_OV5640 +  3:   	LUT_DATA	= 	24'h4740_21;
	SET_OV5640 +  4:   	LUT_DATA	= 	24'h3017_ff;
	SET_OV5640 +  5:   	LUT_DATA	= 	24'h3018_ff;
	SET_OV5640 +  6:   	LUT_DATA	= 	24'h3034_1a;
	SET_OV5640 +  7:   	LUT_DATA	= 	24'h3035_11;	//PLL
	SET_OV5640 +  8:   	LUT_DATA	= 	24'h3036_69;	//PLL
	SET_OV5640 +  9:   	LUT_DATA	= 	24'h3037_13;
	SET_OV5640 + 10:   	LUT_DATA	= 	24'h3108_01;
	SET_OV5640 + 11:   	LUT_DATA	= 	24'h3630_36;
	SET_OV5640 + 12:   	LUT_DATA	= 	24'h3631_0e;
	SET_OV5640 + 13:   	LUT_DATA	= 	24'h3632_e2;
	SET_OV5640 + 14:   	LUT_DATA	= 	24'h3633_12;
	SET_OV5640 + 15:   	LUT_DATA	= 	24'h3621_e0;
	SET_OV5640 + 16:   	LUT_DATA	= 	24'h3704_a0;
	SET_OV5640 + 17:   	LUT_DATA	= 	24'h3703_5a;
	SET_OV5640 + 18:   	LUT_DATA	= 	24'h3715_78;
	SET_OV5640 + 19:   	LUT_DATA	= 	24'h3717_01;
	SET_OV5640 + 20:   	LUT_DATA	= 	24'h370b_60;
	SET_OV5640 + 21:   	LUT_DATA	= 	24'h3705_1a;
	SET_OV5640 + 22:   	LUT_DATA	= 	24'h3905_02;
	SET_OV5640 + 23:   	LUT_DATA	= 	24'h3906_10;
	SET_OV5640 + 24:   	LUT_DATA	= 	24'h3901_0a;
	SET_OV5640 + 25:   	LUT_DATA	= 	24'h3731_12;
	SET_OV5640 + 26:   	LUT_DATA	= 	24'h3600_08;
	SET_OV5640 + 27:   	LUT_DATA	= 	24'h3601_33;
	SET_OV5640 + 28:   	LUT_DATA	= 	24'h302d_60;
	SET_OV5640 + 29:   	LUT_DATA	= 	24'h3620_52;
	SET_OV5640 + 30:   	LUT_DATA	= 	24'h371b_20;
	SET_OV5640 + 31:   	LUT_DATA	= 	24'h471c_50;
	SET_OV5640 + 32:   	LUT_DATA	= 	24'h3a13_43;
	SET_OV5640 + 33:   	LUT_DATA	= 	24'h3a18_00;
	SET_OV5640 + 34:   	LUT_DATA	= 	24'h3a19_b0;
	SET_OV5640 + 35:   	LUT_DATA	= 	24'h3635_13;
	SET_OV5640 + 36:   	LUT_DATA	= 	24'h3636_03;
	SET_OV5640 + 37:   	LUT_DATA	= 	24'h3634_40;
	SET_OV5640 + 38:   	LUT_DATA	= 	24'h3622_01;
	SET_OV5640 + 39:   	LUT_DATA	= 	24'h3c01_34;
	SET_OV5640 + 40:   	LUT_DATA	= 	24'h3c00_00;
	SET_OV5640 + 41:   	LUT_DATA	= 	24'h3c04_28;
	SET_OV5640 + 42:   	LUT_DATA	= 	24'h3c05_98;
	SET_OV5640 + 43:   	LUT_DATA	= 	24'h3c06_00;
	SET_OV5640 + 44:   	LUT_DATA	= 	24'h3c07_08;
	SET_OV5640 + 45:   	LUT_DATA	= 	24'h3c08_00;
	SET_OV5640 + 46:   	LUT_DATA	= 	24'h3c09_1c;
	SET_OV5640 + 47:   	LUT_DATA	= 	24'h3c0a_9c;
	SET_OV5640 + 48:   	LUT_DATA	= 	24'h3c0b_40;
	SET_OV5640 + 49:   	LUT_DATA	= 	24'h3820_40;
	SET_OV5640 + 50:   	LUT_DATA	= 	24'h3821_01;
	SET_OV5640 + 51:   	LUT_DATA	= 	24'h3814_31;
	SET_OV5640 + 52:   	LUT_DATA	= 	24'h3815_31;
														
	SET_OV5640 + 53:   	LUT_DATA	= 	24'h3800_00;		
	SET_OV5640 + 54:   	LUT_DATA	= 	24'h3801_00;		
	SET_OV5640 + 55:   	LUT_DATA	= 	24'h3802_00;		
	SET_OV5640 + 56:   	LUT_DATA	= 	24'h3803_04;		
	SET_OV5640 + 57:   	LUT_DATA	= 	24'h3804_0a;		
	SET_OV5640 + 58:   	LUT_DATA	= 	24'h3805_3f;		
	SET_OV5640 + 59:   	LUT_DATA	= 	24'h3806_07;		
	SET_OV5640 + 60:   	LUT_DATA	= 	24'h3807_9b;	//	VGA		QVGA	SVGA	CIF		720P
	SET_OV5640 + 61:   	LUT_DATA	= 	24'h3808_02;	//	02		01		03		01		05
	SET_OV5640 + 62:   	LUT_DATA	= 	24'h3809_80;	//	80		40		20		60		00
	SET_OV5640 + 63:   	LUT_DATA	= 	24'h380a_01;	//	01		00		02		01		02	
	SET_OV5640 + 64:   	LUT_DATA	= 	24'h380b_e0;	//	e0		f0		58		20		d0
	SET_OV5640 + 65:   	LUT_DATA	= 	24'h380c_07;	//参看手册P39	
	SET_OV5640 + 66:   	LUT_DATA	= 	24'h380d_68;		
	SET_OV5640 + 67:   	LUT_DATA	= 	24'h380e_03;		
	SET_OV5640 + 68:   	LUT_DATA	= 	24'h380f_d8;		
		
	SET_OV5640 + 69:   	LUT_DATA	= 	24'h3810_00;
	SET_OV5640 + 70:   	LUT_DATA	= 	24'h3811_10;
	SET_OV5640 + 71:   	LUT_DATA	= 	24'h3812_00;
	SET_OV5640 + 72:   	LUT_DATA	= 	24'h3813_06;
	SET_OV5640 + 73:   	LUT_DATA	= 	24'h3618_00;
	SET_OV5640 + 74:   	LUT_DATA	= 	24'h3612_29;
	SET_OV5640 + 75:   	LUT_DATA	= 	24'h3708_64;
	SET_OV5640 + 76:   	LUT_DATA	= 	24'h3709_52;
	SET_OV5640 + 77:   	LUT_DATA	= 	24'h370c_03;
	SET_OV5640 + 78:   	LUT_DATA	= 	24'h3a02_03;
	SET_OV5640 + 79:   	LUT_DATA	= 	24'h3a03_d8;
	SET_OV5640 + 80:   	LUT_DATA	= 	24'h3a08_01;
	SET_OV5640 + 81:   	LUT_DATA	= 	24'h3a09_27;
	SET_OV5640 + 82:   	LUT_DATA	= 	24'h3a0a_00;
	SET_OV5640 + 83:   	LUT_DATA	= 	24'h3a0b_f6;
	SET_OV5640 + 84:   	LUT_DATA	= 	24'h3a0e_03;
	SET_OV5640 + 85:   	LUT_DATA	= 	24'h3a0d_04;
	SET_OV5640 + 86:   	LUT_DATA	= 	24'h3a14_03;
	SET_OV5640 + 87:   	LUT_DATA	= 	24'h3a15_d8;
	SET_OV5640 + 88:   	LUT_DATA	= 	24'h4001_02;
	SET_OV5640 + 89:   	LUT_DATA	= 	24'h4004_02;
	SET_OV5640 + 90:   	LUT_DATA	= 	24'h3000_00;
	SET_OV5640 + 91:   	LUT_DATA	= 	24'h3002_1c;
	SET_OV5640 + 92:   	LUT_DATA	= 	24'h3004_ff;
	SET_OV5640 + 93:   	LUT_DATA	= 	24'h3006_c3;
	SET_OV5640 + 94:   	LUT_DATA	= 	24'h300e_58;
	SET_OV5640 + 95:   	LUT_DATA	= 	24'h302e_00;
	SET_OV5640 + 96:   	LUT_DATA	= 	24'h4300_02;// RGB565:61 YUV422YUYV:30 ;RAW: 00
	SET_OV5640 + 97:   	LUT_DATA	= 	24'h501f_01;// 00: ISP:YUV22 01:ISP:RGB 
	SET_OV5640 + 98:   	LUT_DATA	= 	24'h3016_02;
	SET_OV5640 + 99:   	LUT_DATA	= 	24'h301c_02;
	SET_OV5640 + 100:  	LUT_DATA	= 	24'h3019_02;
	SET_OV5640 + 101:  	LUT_DATA	= 	24'h3019_00;
	SET_OV5640 + 102:  	LUT_DATA	= 	24'h4713_03;
	SET_OV5640 + 103:  	LUT_DATA	= 	24'h4407_04;
	SET_OV5640 + 104:  	LUT_DATA	= 	24'h440e_00;
	SET_OV5640 + 105:  	LUT_DATA	= 	24'h460b_35;
	SET_OV5640 + 106:  	LUT_DATA	= 	24'h460c_20;
	SET_OV5640 + 107:  	LUT_DATA	= 	24'h4837_22;
	SET_OV5640 + 108:  	LUT_DATA	= 	24'h3824_02;	
//	SET_OV5640 + 109:  	LUT_DATA	= 	24'h5000_a7;
	SET_OV5640 + 109:  	LUT_DATA	= 	24'h5000_87;	//gamma disable	
	SET_OV5640 + 110:  	LUT_DATA	= 	24'h5001_a3;
	SET_OV5640 + 111:  	LUT_DATA	= 	24'h5180_ff;
	SET_OV5640 + 112:  	LUT_DATA	= 	24'h5181_f2;
	SET_OV5640 + 113:  	LUT_DATA	= 	24'h5182_00;
	SET_OV5640 + 114:  	LUT_DATA	= 	24'h5183_14;
	SET_OV5640 + 115:  	LUT_DATA	= 	24'h5184_25;
	SET_OV5640 + 116:  	LUT_DATA	= 	24'h5185_24;
	SET_OV5640 + 117:  	LUT_DATA	= 	24'h5186_10;
	SET_OV5640 + 118:  	LUT_DATA	= 	24'h5187_12;
	SET_OV5640 + 119:  	LUT_DATA	= 	24'h5188_10;
	SET_OV5640 + 120:  	LUT_DATA	= 	24'h5189_74;
	SET_OV5640 + 121:  	LUT_DATA	= 	24'h518a_5e;
	SET_OV5640 + 122:  	LUT_DATA	= 	24'h518b_ac;
	SET_OV5640 + 123:  	LUT_DATA	= 	24'h518c_83;
	SET_OV5640 + 124:  	LUT_DATA	= 	24'h518d_3b;
	SET_OV5640 + 125:  	LUT_DATA	= 	24'h518e_35;
	SET_OV5640 + 126:  	LUT_DATA	= 	24'h518f_4f;
	SET_OV5640 + 127:  	LUT_DATA	= 	24'h5190_42;
	SET_OV5640 + 128:  	LUT_DATA	= 	24'h5191_f8;
	SET_OV5640 + 129:  	LUT_DATA	= 	24'h5192_04;
	SET_OV5640 + 130:  	LUT_DATA	= 	24'h5193_70;
	SET_OV5640 + 131:  	LUT_DATA	= 	24'h5194_f0;
	SET_OV5640 + 132:  	LUT_DATA	= 	24'h5195_f0;
	SET_OV5640 + 133:  	LUT_DATA	= 	24'h5196_03;
	SET_OV5640 + 134:  	LUT_DATA	= 	24'h5197_01;
	SET_OV5640 + 135:  	LUT_DATA	= 	24'h5198_04;
	SET_OV5640 + 136:  	LUT_DATA	= 	24'h5199_87;
	SET_OV5640 + 137:  	LUT_DATA	= 	24'h519a_04;
	SET_OV5640 + 138:  	LUT_DATA	= 	24'h519b_00;
	SET_OV5640 + 139:  	LUT_DATA	= 	24'h519c_07;
	SET_OV5640 + 140:  	LUT_DATA	= 	24'h519d_56;
	SET_OV5640 + 141:  	LUT_DATA	= 	24'h519e_38;
	SET_OV5640 + 142:  	LUT_DATA	= 	24'h5381_1e;
	SET_OV5640 + 143:  	LUT_DATA	= 	24'h5382_5b;
	SET_OV5640 + 144:  	LUT_DATA	= 	24'h5383_08;
	SET_OV5640 + 145:  	LUT_DATA	= 	24'h5384_0a;
	SET_OV5640 + 146:  	LUT_DATA	= 	24'h5385_7e;
	SET_OV5640 + 147:  	LUT_DATA	= 	24'h5386_88;
	SET_OV5640 + 148:  	LUT_DATA	= 	24'h5387_7c;
	SET_OV5640 + 149:  	LUT_DATA	= 	24'h5388_6c;
	SET_OV5640 + 150:  	LUT_DATA	= 	24'h5389_10;
	SET_OV5640 + 151:  	LUT_DATA	= 	24'h538a_01;
	SET_OV5640 + 152:  	LUT_DATA	= 	24'h538b_98;
	SET_OV5640 + 153:  	LUT_DATA	= 	24'h5300_08;
	SET_OV5640 + 154:  	LUT_DATA	= 	24'h5301_30;
	SET_OV5640 + 155:  	LUT_DATA	= 	24'h5302_10;
	SET_OV5640 + 156:  	LUT_DATA	= 	24'h5303_00;
	SET_OV5640 + 157:  	LUT_DATA	= 	24'h5304_08;
	SET_OV5640 + 158:  	LUT_DATA	= 	24'h5305_30;
	SET_OV5640 + 159:  	LUT_DATA	= 	24'h5306_08;
	SET_OV5640 + 160:  	LUT_DATA	= 	24'h5307_16;
	SET_OV5640 + 161:  	LUT_DATA	= 	24'h5309_08;
	SET_OV5640 + 162:  	LUT_DATA	= 	24'h530a_30;
	SET_OV5640 + 163:  	LUT_DATA	= 	24'h530b_04;
	SET_OV5640 + 164:  	LUT_DATA	= 	24'h530c_06;
	SET_OV5640 + 165:  	LUT_DATA	= 	24'h5480_01;
	SET_OV5640 + 166:  	LUT_DATA	= 	24'h5481_08;
	SET_OV5640 + 167:  	LUT_DATA	= 	24'h5482_14;
	SET_OV5640 + 168:  	LUT_DATA	= 	24'h5483_28;
	SET_OV5640 + 169:  	LUT_DATA	= 	24'h5484_51;
	SET_OV5640 + 170:  	LUT_DATA	= 	24'h5485_65;
	SET_OV5640 + 171:  	LUT_DATA	= 	24'h5486_71;
	SET_OV5640 + 172:  	LUT_DATA	= 	24'h5487_7d;
	SET_OV5640 + 173:  	LUT_DATA	= 	24'h5488_87;
	SET_OV5640 + 174:  	LUT_DATA	= 	24'h5489_91;
	SET_OV5640 + 175:  	LUT_DATA	= 	24'h548a_9a;
	SET_OV5640 + 176:  	LUT_DATA	= 	24'h548b_aa;
	SET_OV5640 + 177:  	LUT_DATA	= 	24'h548c_b8;
	SET_OV5640 + 178:  	LUT_DATA	= 	24'h548d_cd;
	SET_OV5640 + 179:  	LUT_DATA	= 	24'h548e_dd;
	SET_OV5640 + 180:  	LUT_DATA	= 	24'h548f_ea;
	SET_OV5640 + 181:  	LUT_DATA	= 	24'h5490_1d;
	SET_OV5640 + 182:  	LUT_DATA	= 	24'h5580_02;
	SET_OV5640 + 183:  	LUT_DATA	= 	24'h5583_40;
	SET_OV5640 + 184:  	LUT_DATA	= 	24'h5584_10;
	SET_OV5640 + 185:  	LUT_DATA	= 	24'h5589_10;
	SET_OV5640 + 186:  	LUT_DATA	= 	24'h558a_00;
	SET_OV5640 + 187:  	LUT_DATA	= 	24'h558b_f8;
	SET_OV5640 + 188:  	LUT_DATA	= 	24'h5800_23;
	SET_OV5640 + 189:  	LUT_DATA	= 	24'h5801_15;
	SET_OV5640 + 190:  	LUT_DATA	= 	24'h5802_10;
	SET_OV5640 + 191:  	LUT_DATA	= 	24'h5803_10;
	SET_OV5640 + 192:  	LUT_DATA	= 	24'h5804_15;
	SET_OV5640 + 193:  	LUT_DATA	= 	24'h5805_23;
	SET_OV5640 + 194:  	LUT_DATA	= 	24'h5806_0c;
	SET_OV5640 + 195:  	LUT_DATA	= 	24'h5807_08;
	SET_OV5640 + 196:  	LUT_DATA	= 	24'h5808_05;
	SET_OV5640 + 197:  	LUT_DATA	= 	24'h5809_05;
	SET_OV5640 + 198:  	LUT_DATA	= 	24'h580a_08;
	SET_OV5640 + 199:  	LUT_DATA	= 	24'h580b_0c;
	SET_OV5640 + 200:  	LUT_DATA	= 	24'h580c_07;
	SET_OV5640 + 201:  	LUT_DATA	= 	24'h580d_03;
	SET_OV5640 + 202:  	LUT_DATA	= 	24'h580e_00;
	SET_OV5640 + 203:  	LUT_DATA	= 	24'h580f_00;
	SET_OV5640 + 204:  	LUT_DATA	= 	24'h5810_03;
	SET_OV5640 + 205:  	LUT_DATA	= 	24'h5811_07;
	SET_OV5640 + 206:  	LUT_DATA	= 	24'h5812_07;
	SET_OV5640 + 207:  	LUT_DATA	= 	24'h5813_03;
	SET_OV5640 + 208:  	LUT_DATA	= 	24'h5814_00;
	SET_OV5640 + 209:  	LUT_DATA	= 	24'h5815_00;
	SET_OV5640 + 210:  	LUT_DATA	= 	24'h5816_03;
	SET_OV5640 + 211:  	LUT_DATA	= 	24'h5817_07;
	SET_OV5640 + 212:  	LUT_DATA	= 	24'h5818_0b;
	SET_OV5640 + 213:  	LUT_DATA	= 	24'h5819_08;
	SET_OV5640 + 214:  	LUT_DATA	= 	24'h581a_05;
	SET_OV5640 + 215:  	LUT_DATA	= 	24'h581b_05;
	SET_OV5640 + 216:  	LUT_DATA	= 	24'h581c_07;
	SET_OV5640 + 217:  	LUT_DATA	= 	24'h581d_0b;
	SET_OV5640 + 218:  	LUT_DATA	= 	24'h581e_2a;
	SET_OV5640 + 219:  	LUT_DATA	= 	24'h581f_16;
	SET_OV5640 + 220:  	LUT_DATA	= 	24'h5820_11;
	SET_OV5640 + 221:  	LUT_DATA	= 	24'h5821_11;
	SET_OV5640 + 222:  	LUT_DATA	= 	24'h5822_15;
	SET_OV5640 + 223:  	LUT_DATA	= 	24'h5823_29;
	SET_OV5640 + 224:  	LUT_DATA	= 	24'h5824_bf;
	SET_OV5640 + 225:  	LUT_DATA	= 	24'h5825_af;
	SET_OV5640 + 226:  	LUT_DATA	= 	24'h5826_9f;
	SET_OV5640 + 227:  	LUT_DATA	= 	24'h5827_af;
	SET_OV5640 + 228:  	LUT_DATA	= 	24'h5828_df;
	SET_OV5640 + 229:  	LUT_DATA	= 	24'h5829_6f;
	SET_OV5640 + 230:  	LUT_DATA	= 	24'h582a_8e;
	SET_OV5640 + 231:  	LUT_DATA	= 	24'h582b_ab;
	SET_OV5640 + 232:  	LUT_DATA	= 	24'h582c_9e;
	SET_OV5640 + 233:  	LUT_DATA	= 	24'h582d_7f;
	SET_OV5640 + 234:  	LUT_DATA	= 	24'h582e_4f;
	SET_OV5640 + 235:  	LUT_DATA	= 	24'h582f_89;
	SET_OV5640 + 236:  	LUT_DATA	= 	24'h5830_86;
	SET_OV5640 + 237:  	LUT_DATA	= 	24'h5831_98;
	SET_OV5640 + 238:  	LUT_DATA	= 	24'h5832_6f;
	SET_OV5640 + 239:  	LUT_DATA	= 	24'h5833_4f;
	SET_OV5640 + 240:  	LUT_DATA	= 	24'h5834_6e;
	SET_OV5640 + 241:  	LUT_DATA	= 	24'h5835_7b;
	SET_OV5640 + 242:  	LUT_DATA	= 	24'h5836_7e;
	SET_OV5640 + 243:  	LUT_DATA	= 	24'h5837_6f;
	SET_OV5640 + 244:  	LUT_DATA	= 	24'h5838_de;
	SET_OV5640 + 245:  	LUT_DATA	= 	24'h5839_bf;
	SET_OV5640 + 246:  	LUT_DATA	= 	24'h583a_9f;
	SET_OV5640 + 247:  	LUT_DATA	= 	24'h583b_bf;
	SET_OV5640 + 248:  	LUT_DATA	= 	24'h583c_ec;
	SET_OV5640 + 249:  	LUT_DATA	= 	24'h583d_df;
	SET_OV5640 + 250:  	LUT_DATA	= 	24'h5025_00;
	SET_OV5640 + 251:  	LUT_DATA	= 	24'h3a0f_30;
	SET_OV5640 + 252:  	LUT_DATA	= 	24'h3a10_28;
	SET_OV5640 + 253:  	LUT_DATA	= 	24'h3a1b_30;
	SET_OV5640 + 254:  	LUT_DATA	= 	24'h3a1e_26;
	SET_OV5640 + 255:  	LUT_DATA	= 	24'h3a11_60;
	SET_OV5640 + 256:  	LUT_DATA	= 	24'h3a1f_14;
	SET_OV5640 + 257:  	LUT_DATA	= 	24'h3008_02;
	SET_OV5640 + 258:  	LUT_DATA	= 	24'h5300_08;
	SET_OV5640 + 259:  	LUT_DATA	= 	24'h5301_30;
	SET_OV5640 + 260:  	LUT_DATA	= 	24'h5302_10;
	SET_OV5640 + 261:  	LUT_DATA	= 	24'h5303_00;
	SET_OV5640 + 262:  	LUT_DATA	= 	24'h5304_08;
	SET_OV5640 + 263:  	LUT_DATA	= 	24'h5305_30;
	SET_OV5640 + 264:  	LUT_DATA	= 	24'h5306_08;
	SET_OV5640 + 265:  	LUT_DATA	= 	24'h5307_16;
	SET_OV5640 + 266:  	LUT_DATA	= 	24'h5309_08;
	SET_OV5640 + 267:  	LUT_DATA	= 	24'h530a_30;
	SET_OV5640 + 268:  	LUT_DATA	= 	24'h530b_04;
	SET_OV5640 + 269:  	LUT_DATA	= 	24'h530c_06;
	SET_OV5640 + 270:  	LUT_DATA	= 	24'h3c07_08;
	SET_OV5640 + 271:  	LUT_DATA	= 	24'h3820_40;	//上下翻转 flip 40/46
	SET_OV5640 + 272:  	LUT_DATA	= 	24'h3821_01;	//左右翻转 mirror
	SET_OV5640 + 273:  	LUT_DATA	= 	24'h3814_31;
	SET_OV5640 + 274:  	LUT_DATA	= 	24'h3815_31;
	SET_OV5640 + 275:  	LUT_DATA	= 	24'h3803_04;
	SET_OV5640 + 276:  	LUT_DATA	= 	24'h3807_9b;
	SET_OV5640 + 277:  	LUT_DATA	= 	24'h3808_02;
	SET_OV5640 + 278:  	LUT_DATA	= 	24'h3809_80;
	SET_OV5640 + 279:  	LUT_DATA	= 	24'h380a_01;
	SET_OV5640 + 280:  	LUT_DATA	= 	24'h380b_e0;
	SET_OV5640 + 281:  	LUT_DATA	= 	24'h380c_07;
	SET_OV5640 + 282:  	LUT_DATA	= 	24'h380d_68;
	SET_OV5640 + 283:  	LUT_DATA	= 	24'h380e_03;
	SET_OV5640 + 284:  	LUT_DATA	= 	24'h380f_d8;
	SET_OV5640 + 285:  	LUT_DATA	= 	24'h3813_06;
	SET_OV5640 + 286:  	LUT_DATA	= 	24'h3618_00;
	SET_OV5640 + 287:  	LUT_DATA	= 	24'h3612_29;
	SET_OV5640 + 288:  	LUT_DATA	= 	24'h3709_52;
	SET_OV5640 + 289:  	LUT_DATA	= 	24'h370c_03;
	SET_OV5640 + 290:  	LUT_DATA	= 	24'h3a02_03;
	SET_OV5640 + 291:  	LUT_DATA	= 	24'h3a03_d8;
	SET_OV5640 + 292:  	LUT_DATA	= 	24'h3a0e_03;
	SET_OV5640 + 293:  	LUT_DATA	= 	24'h3a0d_04;
	SET_OV5640 + 294:  	LUT_DATA	= 	24'h3a14_03;
	SET_OV5640 + 295:  	LUT_DATA	= 	24'h3a15_d8;
	SET_OV5640 + 296:  	LUT_DATA	= 	24'h4004_02;
	SET_OV5640 + 297:  	LUT_DATA	= 	24'h3035_11;
	SET_OV5640 + 298:  	LUT_DATA	= 	24'h3036_69;
	SET_OV5640 + 299:  	LUT_DATA	= 	24'h4837_22;
	SET_OV5640 + 300:  	LUT_DATA	= 	24'h5001_a3;
	SET_OV5640 + 301:  	LUT_DATA	= 	24'h3000_20;
	SET_OV5640 + 302:  	LUT_DATA	= 	24'h3022_00;
	SET_OV5640 + 303:  	LUT_DATA	= 	24'h3023_00;
	SET_OV5640 + 304:  	LUT_DATA	= 	24'h3024_00;
	SET_OV5640 + 305:  	LUT_DATA	= 	24'h3025_00;
	SET_OV5640 + 306:  	LUT_DATA	= 	24'h3026_00;
	SET_OV5640 + 307:  	LUT_DATA	= 	24'h3027_00;
	SET_OV5640 + 308:  	LUT_DATA	= 	24'h3028_00;
	SET_OV5640 + 309:  	LUT_DATA	= 	24'h3029_FF;
	SET_OV5640 + 310:  	LUT_DATA	= 	24'h3000_00;

	default			:	LUT_DATA	=	0;
	endcase
end
endmodule
