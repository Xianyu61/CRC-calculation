`timescale 1ns/1ns
module tb_crc4_d10_parallel();
    parameter   CRC_WIDTH  = 4 ; //CRC校验码宽度
    parameter   DATA_WIDTH = 5; //CRC校验数据长度
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
        data_in_parallel <= 5'b00000;
        crc_initial <= 4'b0000;
        
        #20
        rst_n = 1'b0;        
        #200
        rst_n = 1'b1;
        
        #20
        data_in_parallel <= 5'b10101;
        crc_en <= 1'b1;
        #20
        crc_en <= 1'b0;  
        #100
        $finish;               
    end

    always #10 clk = ~clk;
  

crc4_d10_parallel
#(
    .CRC_WIDTH (CRC_WIDTH ), //CRC校验码宽度
    .DATA_WIDTH(DATA_WIDTH)  //CRC校验数据长度
)
crc4_d10_parallel_inst
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
