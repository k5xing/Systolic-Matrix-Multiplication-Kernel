# Systolic-Matrix-Multiplication-Kernel
Lab Projects Developed in ECE327

The project is the last lab of ECE327, and it is based on previous labs done in this course. All the project files are included in the src folder, and the verilog files modified are included in the verilog code folder. The objective and requirements of this lab are described below:

## Objective

Matrix multiplication is a popular kernel in high-performance scientific computing, gaming, and now even machine learning workloads.Companies like NVIDIA now build GPU hardware that excels at the task of performing matrix multiplication. In contemporary usage, matrix multiplication hardware has even made it into the core of the Google Tensor Processing Unit (TPU). FPGAs are also competent at matrix multiplication particularly from the perspective of energy efficiency. The objective of this lab is to design a hardware module targeting FPGAs that can multiply two matrices in a systolic fashion. A systolic array is a 2D grid of simple computing elements connected to each other in nearest neighbour fashion. Dataflow through the array proceeds in a systolic fashion (one hop at a time), new elements injected into the array from the top and left flanks per cycle. The co-ordination of data injection is crucial for correct evaluation of the computation. 
* Design a systolic matrix multiplication module in the file systolic.sv to instantiate a 2D grid of PEs defined in pe.v
* Implement the PE module pe.v that performs multiply-accumulate operation on streaming signals in_a and in_b
* Implement a cascaded counter module counter.v will implement a cascaded pixel/slice counter for two matrix inputs
* Synthesize, implement, and download design bitstream to the PYNQ board

## Design Description
We will now investigate detailed operation of the systolic core, the PEs, and the counter. These components are the three key building blocks of your design. We show a high-level picture of the systolic array below:
![systolic](src/img/systolic.png)