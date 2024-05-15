`timescale 1ns / 1ps

module uart_receive(
    input clk,//50M 
    input rx,//uart rx
    output reg data_en,// 数据有效信号
    output reg [7:0] data_out// 8位并行数据输出
    );
    
	initial data_en <= 1'b0;
	initial data_out <= 8'd0;
		
	parameter DIV_NUM = 1736;//clk/baudrate/3  // 分频数，用于确定采样点
	parameter WIDTH = 11;//DIV_NUM  width// 分频器宽度

	//input buffer
	reg  [1:0]rx_buf;// 接收缓冲，用于边沿检测
	reg [WIDTH-1:0] cnt;// 计数器，用于分频
	reg [1:0]state;
	//3x sample buffer
	reg [1:0]samples;// 采样缓冲，用于多数表决逻辑
	reg [2:0]rev_cnt; // 接收位计数器
	reg [1:0]cnt3;   //3倍采样
	reg [7:0]data_sfg; // 最终数据寄存器

	initial cnt <= {WIDTH{1'b0}};
	initial state <= 2'b00;
	initial rx_buf <= 2'b0;
	initial rev_cnt <= 3'b0; 
	initial data_sfg <= 8'd0;

	always @(posedge clk)
	begin
		rx_buf[1:0] <= {rx_buf[0],rx};// 边沿检测，用于识别起始位
		case(state)
		2'b00:begin   //开始接受
			if(rx_buf==2'b10)begin
				cnt <= (DIV_NUM-1)/2;// 设置计数器到中间采样点
				cnt3 <= 2'b00;     
				state <= 2'b01; // 转到确认起始位状态
			end else begin
				cnt <= {WIDTH{1'b0}};
			end
			data_en <= 1'b0; // 数据尚未有效
		end
		2'b01:begin   //确认起始位
			if(cnt == DIV_NUM-1)begin
				cnt <= {WIDTH{1'b0}};
				samples <= {samples[0],rx_buf[1]};
				if(cnt3==2'b10)begin
					if({samples[1:0],rx_buf[1]}==3'b000)begin
						state <= 2'b10;
						cnt3 <= 2'b00;
						rev_cnt <= 4'd0;
					end else begin
						state <= 2'b00;
					end
				end else begin
					cnt3 <= cnt3 + 2'b01;
				end
			end else begin
				cnt <= cnt + {{(WIDTH-1){1'b0}},1'b1};
			end
		end
		2'b10:begin     //接收状态
			if(cnt == DIV_NUM-1)begin
				cnt <= {WIDTH{1'b0}};
				samples <= {samples[0],rx_buf[1]};// 存储采样点
				if(cnt3==2'b10)begin
					cnt3 <= 2'b00;
					data_sfg[6:0] <= data_sfg[7:1];
					case ({samples[1:0],rx_buf[1]})
						3'b011   : data_sfg[7] <= 1'b1;
						3'b101   : data_sfg[7] <= 1'b1;
						3'b110   : data_sfg[7] <= 1'b1;
						3'b111   : data_sfg[7] <= 1'b1;					
						default : data_sfg[7] <= 1'b0;
					endcase
					if(rev_cnt == 3'd7)begin
						rev_cnt <= 3'd0;
						state <= 2'b11;// 数据接收完成，转到输出状态
					end else begin
						rev_cnt <= rev_cnt + 3'd1;
					end
				end else begin
					cnt3 <= cnt3 + 2'b01;
				end
			end else begin
				cnt <= cnt + {{(WIDTH-1){1'b0}},1'b1};
			end
		end
		2'b11:begin    //输出
			state <= 2'b00;
			data_en <= 1'b1;
			data_out <= data_sfg[7:0];
		end
		endcase        
	end
endmodule