.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -36
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)

    # Check argc
    li t0 5
    bne a0 t0 error_arg

    # store some reg
    add s0 a1 zero
    add s1 a2 zero

    # Read pretrained m0
    addi sp sp -8
    lw a0 4(s0)
    add a1 sp zero
    addi a2 sp 4
    call read_matrix
    add s2 a0 zero # s2: m0's address

    # Read pretrained m1
    addi sp sp -8
    lw a0 8(s0)
    add a1 sp zero
    addi a2 sp 4
    call read_matrix
    add s3 a0 zero # s3: m1's address

    # Read input matrix
    addi sp sp -8
    lw a0 12(s0)
    add a1 sp zero
    addi a2 sp 4
    call read_matrix
    add s4 a0 zero # s4: input matrix's address

    # Compute h = matmul(m0, input)
    lw a0 16(sp)
    lw t0 4(sp)
    mul a0 a0 t0
    slli a0 a0 2
    call malloc
    beq a0 zero error_malloc
    add s5 a0 zero # s5: h's address
    add a0 s2 zero
    lw a1 16(sp)
    lw a2 20(sp)
    add a3 s4 zero
    lw a4 0(sp)
    lw a5 4(sp)
    add a6 s5 zero
    call matmul

    # Compute h = relu(h)
    add a0 s5 zero
    lw a1 16(sp)
    lw t0 4(sp)
    mul a1 a1 t0
    call relu

    # Compute o = matmul(m1, h)
    lw a0 8(sp)
    lw t0 4(sp)
    mul a0 a0 t0
    slli a0 a0 2
    call malloc
    beq a0 zero error_malloc
    add s6 a0 zero # s6: o's address
    add a0 s3 zero
    lw a1 8(sp)
    lw a2 12(sp)
    add a3 s5 zero
    lw a4 16(sp)
    lw a5 4(sp)
    add a6 s6 zero
    call matmul

    # Write output matrix o
    lw a0 16(s0)
    add a1 s6 zero
    lw a2 8(sp)
    lw a3 4(sp)
    call write_matrix

    # Compute and return argmax(o)
    add a0 s6 zero
    lw a1 8(sp)
    lw t0 4(sp)
    mul a1 a1 t0
    call argmax
    add s7 a0 zero # s7: the final result

    # If enabled, print argmax(o) and newline
    bne s1 zero done
    call print_int
    li a0 '\n'
    call print_char

done:
    add a0 s2 zero
    call free
    add a0 s3 zero
    call free
    add a0 s4 zero
    call free
    add a0 s5 zero
    call free
    add a0 s6 zero
    call free

    add a0 s7 zero
    addi sp sp 24
    
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    addi sp sp 36

    jr ra

error_malloc:
    li a0 26
    j exit
error_arg:
    li a0 31
    j exit