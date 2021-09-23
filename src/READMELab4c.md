# Lab 4B Optimization Guide

This guide describes key techniques used in previous years to optimize the
systolic array, which should provide a useful reference for anyone aiming to
achieve a high score. Note that you are not limited to using these ideas. In
particular, the testbench only supported square matrices in previous years.
Setting `N1 != N2` may provide optimization opportunities not previously
explored (especially related to floorplanning).

## Prerequisites

Your design should be fully functional before trying to optimize it. This
file contains no information on how to do this, the main `README.md` should be
your reference for the lab instructions.

## Assumptions

As stated in the main `README.md`, this lab will use `D_W=8` and `D_W_ACC=16`
as the settings for the width parameters. You should assume that these are the
width parameters you are designing your optimizations for.

Additionally, you may assume that the accumulation will not overflow, and
therefore that any behavior is ok if overflow happens.

## References

- [UG901 (v2018.3)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug901-vivado-synthesis.pdf),
is the synthesis guide for Vivado and is useful as a reference for what attributes are available and what they do.
- [UG904 (v2018.3)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug901-vivado-synthesis.pdf),
is the implementation guide for Vivado and contains useful information about available compiler optimizations.
- [UG835 (v2018.3)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug835-vivado-tcl-commands.pdf)
is the full Tcl command reference for Vivado.

## Optimizations

### Controlling DSP use

In most cases, the compiler should notice the multiply-accumulate structure of
your PE and implement it using a DSP block. As a consequence, if you take an
unoptimized design and increase the array size, the first barrier is usually
when you run out of DSP blocks.

You can use the `use_dsp` Verilog attribute to tell the compiler it shouldn't
use the DSP block (see UG901 for reference). However, this means the operations
are implementing using LUTs, which greatly increases resource usage. Using DSP
blocks when they are available is good.

Therefore the strategy is to write one PE module that does use a DSP and one
that doesn't, and instantiate a mixture in `systolic.sv` in order to take
advantage of the available DSPs but also have a larger array than what would
be possible using only the DSPs.

### Packed multiplication

The DSP contains a 25x18 bit multiplier and a 48-bit accumulation register,
but the multiplication in the PE is only 8x8 bit. By packing two input values
in a certain way it is possible to use one multiply to multiplier two numbers
by a common multiplier. Since two adjacent PEs receive the same row/column,
this means it is possible to implement two PEs using one DSP block.

Note: The assumption that overflow can be ignored is key to this working.

### Compiler optimizations

You may modify `overlay/lab4.tcl` which is read by `overlay/build.tcl` before
starting synthesis. This means you can modify compiler options (see UG904 and
UG835 for available options and Tcl commands) to enable more aggressive design
optimization. This can be very useful to get you over the line if your design
barely fails timing at your design fmax, but can't get you a high score alone.

## Unconventional multipliers

If you've implemented the previous optimizations then you've maximized your
use of the DSPs and the main barrier to design score is the performance and
resource use of the non-DSP multipliers. Two approaches have been used in
previous years to improve at this stage.

#### Optimized LUT multiplier

It turns out you can beat the compiler at implementing multiplication using
LUTs if you optimize by hand. The two students with the highest score in
the S2020 term were able to do this using
[this paper](https://www.mdpi.com/2073-431X/5/4/20) as a reference.

#### ROM multiplier

In addition to DSPs, the FPGA has block ram (BRAM) resources available. As well
as as RAM, they can be used as ROM (i.e. a giant lookup table). Implementing
the full 8x8 multiplication as a lookup table requires 2^16 addresses, which is
infeasible. However, and 8x8 multiplication can be split up in to a sum of two
4x8 multiplications. There is just enough space in one RAMB36E1 to store the
upper 9 bits of every possible 4x8 multiplication, making it possible to have a
lookup table that produces them. Since the BRAM is dual port, both 4x8
products can use the same lookup table for their upper 9 bits. The lower 3 bits
must be computed using LUTs, but aren't particularly complicated.

Note: You may need the `rom_style` attribute to direct the compiler to use the
BRAM.
