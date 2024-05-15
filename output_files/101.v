`timescale 1ns/1ns

module crc4_d10_parallel
#(
    parameter   CRC_WIDTH  = 4, //CRC校验码宽度
    parameter   DATA_WIDTH = 5  //CRC校验数据长度
)
(
    input   wire                        clk             , //时钟信号
    input   wire                        rst_n           , //复位信号
    input   wire                        crc_en          , //CRC校验使能信号
    input   wire    [CRC_WIDTH-1:0]     crc_initial     , //寄存器初始值
    input   wire    [DATA_WIDTH-1:0]    data_in_parallel, //输入校验数据（串行）
    output  wire    [CRC_WIDTH-1:0]     data_out        , //输出CRC校验码（并行输出）
    output  wire                        dout_vld          //输出CRC校验码有效信号
);

reg    [CRC_WIDTH-1:0]     r_data_out;
reg                        r_dout_vld;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_data_out <= 'd0;
    else if(crc_en)begin
        r_data_out[3] <= crc_initial[1] ^ crc_initial[2] ^ data_in_parallel[2] ^ data_in_parallel[3];
        r_data_out[2] <= crc_initial[0] ^ crc_initial[1] ^ crc_initial[3] ^ data_in_parallel[1] ^ data_in_parallel[2] ^ data_in_parallel[4];
        r_data_out[1] <= crc_initial[0] ^ crc_initial[2] ^ data_in_parallel[0] ^ data_in_parallel[1] ^ data_in_parallel[3];
        r_data_out[0] <= crc_initial[2] ^ crc_initial[3] ^ data_in_parallel[0] ^ data_in_parallel[3] ^ data_in_parallel[4];
    end
    else
        r_data_out <= 'd0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        r_dout_vld <= 1'b0;
    else if(crc_en)
        r_dout_vld <= 1'b1;
    else
        r_dout_vld <= 1'b0;
end

assign data_out = r_data_out;
assign dout_vld = r_dout_vld;

endmodule
