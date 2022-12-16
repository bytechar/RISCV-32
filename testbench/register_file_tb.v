`timescale 1ns / 1ps

module register_file_tb();
    
reg clk,rstn,we;
reg [4:0] rs1_addr, rs2_addr, rd_addr;
reg [31:0] rd_din;
wire [31:0] rs1_dout, rs2_dout;

register_file regfile1(
        .clk(clk),
        .rstn(rstn),
        .we(we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rs1_dout(rs1_dout),
        .rs2_dout(rs2_dout),
        .rd_din(rd_din)
);

reg rstn_f,we_f;
reg [4:0] rs1_addr_f, rs2_addr_f, rd_addr_f;
reg [31:0] rd_din_f, rs1_dout_f, rs2_dout_f;
integer file_test_cases;

parameter clock_period=15;
always #(clock_period/2) clk=~clk;

initial begin: REGISTER_FILE

   file_test_cases = $fopen("register_file.csv","r");
    if (file_test_cases == 0) begin
        $display("Could not open test cases file.");
        $stop;
    end
    $display("Opened test cases file.");
    
    clk = 0;    

    while( !$feof(file_test_cases)) begin
        
        if (rs1_dout !== rs1_dout_f) begin
            $display("rs1 output does not match expected value.");
            $stop;
        end  
        
        if (rs2_dout !== rs2_dout_f) begin
            $display("rs2 output does not match expected value.");
            $stop;
        end   
        
        #(clock_period/4);
 
        $fscanf(file_test_cases,"%b,%b,%d,%d,%d,%h,%h,%h",rstn_f,we_f,rs1_addr_f,rs2_addr_f,rd_addr_f,rd_din_f,rs1_dout_f,rs2_dout_f);
 
        rstn = rstn_f;
        we = we_f;
        rs1_addr = rs1_addr_f;
        rs2_addr = rs2_addr_f;
        rd_addr = rd_addr_f;
        rd_din = rd_din_f;     

        #(clock_period*3/4);                    
             
    end
    
    $fclose(file_test_cases);
    $display("All testcases passed!");

    $finish;
end

endmodule
