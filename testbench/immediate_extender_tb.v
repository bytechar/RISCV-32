`timescale 1ns / 1ps

module imm_ext_tb( );

    reg [31:0] instr;
    wire [31:0] ext_imm;
    
    imm_ext DUT(.instr(instr), .immediate(ext_imm));

    reg error_count = 0;
    
    initial begin

        #5;

        instr <= 32'hffdff0ef;      //J-type

        #10;

         if(ext_imm!=32'hfffffffc) begin
            $error("Output mismatch");
            error_count = error_count + 1;
            end

         #10;

        instr <= 32'h02830283;      //I-type

        #10;

         if(ext_imm!=32'h00000028) begin
            $error("Output mismatch");
            error_count = error_count + 1;
            end

         #10;

        instr <= 32'hfe9246e3;      //B-type

        #10;

         if(ext_imm!=32'hffffffec) begin
            $error("Output mismatch");
            error_count = error_count + 1;
            end

         #10;

        instr <= 32'h00129023;      //S-type

        #10;

         if(ext_imm!=32'h00000000) begin
            $error("Output mismatch");
            error_count = error_count + 1;
            end

         #10;

        instr <= 32'h00001117;      //U-type

        #10;

         if(ext_imm!=32'h00001000) begin
            $error("Output mismatch");
            error_count = error_count + 1;
            end

         #10;

         $display("All test cases passed");

        $finish;

    end

endmodule
