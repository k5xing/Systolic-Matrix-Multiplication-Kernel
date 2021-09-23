import sys
import pynq
import pynq.lib.dma
import numpy as np
from pynq import Overlay
from pynq import DefaultIP
from pynq import DefaultHierarchy
from pynq import Xlnk
from pynq import MMIO
from pprint import pprint
import random
import signal

def handler(signum, frame):
    print("lab4-board.py timed out waiting for the board to respond. Likely DMA error due to M N1 N2 mismatch with configured bitstream");
    raise Exception("timeout");


signal.signal(signal.SIGALRM, handler)

M=int(sys.argv[1])
N1=int(sys.argv[2])
N2=int(sys.argv[3])


xlnk=Xlnk()
ol = Overlay('./tutorial.bit')

####this prints all the IPs inside
pprint(ol.ip_dict)

# load inputs
in_buffer = xlnk.cma_array(shape=(2*M*M,), dtype=np.uint32)
out_buffer = xlnk.cma_array(shape=(M*M,), dtype=np.uint32)


for i in range(0,len(in_buffer)):
    in_buffer[i]=random.randint(1,9) 
    
A = np.zeros((M,M))
for i in range(M*M):
    base_row = int(i*N1/(M*M))
    base_column = int(int(i%M)/N1)
    column=int(base_column*N1) + (int(i%N1))
    row = base_row + int((i%((M*M)/N1))/M)*N1
    A[row][column] = in_buffer[i]


B = np.zeros((M,M))
for i in range(M*M):
    base_column = int(i*N2/(M*M))
    base_row = int(int(i%M)/N2)
    row=int(base_row*N2) + (int(i%N2))
    column = base_column + int((i%((M*M)/N2))/M)*N2
    B[row][column] = in_buffer[i+M*M]

signal.alarm(10);
try:
    ol.mm_eval.axi_dma.recvchannel.transfer(out_buffer)
    ol.mm_eval.axi_dma.sendchannel.transfer(in_buffer)
    ol.mm_eval.axi_dma.sendchannel.wait()
    ol.mm_eval.axi_dma.recvchannel.wait()
except Exception as exc:
    print(exc);

signal.alarm(0);

D = np.zeros((M,M))
for i in range(M*M):
    base_row = int(i*N1/(M*M))
    base_column = int(int(i%M)/N2)
    column=int(base_column*N2) + (N2-1-int(i%N2))
    row = base_row + int((i%((M*M)/N1))/M)*N1
    D[row][column] = out_buffer[i]

D_truth = np.matmul(A,B)
print("Matrix A is")
print(A)    
print("Matrix B is")
print(B)  
print("Answer is")
print(D_truth)
print("Your answer is:")
print(D)
print("##########")

if np.array_equal(D,D_truth):
    print("Thank Mr. Goose")
else:
    print("HISSSSS!!")

print("##########")
