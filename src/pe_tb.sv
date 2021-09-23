`timescale 1 ps / 1 ps

module pe_tb
#(parameter FIRST = 0)
();

localparam D_W     = 8;
localparam D_W_ACC = 16;

localparam MEM_SZ = (FIRST == 0) ? 8 : 2;

reg                     clk=1'b0;
reg     [1:0]           rst;
reg                     init;
reg     [D_W-1:0]       in_a;
reg     [D_W-1:0]       in_b;
wire    [D_W-1:0]       out_b;
wire    [D_W-1:0]       out_a;

reg     [(D_W_ACC)-1:0] in_data;
reg                     in_valid;
wire    [(D_W_ACC)-1:0] out_data;
wire                    out_valid;

reg     [D_W_ACC-1:0]   mem [MEM_SZ-1:0];

integer now  = 0;
integer addr = 0;

final
begin
  $writememh("PE_OUT.mem", mem);
end

always @(posedge clk)
begin
  now <= now + 1;

  if (out_valid == 1'b1)
  begin
    mem[addr] <= out_data;
    addr <= (addr + 1) % MEM_SZ;
  end

  case (now)

    0:
    begin
      init     <= 1'b0;
      in_a     <= 8'd00;
      in_b     <= 8'd00;
      in_data  <= 16'd42;
      in_valid <= 1'b0;
    end
    
    1:
    begin
      init     <= 1'b0;
      in_a     <= 8'd01;
      in_b     <= 8'd02;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    2:
    begin
      init     <= 1'b0;
      in_a     <= 8'd03;
      in_b     <= 8'd04;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    3:
    begin
      init     <= 1'b0;
      in_a     <= 8'd05;
      in_b     <= 8'd06;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    4:
    begin
      init     <= 1'b0;
      in_a     <= 8'd07;
      in_b     <= 8'd08;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    5:
    begin
      init     <= 1'b0;
      in_a     <= 8'd09;
      in_b     <= 8'd10;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    6:
    begin
      init     <= 1'b0;
      in_a     <= 8'd11;
      in_b     <= 8'd12;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    7:
    begin
      init     <= 1'b0;
      in_a     <= 8'd13;
      in_b     <= 8'd14;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    8:
    begin
      init     <= 1'b0;
      in_a     <= 8'd15;
      in_b     <= 8'd16;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    9:
    begin
      init     <= 1'b1;
      in_a     <= 8'd17;
      in_b     <= 8'd18;
      if (FIRST == 0)
      begin
        in_data  <= 16'd100;
        in_valid <= 1'b1;
      end
    end

    10:
    begin
      init     <= 1'b0;
      in_a     <= 8'd19;
      in_b     <= 8'd20;
      if (FIRST == 0)
      begin
        in_data  <= 16'd101;
        in_valid <= 1'b1;
      end
    end
    
    11:
    begin
      init     <= 1'b0;
      in_a     <= 8'd21;
      in_b     <= 8'd22;
      if (FIRST == 0)
      begin
        in_data  <= 16'd102;
        in_valid <= 1'b1;
      end
    end
    
    12:
    begin
      init     <= 1'b0;
      in_a     <= 8'd23;
      in_b     <= 8'd24;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    13:
    begin
      init     <= 1'b0;
      in_a     <= 8'd25;
      in_b     <= 8'd26;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    14:
    begin
      init     <= 1'b0;
      in_a     <= 8'd27;
      in_b     <= 8'd28;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    15:
    begin
      init     <= 1'b0;
      in_a     <= 8'd29;
      in_b     <= 8'd30;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    16:
    begin
      init     <= 1'b0;
      in_a     <= 8'd31;
      in_b     <= 8'd32;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end
    
    17:
    begin
      init     <= 1'b1;
      in_b     <= 8'd32;
      in_a     <= 8'd31;
      if (FIRST == 0)
      begin
        in_data  <= 16'd103;
        in_valid <= 1'b1;
      end
    end
    
    18:
    begin
      init     <= 1'b0;
      in_a     <= 8'd31;
      in_b     <= 8'd32;
      if (FIRST == 0)
      begin
        in_data  <= 16'd104;
        in_valid <= 1'b1;
      end
    end
    
    19:
    begin
      init     <= 1'b0;
      in_a     <= 8'd31;
      in_b     <= 8'd32;
      if (FIRST == 0)
      begin
        in_data  <= 16'd105;
        in_valid <= 1'b1;
      end
    end
    
    20:
    begin
      init     <= 1'b0;
      in_a     <= 8'd31;
      in_b     <= 8'd32;
      if (FIRST == 0)
      begin
        in_data  <= 16'd42;
        in_valid <= 1'b0;
      end
    end

    30:
    begin
      $finish;
    end

    default:
    begin
      ;
    end
    endcase
end

pe
`ifndef XIL_TIMING
#(
  .D_W(D_W),
  .D_W_ACC(D_W_ACC)
)
`endif
pe_inst (
  .clk        (clk),
  .rst        (rst[0]),
  .init       (init),
  .in_a       (in_a),
  .in_b       (in_b),
  .out_a      (out_a),
  .out_b      (out_b),
  .in_valid   (in_valid),
  .in_data    (in_data),
  .out_valid  (out_valid),
  .out_data   (out_data)
);

`ifndef XIL_TIMING
always #1 clk = ~clk;
`else
always #20000 clk = ~clk;
`endif

initial
begin
  $timeformat(-9, 2, " ns", 20);
  rst = 2'b11;
end

always @(posedge clk) begin
  rst <= rst>>1;
end

endmodule
