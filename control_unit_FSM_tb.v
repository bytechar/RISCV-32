`timescale 1ns / 1ps

module control_unit_FSM_TB();

    reg clk; 
    reg rstn;
    
    // DECODER generated signals
    reg load;
    reg store;
    reg branch;
    reg fence;
    reg [3:0] decoder_dmem_we;
    reg halt;
    
     // pc
    wire pc_we;                     // PC write enable
    // IMem
    wire imem_rd;                   // IMem read enable
    // regfile
    wire rf_we;                      // reg file write enable
    // Dmem
    wire[3:0] dmem_we;             // dmem write enable
    wire dmem_rd;
    
    FSM_control_unit DUT(.clk(clk), .rstn(rstn), .load(load), 
                         .store(store), .branch(branch), .fence(fence),
                         .decoder_dmem_we(decoder_dmem_we), .halt(halt),
                         .pc_we(pc_we), .imem_rd(imem_rd), .rf_we(rf_we),
                         .dmem_we(dmem_we), .dmem_rd(dmem_rd));
    
    // clk gen
    initial clk = 0;
    always #10 clk = ~clk;
    
    //intial block to test
    initial begin
    
    rstn <= 0;
    
    // test R type
    load <= 0;
    store <= 0;
    branch <= 0;
    fence <= 0;
    decoder_dmem_we <= 0;
    halt <= 0;
    
    #120; 
    
    // test store
    rstn <=0;
    load <= 0;
    store <= 1;
    branch <= 0;
    fence <= 0;
    decoder_dmem_we <= 4'b1111;
    halt <= 0;
    
    #120;
    
    //test load
    rstn <=0;
    load <= 1;
    store <= 0;
    branch <= 0;
    fence <= 0;
    decoder_dmem_we <= 0;
    halt <= 0;
    
    #120;
    
    //test branch
    rstn <=0;
    load <= 0;
    store <= 0;
    branch <= 1;
    fence <= 0;
    decoder_dmem_we <= 0;
    halt <= 0;
    
    #120;
    
    //test halt
    rstn <=0;
    load <= 1;
    store <= 1;
    branch <= 0;
    fence <= 0;
    decoder_dmem_we <= 4'b1111;
    halt <= 1; 
    #120;
    
    //test fence
    rstn <=0;
    load <= 1;
    store <= 0;
    branch <= 1;
    fence <= 1;
    decoder_dmem_we <= 4'b1111;
    halt <= 0;  
    #120;
      
    #120;
    $finish(); 
     
    end
    
endmodule
