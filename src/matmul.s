.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    ebreak
    addi sp sp -4
    sw ra 0(sp)

    # Error checks
    li t0 1
    blt a1 t0 error
    blt a2 t0 error
    blt a4 t0 error
    blt a5 t0 error
    bne a2 a4 error

    # Prologue

    # outer_loop_step: t1
    add t1 a2 zero
    slli t1 t1 2
    # outer_loop_bound: t2
    mul t3 a1 t1
    add t2 a0 t3
    # inner_loop_step: t3
    li t3 4
    # inner_loop_bound: t4
    add t5 a5 zero
    slli t5 t5 2
    add t4 a3 t5
    # element number: t6
    add t6 a4 zero

outer_loop_start:
    beq a0 t2 outer_loop_end
    add t5 a3 zero

inner_loop_start:
    beq t5 t4 inner_loop_end

    addi sp sp -24
    sw a0 0(sp)
    sw a3 4(sp)
    sw t1 8(sp)
    sw t2 12(sp)
    sw t3 16(sp)
    sw t4 20(sp)

    add a1 t5 zero
    add a2 t6 zero
    li a3 1
    add a4 a5 zero

    call dot

    sw a0 0(a6)

    lw a0 0(sp)
    lw a3 4(sp)
    lw t1 8(sp)
    lw t2 12(sp)
    lw t3 16(sp)
    lw t4 20(sp)
    addi sp sp 24

    addi a6 a6 4
    add t5 t5 t3
    j inner_loop_start
inner_loop_end:


    add a0 a0 t1
    j outer_loop_start
outer_loop_end:


    # Epilogue

    lw ra 0(sp)
    addi sp sp 4
    jr ra

error:
    li a0 38
    j exit
