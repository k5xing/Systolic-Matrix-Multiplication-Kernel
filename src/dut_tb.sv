`timescale 1 ps / 1 ps

module dut_tb
#(
    parameter D_W = 8,        //operand data width
    parameter D_W_ACC = 16,   //accumulator data width
    parameter N1 = 4,
    parameter N2 = 4,
    parameter M = 8
)
();

reg                                 clk=1'b0;
reg     [1:0]                       rst;

reg                              rd_en_A=0;
reg                              rd_en_B=0;
wire    [N1-1:0]                 rd_en_A_pipe;
wire    [N2-1:0]                 rd_en_B_pipe;
wire    [$clog2((M*M)/N1)-1:0]    rd_addr_A;
wire    [$clog2((M*M)/N2)-1:0]    rd_addr_B;
wire    [$clog2((M*M)/N1)-1:0]    rd_addr_A_bram [N1-1:0];
wire    [$clog2((M*M)/N2)-1:0]    rd_addr_B_bram [N2-1:0];
wire    [$clog2(M)-1:0]          pixel_cntr_A;
wire    [($clog2(M/N1)?$clog2(M/N1):1)-1:0]        slice_cntr_A;
wire    [($clog2(M/N2)?$clog2(M/N2):1)-1:0]        pixel_cntr_B;
wire    [$clog2(M)-1:0]          slice_cntr_B;
reg     [D_W-1:0]                A_pipe    [N1-1:0];
reg     [D_W-1:0]                B_pipe    [N2-1:0];
wire    [D_W_ACC-1:0]            D    [N1-1:0];
reg     [D_W_ACC-1:0]            mem2       [0:M*M-1];

reg     [D_W-1:0]                mem0       [0:(M*M)-1];
reg     [D_W-1:0]                mem1       [0:(M*M)-1];

initial begin
    $readmemh("A.mem", mem0);
end
initial begin
    $readmemh("B.mem", mem1);
end

always@(posedge clk) begin
    if (rst[0]) begin
        rd_en_A <= 0;
        rd_en_B <= 0;
    end else begin
        rd_en_A <= 1;
        rd_en_B <= 1;
    end
end

mem_read_A
#
(
    .D_W    (D_W),
    .N      (N1),
    .M      (M)
)
mem_read_A_inst
(
    .clk           (clk),
    .rd_addr       (rd_addr_A),
    .rd_en         (~rst[0]),
    .rd_addr_bram  (rd_addr_A_bram),
    .rd_en_bram    (rd_en_A_pipe)     
);
mem_read_B
#
(
    .D_W    (D_W),
    .N      (N2),
    .M      (M)
)
mem_read_B_inst
(
    .clk           (clk),
    .rd_addr       (rd_addr_B),
    .rd_en         (~rst[0]),
    .rd_addr_bram  (rd_addr_B_bram),
    .rd_en_bram    (rd_en_B_pipe)     
);

genvar x;

for(x=0;x<N1;x=x+1) begin
    always@(posedge clk) begin
        if (rst[0]==1'b0) begin
            if (rd_en_A_pipe[x]) begin
                A_pipe[x]  <= mem0[((x*M*M)/N1) + rd_addr_A_bram[x]];
            end else begin
                A_pipe[x]  <= 0;
            end
        end else begin
            A_pipe[x]  <= 0;
        end
    end
end
for(x=0;x<N2;x=x+1) begin
    always@(posedge clk) begin
        if (rst[0]==1'b0) begin
            if (rd_en_B_pipe[x]) begin
                B_pipe[x]  <= mem1[((x*M*M)/N2) + rd_addr_B_bram[x]];
            end else begin
                B_pipe[x]  <= 0;
            end
        end else begin
            B_pipe[x]  <= 0;
        end
    end
end

wire [N2-1:0] init_pe_pipe  [N1-1:0];
reg           enable_row_count_A = 0;
wire [N1-1:0] valid_D    ;

// add exclusion for timing simulation
systolic 
`ifndef XIL_TIMING
#(
    .D_W     (D_W),
    .D_W_ACC (D_W_ACC),
    .N1      (N1),
    .N2      (N2),
    .M       (M)
)
`endif
systolic_dut 
(
    .clk                   (clk)   , 
    .rst                   (rst[0]) ,
    .enable_row_count_A    (enable_row_count_A),
    .pixel_cntr_A      	   (pixel_cntr_A),
    .pixel_cntr_B          (pixel_cntr_B),
    .slice_cntr_A          (slice_cntr_A),
    .slice_cntr_B          (slice_cntr_B),
    .rd_addr_A             (rd_addr_A),
    .rd_addr_B             (rd_addr_B),
`ifndef XIL_TIMING
    .A                     (A_pipe)    , 
    .B                     (B_pipe),     
    .D                     (D) ,
