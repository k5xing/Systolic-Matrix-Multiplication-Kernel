`timescale 1 ps / 1 ps

module pe
#(
    parameter   D_W_ACC  = 64, //accumulator data width
    parameter   D_W      = 32  //operand data width
)
(
    input   wire                    clk,
    input   wire                    rst,
    input   wire                    init,
    input   wire    [D_W-1:0]       in_a,
    input   wire    [D_W-1:0]       in_b,
    output  reg     [D_W-1:0]       out_b,
    output  reg     [D_W-1:0]       out_a,

    input   wire    [(D_W_ACC)-1:0] in_data,
    input   wire                    in_valid,
    output  reg     [(D_W_ACC)-1:0] out_data,
    output  reg                     out_valid
);

// Insert your RTL here
reg valid;
reg [D_W_ACC-1:0] out_sum;
reg [D_W_ACC-1:0] out_in;
always @(posedge clk) begin
    if(rst) begin
      out_b <=0;
      out_a <= 0;
      out_valid <= 0;
      out_data <=0;
      valid <= 0;
      out_sum <= 0;
      out_in <= 0;
    
    end else begin
      if(init) begin
        out_a <= in_a;
        out_b <= in_b;
        out_valid <= 1;
        out_data <= out_sum;
        valid <= in_valid;
        out_sum <= in_a*in_b;
        out_in <= in_data;
        
 
      end else begin
        out_a <= in_a;
        out_b <= in_b;
        out_valid <= valid;
        out_data <= out_in;
        valid <=in_valid;
        out_sum <= out_sum + in_a*in_b;
        out_in <= in_data;
      end
        

    end
  end


endmodule
