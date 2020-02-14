using BenchmarkTools
using Random

sparseN(N) = sparse(randperm(N), randperm(N), ones(Int64, N), N, N)

A = sparseN(100000)
B = sparseN(100000)

m1 = @btime $A*$B'

As = sm2gbm(A)
Bs = sm2gbm(sparse(B'))
mgb = @btime mm($As, $Bs)

m2 = gbm2sm(mgb)

@assert m1 == m2



B = sparse([0 1 0 1 0 0 0;
     1 0 0 1 1 0 1;
     0 0 0 1 0 1 1;
     1 1 1 0 0 1 1;
     0 1 0 0 0 1 1;
     0 0 1 1 1 0 0;
     0 1 1 1 1 0 0])

BS = sm2gbm(B)
V = sm(BS)
RES = dmv(BS, V)

println(collect(gbm2sm(RES)))



# ************************************************************************************ #

VV = [[1] , [2] , [3] , [4] , [5] , [6] , [7] , [8] , [9] , [10] , [11] , [12] , [13] , [14] , [15] , [16] , [17] ,
[18] , [19] , [20] , [21] , [22] , [23] , [24]]


FV = [[13 ,15 ,19 ,21] , [1 ,2 ,3 ,4] , [7 ,9 ,13 ,15] , [13 ,14 ,15 ,16] , [7 ,8 ,13 ,14] , [1 ,2 ,7 ,8] , [2 ,4 ,8 ,10] ,
[7 ,8 ,9 ,10] , [3 ,5 ,9 ,11] , [8 ,10 ,14 ,16] , [15 ,16 ,21 ,22] , [9 ,11 ,15 ,17] , [3 ,4 ,5 ,6] , [17 ,18 ,23 ,24] ,
[11 ,12 ,17 ,18] , [1 ,3 ,7 ,9] , [3 ,4 ,9 ,10] , [9 ,10 ,15 ,16] , [4 ,6 ,10 ,12] , [13 ,14 ,19 ,20] , [9 ,10 ,11 ,12] ,
[15 ,16 ,17 ,18] , [19 ,20 ,21 ,22] , [15 ,17 ,21 ,23] , [16 ,18 ,22 ,24] , [21 ,22 ,23 ,24] , [10 ,12 ,16 ,18] ,
[5 ,6 ,11 ,12] , [14 ,16 ,20 ,22]]


EV = [[15 ,17] , [16 ,22] , [6 ,12] , [17 ,23] , [18 ,24] , [4 ,10] , [3 ,4] , [13 ,15] , [11 ,12] , [9 ,15] , [13 ,19] ,
[1 ,7] , [5 ,11] , [5 ,6] , [12 ,18] , [8 ,14] , [15 ,21] , [17 ,18] , [1 ,3] , [2 ,4] , [16 ,18] , [2 ,8] , [21 ,23] ,
[20 ,22] , [1 ,2] , [14 ,16] , [10 ,16] , [13 ,14] , [19 ,21] , [7 ,13] , [9 ,10] , [23 ,24] , [11 ,17] , [21 ,22] ,
[3 ,9] , [3 ,5] , [9 ,11] , [7 ,9] , [14 ,20] , [7 ,8] , [22 ,24] , [19 ,20] , [8 ,10] , [15 ,16] , [10 ,12] , [4 ,6]]

CV = [[1 2 3 4 7 8 9 10];
[3 4 5 6 9 10 11 12];
[7 8 9 10 13 14 15 16];
[9 10 11 12 15 16 17 18];
[13 14 15 16 19 20 21 22];
[15 16 17 18 21 22 23 24]]


function K(CV)
    I = vcat([[k for h in CV[k]] for k in 1:length(CV)]...)
    J = vcat(CV...)
    Vals = Int8[1 for k in 1:length(I)]
    return SparseArrays.sparse(I, J, Vals)
end

M0 = K(VV); M1 = K(EV); M2 = K(FV); M3 = K(CV);

#∂_1 = M0 * M1'
#∂_2 = (M1 * M2') .// sum(M1 , dims=2)
#∂_3 = (M2 * M3') .// sum(M2, dims=2)

M1s = sm2gbm(M1)
M2s = sm2gbm(M2)

d2 = d(M1s, M2s)

println(collect(gbm2sm(d2)))
