`timescale 1ns/1ns

module crc
#(
    parameter   CRC_WIDTH  = 8, // CRC宽度，这里设置为8位
    parameter   DATA_WIDTH = 8  // 数据宽度，这里也设置为8位
)
(
    input   wire                        clk             ,  // 时钟信号
    input   wire                        rst_n           ,// 低电平有效的复位信号
    input   wire                        crc_en          ,  // CRC使能信号
    input   wire    [CRC_WIDTH-1:0]     crc_initial     ,  // CRC初始值
    input   wire    [DATA_WIDTH-1:0]    data_in_parallel,  // 并行数据输入
    output  wire    [CRC_WIDTH-1:0]     data_out        , // CRC输出
    output  wire                        dout_vld         // 输出有效信号

);
reg  r_dout_vld;// 用于输出有效信号的寄存器
reg [CRC_WIDTH-1:0]   r_data_out; // 用于存储计算结果的寄存器
always @(posedge clk) begin
    if(rst_n==1'b1)
        r_data_out <= 8'd0;
    else if(crc_en)begin
		r_data_out[0] <= data_in_parallel[7] ^ data_in_parallel[6] ^ data_in_parallel[0] ^ crc_initial[0] ^ crc_initial[6] ^ crc_initial[7];
		r_data_out[1] <= data_in_parallel[6] ^ data_in_parallel[1] ^ data_in_parallel[0] ^ crc_initial[0] ^ crc_initial[1] ^ crc_initial[6];
		r_data_out[2] <= data_in_parallel[6] ^ data_in_parallel[2] ^ data_in_parallel[1] ^ data_in_parallel[0] ^ crc_initial[0] ^ crc_initial[1] ^ crc_initial[2] ^ crc_initial[6];
		r_data_out[3] <= data_in_parallel[7] ^ data_in_parallel[3] ^ data_in_parallel[2] ^ data_in_parallel[1] ^ crc_initial[1] ^ crc_initial[2] ^ crc_initial[3] ^ crc_initial[7];
		r_data_out[4] <= data_in_parallel[4] ^ data_in_parallel[3] ^ data_in_parallel[2] ^ crc_initial[2] ^ crc_initial[3] ^ crc_initial[4];
		r_data_out[5] <= data_in_parallel[5] ^ data_in_parallel[4] ^ data_in_parallel[3] ^ crc_initial[3] ^ crc_initial[4] ^ crc_initial[5];
		r_data_out[6] <= data_in_parallel[6] ^ data_in_parallel[5] ^ data_in_parallel[4] ^ crc_initial[4] ^ crc_initial[5] ^ crc_initial[6];
		r_data_out[7] <= data_in_parallel[7] ^ data_in_parallel[6] ^ data_in_parallel[5] ^ crc_initial[5] ^ crc_initial[6] ^ crc_initial[7];
    end
    else
      r_data_out <= 8'd0; // 若CRC未使能，输出清零
end


always @(posedge clk) begin
    if(rst_n==1'b1)
        r_dout_vld <= 1'b0;// 在复位时，将输出有效信号清零
    else if(crc_en)
        r_dout_vld <= 1'b1;// 当CRC使能时，设置输出有效信号为高
    else
        r_dout_vld <= 1'b0;// 否则，输出有效信号为低
end

assign data_out = r_data_out;// 将寄存器值分配给输出
assign dout_vld = r_dout_vld;// 将输出有效信号的寄存器值分配给输出

endmodule


   
