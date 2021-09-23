`timescale 1 ps / 1 ps

module mm_tb
#(
    parameter D_W = 8,        //operand data width
    parameter D_W_ACC = 16,   //accumulator data width
    parameter N1 = 4,
    parameter N2 = 4,
    parameter M = 8
)
();

reg clk=1'b0;
reg fclk=1'b0;
reg [1:0] rst;
wire rst_n;

reg [D_W_ACC-1:0] mem2 [0:M*M-1];
reg [D_W-1:0] mem0 [0:(M*M)-1];
reg [D_W-1:0] mem1 [0:(M*M)-1];

reg in_last;
reg in_valid;
reg [D_W-1:0] in_data;
reg [$clog2(2*M*M)-1:0] rdaddr;
reg [$clog2(M*M)-1:0] wraddr;
reg out_last_r;
wire in_ready;

wire out_last;
wire out_valid;
wire [D_W_ACC-1:0] out_data;

initial begin
  $readmemh("A.mem", mem0);
  $readmemh("B.mem", mem1);
end

// send data into mm.sv
always@(posedge clk)
begin
  if (rst[0]) begin
    in_valid <= 1'b0;
    in_data <= 0;
    in_last <= 1'b0;
    rdaddr <= 0;
  end else begin
    in_valid <= ~in_last;
    in_data <= 0;
    if(in_ready && ~in_last) begin
      rdaddr <= rdaddr + 1;
      // generat tlast
      if(rdaddr == 2*M*M-1) begin
        in_last <= 1'b1;
      end
      // mux in the right data
      if(rdaddr < M*M) begin
        in_data <= mem0[rdaddr];
      end else if(rdaddr < 2*M*M) begin
        in_data <= mem1[rdaddr-M*M];
      end else begin
        in_data <= 0;
      end
    end
  end
end

// add exclusion for timing simulation
mm 
`ifndef XIL_TIMING
#(
  .D_W     (D_W),
  .D_W_ACC (D_W_ACC),
  .N1      (N1),
  .N2      (N2),
  .M       (M)
)
`endif
mm_dut 
(
  .mm_clk                (clk), 
  .mm_fclk               (fclk), 
  .mm_rst_n              (~rst[0]),
  .s_axis_s2mm_tvalid    (in_valid),
  .s_axis_s2mm_tdata     ({{32-D_W{1'b0}},in_data}),
  .s_axis_s2mm_tkeep     (),
  .s_axis_s2mm_tlast     (in_last),
  .s_axis_s2mm_tready    (in_ready),

  .m_axis_mm2s_tvalid    (out_valid),
  .m_axis_mm2s_tdata     (out_data),
  .m_axis_mm2s_tkeep     (),
  .m_axis_mm2s_tlast     (out_last),
  .m_axis_mm2s_tready    (1'b1) // testbench is always ready for now
);

`ifndef XIL_TIMING
always #10000 clk = ~clk;
always #4000 fclk = ~fclk;
`else
always #50000 clk = ~clk;
always #20000 fclk = ~fclk;
`endif

initial
begin
    $timeformat(-9, 2, " ns", 20);
    rst = 2'b11;
end

always @(posedge clk) begin
  rst <= rst>>1;
end

always@(posedge clk)
begin
  if(rst[0]) begin
    wraddr <= 0;
    out_last_r <= 1'b0;
  end else begin
    out_last_r <= out_last;
    if(out_valid) begin
      wraddr <= wraddr == M*M-1 ? 0 : wraddr + 1;
      mem2[wraddr] <= out_data[D_W_ACC-1:0];
    end
    if (out_last_r) begin
      $finish;
    end
  end
end

initial begin
  repeat(5*M*M*M) @(posedge clk);
  $display("Timed out");
  $finish;
end

final begin
  $writememh("D.mem", mem2);
end

endmodule
