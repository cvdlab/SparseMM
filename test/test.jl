push!(LOAD_PATH, "../src/")
push!(LOAD_PATH, "./src/")

using Random
using Test
using LARMM
using SparseMM
using SparseArrays


# ************************************************************************************** #

sparseN(N) = sparse(randperm(N), randperm(N), ones(Int64, N), N, N)

const A = sparseN(1000)
const B = sparseN(1000)

function delta_3(M_2, M_3)
	s = sum(M_2,dims=2)
	d = (M_2 * M_3')
	res = d ./ s
	res = res .÷ 1

	res = map(x -> if isnan(x) 0 else x end, res)

	return res
end

function test_d1_random_matrix()
	global A, B
	return LARMM.d1(A,B)
end

function test_d2_random_matrix()
	global A, B
	return LARMM.d2(A,B)
end

function test_d3_random_matrix()
	global A, B
	return LARMM.d3(A,B)
end

sparseN_int8(N) = sparse(randperm(N), randperm(N), ones(Int8, N), N, N)

const A8 = sparseN_int8(1000)
const B8 = sparseN_int8(1000)

function delta_3(M_2, M_3)
	s = sum(M_2,dims=2)
	d = (M_2 * M_3')
	res = d ./ s
	res = res .÷ 1

	res = map(x -> if isnan(x) 0 else x end, res)

	return res
end

function test_d1_random_matrix_int8()
	global A8, B8
	return LARMM.d1(A8,B8)
end

function test_d2_random_matrix_int8()
	global A8, B8
	return LARMM.d2(A8,B8)
end

function test_d3_random_matrix_int8()
	global A8, B8
	return LARMM.d3(A8,B8)
end


# ************************************************************************************** #

sparseNM(N,M) = if N < M; sparse(randperm(N), randperm(N), ones(Int64, N), N, M); else
	sparse(randperm(M), randperm(M), ones(Int64, M), N, M); end

const A1r = sparseNM(3, 4)
const B1r = sparseNM(5, 4)

function delta_3(M_2, M_3)
	s = sum(M_2,dims=2)
	d = (M_2 * M_3')
	res = d ./ s
	res = res .÷ 1

	res = map(x -> if isnan(x) 0 else x end, res)

	return res
end

function test_d1_random_matrix_rect()
	global A1r, B1r
	return LARMM.d1(A1r,B1r)
end

function test_d2_random_matrix_rect()
	global A1r, B1r
	return LARMM.d2(A1r,B1r)
end

function test_d3_random_matrix_rect()
	global A1r, B1r
	return LARMM.d3(A1r,B1r)
end

sparseNM_int8(N,M) = if N < M; sparse(randperm(N), randperm(N), ones(Int8, N), N, M); else
	sparse(randperm(M), randperm(M), ones(Int8, M), N, M); end

const A1r_2 = sparseNM_int8(3, 4)
const B1r_2 = sparseNM_int8(5, 4)

function delta_3(M_2, M_3)
	s = sum(M_2,dims=2)
	d = (M_2 * M_3')
	res = d ./ s
	res = res .÷ 1

	res = map(x -> if isnan(x) 0 else x end, res)

	return res
end

function test_d1_random_matrix_rect_int8()
	global A1r_2, B1r_2
	return LARMM.d1(A1r_2,B1r_2)
end

function test_d2_random_matrix_rect_int8()
	global A1r_2, B1r_2
	return LARMM.d2(A1r_2,B1r_2)
end

function test_d3_random_matrix_rect_int8()
	global A1r_2, B1r_2
	return LARMM.d3(A1r_2,B1r_2)
end

# ************************************************************************************** #
const A1 = sparse([	2 0 4;
            		2 2 0;
            		0 0 2])
const VM = sparse([	1 1;
             		0 1;
             		0 2])

const A12 = sparse(Int8[2 0 4;
            			2 2 0;
            			0 0 2])
const VM2 = sparse(Int8[1 1;
             			0 1;
             			0 2])

function test_dmv_small_matrix()
	global A12, VM2
	Bs = SparseMM.sm2gbm(A12)
	VMs = SparseMM.sm2gbm(VM2)
	R = SparseMM.dmv(Bs, SparseMM.sm(VMs))
	return SparseMM.gbm2sm(R)
end

function test_dmv_small_matrix_int8()
	global A1, VM
	Bs = SparseMM.sm2gbm(A1)
	VMs = SparseMM.sm2gbm(VM)
	R = SparseMM.dmv(Bs, SparseMM.sm(VMs))
	return SparseMM.gbm2sm(R)
end

# ************************************************************************************ #

const A1r2 = sparse([2 0 4 1;
            		 2 2 0 2;
            		 0 0 2 0])

const A1r3 = sparse(Int8[2 0 4 1;
         		 		 2 2 0 2;
         		 		 0 0 2 0])

function test_dmv_small_matrix_rect()
	global A1r2, VM
	Bs = SparseMM.sm2gbm(A1r2)
	VMs = SparseMM.sm2gbm(VM)
	R = SparseMM.dmv(Bs, SparseMM.sm(VMs))
	return SparseMM.gbm2sm(R)
end

function test_dmv_small_matrix_rect_int8()
	global A1r3, VM2
	Bs = SparseMM.sm2gbm(A1r3)
	VMs = SparseMM.sm2gbm(VM2)
	R = SparseMM.dmv(Bs, SparseMM.sm(VMs))
	return SparseMM.gbm2sm(R)
end

# ************************************************************************************ #

randSparse(N) = sparse(randperm(N), randperm(N), rand(0:N, N), N, N)

const A2 = randSparse(1000)
const B2 = randSparse(1000)

function test_d1_random_values()
	global A2, B2
	return LARMM.d1(A2,B2)
end

function test_d2_random_values()
	global A2, B2
	return LARMM.d2(A2,B2)
end

function test_d3_random_values()
	global A2, B2
	return LARMM.d3(A2,B2)
end

# ************************************************************************************ #

randSparseNM(N,M) = if N < M; sparse(randperm(N), randperm(N), rand(0:N, N), N, M); else
	sparse(randperm(M), randperm(M), rand(0:N, M), N, M); end

const A2r = randSparseNM(100, 50)
const B2r = randSparseNM(100, 50)

function test_d1_random_values_rect()
	global A2r, B2r
	return LARMM.d1(A2r,B2r)
end

function test_d2_random_values_rect()
	global A2r, B2r
	return LARMM.d2(A2r,B2r)
end

function test_d3_random_values_rect()
	global A2r, B2r
	return LARMM.d3(A2r,B2r)
end

# ************************************************************************************ #

const M = sparse([ 2 0 4;
            	   2 1 0;
            	   1 0 0])

function test_div_by_two()
	global M
	Bs = SparseMM.sm2gbm(M)
	B_div_2 = SparseMM.div_by_two(Bs)
	return SparseMM.gbm2sm(B_div_2)
end

# ************************************************************************************ #

const Mr = sparse([ 2 0 4 3;
            	    2 1 0 0;
            	    1 0 0 5])

function test_div_by_two_rect()
	global Mr
	Bs = SparseMM.sm2gbm(Mr)
	B_div_2 = SparseMM.div_by_two(Bs)
	return SparseMM.gbm2sm(B_div_2)
end

# ************************************************************************************ #

const Mr1 = sparse(Int8[2 0 4 3;
            	    	2 1 0 0;
            	    	1 0 0 5])

function test_div_by_two_rect_int8()
	global Mr1
	Bs = SparseMM.sm2gbm(Mr1)
	B_div_2 = SparseMM.div_by_two(Bs)
	return SparseMM.gbm2sm(B_div_2)
end

# ************************************************************************************ #

const Mr2 = sparse(Int8[2 0 4;
            	    	2 1 0;
            	    	1 0 0])

function test_div_by_two_int8()
	global Mr2
	Bs = SparseMM.sm2gbm(Mr2)
	B_div_2 = SparseMM.div_by_two(Bs)
	return SparseMM.gbm2sm(B_div_2)
end

# ************************************************************************************ #

randSparse(N) = sparse(randperm(N), randperm(N), rand(0:N, N), N, N)

const A3 = sparse([0 3 0; 2 0 0; 0 0 0])
const B3 = sparse([0 0 0; 0 1 0; 0 0 0])

function test_d3_random_values_2()
	global A3, B3
	return LARMM.d3(A3,B3)
end

@testset "Test" begin
	@testset "SparseMM squared matrices" begin
		@test test_d3_random_values_2() == delta_3(A3, B3)
		@test test_d1_random_matrix() == A*B'
		@test test_d2_random_matrix() == (A * B') .÷ 2
		@test test_d3_random_matrix() == delta_3(A, B)
		@test test_d1_random_matrix_int8() == A8*B8'
		@test test_d2_random_matrix_int8() == (A8 * B8') .÷ 2
		@test test_d3_random_matrix_int8() == delta_3(A8, B8)
		@test test_dmv_small_matrix() == [1 0 2; 2 2 0; 0 0 1]
		@test test_dmv_small_matrix_int8() == [1 0 2; 2 2 0; 0 0 1]
		@test test_d1_random_values() == A2*B2'
		@test test_d2_random_values() == (A2 * B2') .÷ 2
		@test test_d3_random_values() == delta_3(A2, B2)
		@test test_div_by_two() == [1 0 2; 1 0 0; 0 0 0]
		@test test_div_by_two_int8() == [1 0 2; 1 0 0; 0 0 0]
	end
	@testset "SparseMM not squared matrices" begin
		@test test_d3_random_values_2() == delta_3(A3, B3)
		@test test_d1_random_matrix_rect() == A1r*B1r'
		@test test_d2_random_matrix_rect() == (A1r * B1r') .÷ 2
		@test test_d3_random_matrix_rect() == delta_3(A1r, B1r)
		@test test_d1_random_matrix_rect_int8() == A1r_2*B1r_2'
		@test test_d2_random_matrix_rect_int8() == (A1r_2 * B1r_2') .÷ 2
		@test test_d3_random_matrix_rect_int8() == delta_3(A1r_2, B1r_2)
		@test test_dmv_small_matrix_rect() == [1 0 2 0; 2 2 0 2; 0 0 1 0]
		@test test_dmv_small_matrix_rect_int8() == [1 0 2 0; 2 2 0 2; 0 0 1 0]
		@test test_d1_random_values_rect() == A2r*B2r'
		@test test_d2_random_values_rect() == (A2r * B2r') .÷ 2
		@test test_d3_random_values_rect() == delta_3(A2r, B2r)
		@test test_div_by_two_rect() == [1 0 2 1; 1 0 0 0; 0 0 0 2]
		@test test_div_by_two_rect_int8() == [1 0 2 1; 1 0 0 0; 0 0 0 2]
	end
end
