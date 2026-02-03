.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    li t0, 1
    blt a1, t0, invalid_m0
    blt a2, t0, invalid_m0
    blt a4, t0, invalid_m1
    blt a5, t0, invalid_m1
    bne a2, a4, dismatch
    # Error checks
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    # Prologue
    mv s0, a0 # m0 pointer
    mv s1, a3 # m1 pointer
    mv s2, a6 # d pointer
    mv s3, a2 # m0's cols == m1's rows
    mv s4, a1 # m0's rows
    mv s5, a5 # m1's cols
    
    
    li t0, 0
    mv s6, s1
outer_loop_start:
    beq t0, s4, outer_loop_end
    li t1, 0
inner_loop_start:
    beq t1, s5, inner_loop_end
    mv a0, s0
    mv a1, s1
    mv a2, s3
    li a3, 1
    mv a4, s5
    
    addi sp, sp, -16
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    jal ra, dot
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    addi sp, sp, 16
    
    sw a0, 0(s2)
    addi s2, s2, 4
    
    addi t1, t1, 1
    addi s1, s1, 4
    
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1
    slli t2, s3, 2
    add s0, s0, t2
    mv s1, s6
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret
invalid_m0:
    li a0, 72
    jal exit2
invalid_m1:
    li a0, 73
    jal exit2
dismatch:
    li a0,74
    jal exit2
