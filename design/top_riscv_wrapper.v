`timescale 1ns / 1ps
`include "defines.vh"
`default_nettype none

module top_riscv_wrapper
    #(parameter data_width = 32)(
    input wire clk,btnU,
    input wire [15:0] sw,
    output wire [15:0] led,
    output wire [6:0] seg,
    output wire [3:0] an
    );

wire rstn;
assign rstn = ~btnU;

wire is_LUI, is_AUIPC, is_JAL, is_JALR, is_BRANCH, is_LOAD, is_STORE, is_IMM, is_ALU, is_FENCE, is_SYSTEM;
wire is_SYSTEM_or_pc_halt;

assign seg = 7'h00;
assign an = is_SYSTEM_or_pc_halt ? 4'hF : 4'h0;

wire pc_we, pc_imm_en, halt_from_pc, imem_rd, imem_rd_and_not_halt, rf_we, dmem_rd, branch_out;
wire [3:0] dmem_we, decoder_dmem_we;

wire [31:0] instr_addr;
wire [data_width - 1:0] instruction;

wire [31:0] immediate, rs1_dout, rs2_dout, rd_din;
wire [31:0] alu_ina, alu_inb, alu_out;
wire [31:0] dmem_out;

wire alu_inb_imm_select, alu_ina_pc_select, rd_din_pc_select;

wire [4:0] rs1_addr, rs2_addr, rd_addr;
wire [3:0] alu_select;
wire [2:0] branch_select, load_select;

assign is_SYSTEM_or_pc_halt = is_SYSTEM || halt_from_pc;

Control_Unit CONTROL(.clk(clk),
                     .rstn(rstn),
                     .decoder_dmem_we(decoder_dmem_we),
                     .is_BRANCH(is_BRANCH),
                     .is_LOAD(is_LOAD),
                     .is_STORE(is_STORE),
                     .is_FENCE(is_FENCE),
                     .is_SYSTEM(is_SYSTEM_or_pc_halt),
                     .pc_we(pc_we),
                     .imem_rd(imem_rd),
                     .rf_we(rf_we),
                     .dmem_rd(dmem_rd),
                     .dmem_we(dmem_we)
                     );

assign pc_imm_en = is_JAL || is_JALR || (is_BRANCH && branch_out) ;

program_counter PC(.clk(clk),
                   .rstn(rstn),
                   .imm(pc_imm_en),
                   .we(pc_we),
                   .imm_addr(alu_out),
                   .instr_addr(instr_addr),
                   .halt(halt_from_pc)
                   );

assign imem_rd_and_not_halt = imem_rd && ~halt_from_pc;

instruction_mem IMEM(.clk(clk),
                     .rd(imem_rd_and_not_halt),
                     .instr_addr(instr_addr),
                     .instr(instruction)
                     );

Decoder ID(.instruction(instruction),
           .rs1(rs1_addr),
           .rs2(rs2_addr),
           .rd(rd_addr),
           .alu_select(alu_select),
           .bc_select(branch_select),
           .load_select(load_select),
           .we(decoder_dmem_we),
           .alu_inb_imm_select(alu_inb_imm_select),
           .alu_ina_pc_select(alu_ina_pc_select),
           .rd_din_pc_select(rd_din_pc_select),
           .immediate(immediate),
           .is_LUI(is_LUI),
           .is_AUIPC(is_AUIPC),
           .is_JAL(is_JAL),
           .is_JALR(is_JALR),
           .is_BRANCH(is_BRANCH),
           .is_LOAD(is_LOAD),
           .is_STORE(is_STORE),
           .is_IMM(is_IMM),
           .is_ALU(is_ALU),
           .is_FENCE(is_FENCE),
           .is_SYSTEM(is_SYSTEM)
           );

assign rd_din = rd_din_pc_select ? (instr_addr+4) : ( is_LOAD ? dmem_out : alu_out );

register_file RF(.clk(clk),
                 .rstn(rstn),
                 .we(rf_we),
                 .rs1_addr(rs1_addr),
                 .rs2_addr(rs2_addr),
                 .rd_addr(rd_addr),
                 .rd_din(rd_din),
                 .rs1_dout(rs1_dout),
                 .rs2_dout(rs2_dout)
                 );

branch_comp BC(.branch_op(branch_select),
               .data_in1(rs1_dout),
               .data_in2(rs2_dout),
               .branch_out(branch_out)
               );

assign alu_ina = alu_ina_pc_select ? instr_addr : rs1_dout;
assign alu_inb = alu_inb_imm_select ? immediate : rs2_dout;

ALU EX(.in_a(alu_ina),
       .in_b(alu_inb),
       .alu_select(alu_select),
       .result(alu_out)
       );

DMem DMEM(.clk(clk),
          .rstn(rstn),
          .rd(dmem_rd),
          .we(dmem_we),
          .load_select(load_select),
          .addr_in(alu_out),
          .data_in(rs2_dout),
          .data_out(dmem_out),
          .sw(sw),
          .led(led)
          );
    
endmodule
