`timescale 1 ps / 1 ps

module control_tb
#(
	parameter D_W     = 8,
	parameter D_W_ACC = 16,
	parameter N1 = 4,
	parameter N2 = 8,
	parameter M = 16
)
();

localparam MEM_SZ = (M/N1) * (M/N2) * M * 2; // x2 because we are storing rd_addr_A and rd_addr_B for one time cycle

reg                                       clk=1'b0;
reg     [1:0]                             rst;

wire    [$clog2((M*M)/N1)-1:0]				tb_rd_addr_A;
wire    [$clog2((M*M)/N2)-1:0]				tb_rd_addr_B;
wire    [$clog2(M)-1:0]						tb_pixel_cntr_A;
wire    [($clog2(M/N1)?$clog2(M/N1):1)-1:0] tb_slice_cntr_A;
wire    [($clog2(M/N2)?$clog2(M/N2):1)-1:0] tb_pixel_cntr_B;
wire    [$clog2(M)-1:0]						tb_slice_cntr_B;

reg     [D_W_ACC-1:0]   mem [MEM_SZ-1:0];
integer addr = 0;
reg enable_row_count_A = 0;

final begin
	localparam filename = $sformatf("CONTROL_OUT.%0d.%0d.%0d.mem",M, N1, N2);
	$writememh(filename, mem);
end

always @(posedge clk) begin
	if (addr < MEM_SZ && rst[0] == 1'b0) begin
		mem[addr] <= tb_rd_addr_A;
		mem[addr + 1] <= tb_rd_addr_B;
		addr <= (addr + 2);
	end else if (addr >= MEM_SZ) begin
		$finish;
	end
end

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

  .pixel_cntr_B         (tb_pixel_cntr_B),
  .slice_cntr_B         (tb_slice_cntr_B),

  .pixel_cntr_A         (tb_pixel_cntr_A),
  .slice_cntr_A         (tb_slice_cntr_A),

  .rd_addr_A            (tb_rd_addr_A),
  .rd_addr_B            (tb_rd_addr_B)
);

reg [31:0]  patch =1;

always@(posedge clk) begin
    if(rst[0]) begin
        enable_row_count_A <= 1'b0;
        patch <= 1;
    end else begin
        if (enable_row_count_A == 1'b1) begin
            enable_row_count_A <= 1'b0;
        end else if (tb_pixel_cntr_A == M-2 && patch == (M/N2)) begin
            patch <= 1;
            enable_row_count_A <= ~enable_row_count_A;
        end else if (tb_pixel_cntr_A == M-2) begin
            patch <= patch + 1 ;
        end
    end
end

always #1 clk = ~clk;

initial begin
	$timeformat(-9, 2, " ns", 20);
	rst = 2'b11;
end

always @(posedge clk) begin
	rst <= rst>>1;
end

endmodule
