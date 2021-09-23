`default_nettype none

module systolic
#
(
    parameter   D_W  = 8, //operand data width
    parameter   D_W_ACC = 16, //accumulator data width
    parameter   N1   = 4,
    parameter   N2   = 4,
    parameter   M    = 8
)
(
    input   wire                                        clk,
    input   wire                                        rst,
    input   wire                                        enable_row_count_A,
    output  wire    [$clog2(M)-1:0]                     pixel_cntr_A,
    output  wire    [($clog2(M/N1)?$clog2(M/N1):1)-1:0] slice_cntr_A,
    output  wire    [($clog2(M/N2)?$clog2(M/N2):1)-1:0] pixel_cntr_B,
    output  wire    [$clog2(M)-1:0]                     slice_cntr_B,
    output  wire    [$clog2((M*M)/N1)-1:0]              rd_addr_A,
    output  wire    [$clog2((M*M)/N2)-1:0]              rd_addr_B,
    input   wire    [D_W-1:0]                           A [N1-1:0], //m0
    input   wire    [D_W-1:0]                           B [N2-1:0], //m1
    output  wire    [D_W_ACC-1:0]                       D [N1-1:0], //m2
    output  wire    [N1-1:0]                             valid_D
);

wire    [D_W-1:0]         out_a      [N1-1:0][N2-1:0];
wire    [D_W-1:0]         out_b      [N1-1:0][N2-1:0];
wire    [D_W-1:0]         in_a       [N1-1:0][N2-1:0];
wire    [D_W-1:0]         in_b       [N1-1:0][N2-1:0];
wire    [N2-1:0]          in_valid   [N1-1:0];
wire    [N2-1:0]          out_valid  [N1-1:0];
wire    [(D_W_ACC)-1:0]   in_data    [N1-1:0][N2-1:0];
wire    [(D_W_ACC)-1:0]   out_data   [N1-1:0][N2-1:0];

reg     tmp_pe = 0;
reg     [N2+N1-2:0] init_pe = 0;
reg     idle = 0;

control #
(
  .N1       (N1),
  .N2       (N2),
  .M        (M),
  .D_W      (D_W),
  .D_W_ACC  (D_W_ACC)
)
control_inst
(

  .clk                  (clk),
  .rst                  (rst),
  .enable_row_count     (enable_row_count_A),

  .pixel_cntr_B         (pixel_cntr_B),
  .slice_cntr_B         (slice_cntr_B),

  .pixel_cntr_A         (pixel_cntr_A),
  .slice_cntr_A         (slice_cntr_A),

  .rd_addr_A            (rd_addr_A),
  .rd_addr_B            (rd_addr_B)
);

always @(posedge clk) begin
  if(pixel_cntr_A == M-1) begin
        tmp_pe <= 1;
        idle <= 1;
        init_pe <= init_pe << 1;
  end else if (tmp_pe == 1)begin
        tmp_pe <= 0;
        init_pe <= (init_pe << 1) + 1;
  end else if (idle == 1)begin
        init_pe <= init_pe << 1;
  end
end


genvar k;
generate
for (k=0; k<=N1-1; k=k+1) begin
    assign in_a[k][0] = A[k];
    assign in_b[0][k] = B[k];

end
endgenerate

genvar i,j;
generate
for (i=0; i<=N1-1; i=i+1) begin
  for (j=0; j<=N2-1; j=j+1) begin
    pe #
    (

    .D_W      (D_W),
    .D_W_ACC  (D_W_ACC)
  )
     pe_inst (
              .clk   (clk),
              .rst   (rst),
              .in_a  (in_a[i][j]),
              .in_b  (in_b[i][j]),
              .init  (init_pe[i+j]),
              .out_a (out_a[i][j]),
              .out_b (out_b[i][j]),
              .in_data  (in_data[i][j]),
              .in_valid (in_valid[i][j]),
              .out_data (out_data[i][j]),
              .out_valid (out_valid[i][j])
      );
    if(j!=N2-1) begin
        assign in_a [i][j+1] = out_a[i][j];
        assign in_data[i][j+1] = out_data[i][j];
    end
    if(i!=N1-1)begin
        assign in_b [i+1][j] = out_b[i][j];
    end
    if(j!=0)begin
            assign in_valid[i][j] = out_valid[i][j-1];
    end else begin
            assign in_valid[i][j] = 0;
    end
    if(j==N2-1)begin
        assign D[i] = out_data[i][j];
        assign valid_D[i] = out_valid[i][j];
    end
  end
end
endgenerate

endmodule
              
