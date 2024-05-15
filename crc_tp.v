module crc_tp(
    input clk,// 系统时钟
    input rxd,// UART接收数据线
    output txd,// UART发送数据线
	 input button,// 输入按钮
	 output reg [7:0] tx_data, // 要发送的数据
	 output reg tx_data_en  // 发送数据使能
);

wire rx_data_en;
wire [7:0] rx_data;

reg [7:0] crc_initial;
reg [7:0] data_in_parallel;
wire [7:0] data_out;
wire dout_vld;
wire crc_en;

initial begin
	crc_initial <= 0;
end

always @(posedge clk) begin
	if (dout_vld==1'b1) begin
		tx_data_en <= 1'b1;
		tx_data<= data_out;
		crc_initial <= data_out;
	end
	else if(e==1'b1) begin
		crc_initial <=0;
		tx_data_en<=1'b0;
	end
	else
		tx_data_en<=1'b0;
end

reg sample_enable;
reg key_in;
wire clear_key;
wire p;
reg a;
wire e;
// UART接收实例
uart_receive inst1(
    .clk(clk),
    .rx(rxd),
    .data_en(rx_data_en),
    .data_out(rx_data)
);
// UART发送实例
uart_send inst2(
    .clk(clk),
    .rst(1'b0),
    .data_in(tx_data),
    .data_en(tx_data_en),
    .tx(txd),
    .busy()
);
// CRC计算模块实例
crc inst3(
	.clk(clk),
	.rst_n(e),
	.crc_initial(crc_initial),
	.data_in_parallel(rx_data),
	.data_out(data_out),
	.dout_vld(dout_vld),
	.crc_en(rx_data_en)
);
// 消抖模块实例
clear_key inst4(
    .clk(clk),
	 .sample_enable(p),
    .key_in(button),
	 .clear_key(clear_key)
);
// 键值采样模块实例
maichong inst5(
    .clk(clk),
    .p(p)
);
// 下降沿检测模块实例
xiajiang inst6(
    .clk(clk),
    .a(clear_key),
	 .e(e)
);


endmodule