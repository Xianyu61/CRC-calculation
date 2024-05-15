`timescale 1ns/1ns//时间单位和时间精度
module tb_crc();
    parameter   CRC_WIDTH  = 8 ; 
    parameter   DATA_WIDTH = 8; 
    reg                         clk             ;
    reg                         rst_n           ;
    reg                         crc_en          ;
    reg     [CRC_WIDTH-1:0]     crc_initial     ;
    reg     [DATA_WIDTH-1:0]    data_in_parallel;
    wire    [CRC_WIDTH-1:0]     data_out        ;
    wire                        dout_vld        ;

    initial begin
        clk = 1'b0;
        rst_n = 1'b1;
        crc_en <= 1'b0;
        data_in_parallel <= 8'b0;
        crc_initial <= 8'b0;
        
        #20
        rst_n = 1'b1;        
        #200
        rst_n = 1'b0;
        
        #20
        data_in_parallel <= 8'b10101010;
        crc_en <= 1'b1;
        #20
        crc_en <= 1'b0;  
		  #20
		  crc_en <= 1'b1;
		  data_in_parallel <= 8'b11110000;
		  crc_initial <= 8'b01011111;
		  #20
		  crc_en <= 1'b0;
		  crc_initial <= 8'b01000100;
        #100
        $finish;               
    end

    always #10 clk = ~clk;
  

crc
#(
    .CRC_WIDTH (CRC_WIDTH ), 
    .DATA_WIDTH(DATA_WIDTH)  
)
crc_inst
(
    .clk                (clk                ),
    .rst_n              (rst_n              ),
    .crc_en             (crc_en             ),
    .crc_initial        (crc_initial        ),      
    .data_in_parallel   (data_in_parallel   ),
    .data_out           (data_out           ),
    .dout_vld           (dout_vld           )
);

endmodule