`else
    .\A[0]                 (A_pipe[0])    , 
    .\A[1]                 (A_pipe[1])    , 
    .\A[2]                 (A_pipe[2])    , 
    .\A[3]                 (A_pipe[3])    , 
    .\B[0]                 (B_pipe[0]),     
    .\B[1]                 (B_pipe[1]),     
    .\B[2]                 (B_pipe[2]),     
    .\B[3]                 (B_pipe[3]),     
    .\D[0]                 (D[0]) ,
    .\D[1]                 (D[1]) ,
    .\D[2]                 (D[2]) ,
    .\D[3]                 (D[3]) ,
`endif
    .valid_D               (valid_D)  
);

`ifndef XIL_TIMING
always #1 clk = ~clk;
`else
always #5000 clk = ~clk;
`endif

initial
begin
    $timeformat(-9, 2, " ns", 20);
    rst = 2'b11;
end

always @(posedge clk) begin
	rst <= rst>>1;
end

reg [31:0]  counter_finish = 0;

reg                    [2:0]             rst_pe = 2'b00;
always@(posedge clk)
begin
	if(rst[0]) begin
		rst_pe <= 1'b0;
	end else begin
		if (pixel_cntr_A==M-1)
		begin
			rst_pe <= 2'b01;
		end
		else
		begin
			rst_pe <= rst_pe >> 1;
		end
	end
end

genvar y;
for (x=0;x<N1;x=x+1)
begin
    for (y=0;y<N2;y=y+1)
    begin
        pipe_tb // use a TB version of pipe to avoid flattening pipe in synthesis
        #(
         .D_W(1),
         .pipes(x+y+1)
        )
        pipe_inst_rst
        (
         .clk    (clk),
         .rst    (rst[0]),
         .in_p   (rst_pe[0]),
         .out_p  (init_pe_pipe[x][y])
        );
    end
end

reg init = 0;

always@(posedge clk)
begin
	if(rst[0]) begin
		counter_finish <= 0;
	end else if (init_pe_pipe[N1-1][N2-1]) begin
		counter_finish <= counter_finish + 1;
	end
end

reg [31:0]  patch =1;

always@(posedge clk)
begin
	if(rst[0]) begin
		enable_row_count_A <= 1'b0;
		patch <= 1;
	end else begin
		if (enable_row_count_A == 1'b1)
		begin
			enable_row_count_A <= 1'b0;
		end

		else if (pixel_cntr_A == M-2 && patch == (M/N2))
		begin
			patch <= 1;
			enable_row_count_A <= ~enable_row_count_A;
		end

		else if (pixel_cntr_A == M-2)
		begin
			patch <= patch + 1 ;
		end
	end
end


reg [$clog2((M*M)/N1):0]   addr    [N1-1:0];

for (x=0;x<N1;x=x+1)
begin
    always@(posedge clk)
    begin
        if (rst[0]==1'b1)
        begin
            addr[x] <= 0;
        end

        else if (valid_D[x]==1'b1 && rst[0]==1'b0)
        begin
            mem2[(M*M*x)/N1+addr[x]] <= D[x];
            //addr[x] <= addr[x] + 1;
            addr[x] <= addr[x] < ((M*M)/N1-1) ? addr[x] + 1 : 0;
        end
    end
end

reg done;
always@(posedge clk)
begin
  done <= addr[N1-1]==(((M*M)/N1)-1);
  if (done)
  begin
    $finish;
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
