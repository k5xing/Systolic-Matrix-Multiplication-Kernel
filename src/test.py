import numpy as np
import sys

N1 = int(sys.argv[1])
N2 = int(sys.argv[2])

mem0 = open("A.mem")
depth_mem0 = len(mem0.readlines())

M = np.sqrt(depth_mem0)

A = np.zeros((int(M),int(M)))
B = np.zeros((int(M),int(M)))
D = np.zeros((int(M),int(M)))

ascii_thank = r'''
                                   ___
                               ,-""   `.
       Thank Mr. Goose       ,'  _   ' )`-._
                            /  ,' `-._<.===-'
                           /  /
                          /  ;
              _          /   ;
 (`._    _.-"" ""--..__,'    |
 <_  `-""                     \
  <`-                          :
   (__   <__.                  ;
     `-.   '-.__.      _.'    /
        \      `-.__,-'    _,'
         `._    ,    /__,-'
            ""._\__,'< <____
                 | |  `----.`.
                 | |        \ `.
                 ; |___      \-``
                 \   --<
                  `.`.<
                    `-'
                    
'''


ascii_hisssss = r'''
                                                        _...--.
                                        _____......----'     .'
                                  _..-''                   .'
                                .'                       ./
                        _.--._.'                       .' |
                     .-'                           .-.'  /
  HISSSSS!!        .'   _.-.                     .  \   '
                 .'  .'   .'    _    .-.        / `./  :
               .'  .'   .'  .--' `.  |  \  |`. |     .'
            _.'  .'   .' `.'       `-'   \ / |.'   .'
         _.'  .-'   .'     `-.            `      .'
       .'   .'    .'          `-.._ _ _ _ .-.    :
      /    /o _.-'               .--'   .'   \   |
    .'-.__..-'                  /..    .`    / .'
  .'   . '                       /.'/.'     /  |
 `---'                                   _.'   '
                                       /.'    .'
                                        /.'/.'
                                        
'''

mem0 = open("A.mem")
i=0
for line in mem0:
        base_row = int(i*N1/(M*M))
        base_column = int(int(i%M)/N1)
        column=int(base_column*N1) + (int(i%N1))
        row = base_row + int((i%((M*M)/N1))/M)*N1 #base_row + int((int(i%int((M*M)/N))/M)*N)
        #print(i,base_row,row,base_column,column)
        A[row][column] = int(line,16)
        i+=1

mem1 = open("B.mem")
i=0
for line in mem1:
        base_column = int(i*N2/(M*M))
        base_row = int(int(i%M)/N2)
        row=int(base_row*N2) + (int(i%N2))
        column = base_column + int((i%((M*M)/N2))/M)*N2 #base_row + int((int(i%int((M*M)/N))/M)*N)
        B[row][column] = int(line,16)
        i+=1

truth=np.matmul(A,B)

#f_d = open("truth.mem", "w")
#for i in range(int(M*M/N)):
#    line = ""
#    for j in range(N):
#        line = str(format(int(truth[i][N-1-j]),'04x'))
#        f_d.write(line+"\n")
#f_d.close()

mem2 = open("D.mem")
i=0
for line in mem2:
    if(line[0]!="/"):
        base_row = int(i*N1/(M*M))
        base_column = int(int(i%M)/N2)
        column=int(base_column*N2) + (N2-1-int(i%N2))
        row = base_row + int((i%((M*M)/N1))/M)*N1 #base_row + int((int(i%int((M*M)/N))/M)*N)
        D[row][column] = int(line,16)
        i+=1

print("Matrix 0 (A) is")
print(A)    
print("Matrix 1 (B) is")
print(B)  
print("Answer is")
print(truth)
print("Your answer is:")
print(D)
print("##########")
if np.array_equal(D,truth):
        print(ascii_thank)
else:
        print(ascii_hisssss)
print("##########")
