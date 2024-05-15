`timescale 1ns / 1ps

module uart_send(
    input clk,//50M
    input rst, // 复位信号
    input [7:0] data_in,// 8位数据输入
	 input data_en, // 数据使能信号
    output tx,// UART发送端口
	 output reg busy// busy
);

parameter STOP = 0;// 停止位数目，这里设为0意味着没有停止位
parameter DIV_NUM = 5208;// 分频数，用于生成波特率
parameter WIDTH = 13;// 分频器宽度

reg [8:0]sfg;// 用于存储要发送的数据和起始位
reg [3:0]cnt; // 发送数据计数器
reg send_en; // 发送使能信号
reg [WIDTH-1:0]send_cnt;// 分频计数器

initial begin
    busy <= 1'b0;
    cnt <= 4'd0;
    sfg = 9'b1_1111_1111;
	 send_en <= 1'b0;
	 send_cnt <= 1'b0;
end

always @(posedge clk)
begin
    if(rst)begin // 复位逻辑
        busy <= 1'b0;
        sfg = 9'b1_1111_1111;
        cnt <= 4'd0; 
		  send_en <= 1'b0;
		  send_cnt <= 1'b0;
    end else begin
        if({busy,data_en}==2'b01)begin    // 准备发送数据
            sfg[8:0] <= {data_in[7:0],1'b0};// 加载数据和起始位
            busy <= 1'b1;
            cnt <= 4'd0; 
				send_cnt <= 1'b0;
        end else  if(send_cnt==DIV_NUM)begin
		      send_cnt <= 1'b0;      // 发送数据
            if(cnt == 4'd8+STOP)begin
                cnt <= 4'd0; 
                busy <= 1'b0;
            end else begin
                cnt <= cnt + 4'd1;                
            end
            sfg[8:0] <= {1'b1,sfg[8:1]};// 移位，准备发送下一个位
		  end else begin
				send_cnt <= send_cnt + 1'b1;
        end
    end
end

assign tx = sfg[0];// 输出当前位

endmodule
