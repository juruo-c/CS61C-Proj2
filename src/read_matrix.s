.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)

    add s0 a1 zero # s0: row address
    add s1 a2 zero # s1: col address

    # open file
    li a1 0

    call fopen

    # check if fopen success
    blt a0 zero error_fopen
    add s2 a0 zero # s2: fd value

    # read row
    add a1 s0 zero
    li a2 4

    call fread

    # check if fread success
    li s3 4
    bne a0 s3 error_fread

    # read column
    add a0 s2 zero
    add a1 s1 zero
    li a2 4

    call fread

    # check if fread success
    li s3 4
    bne a0 s3 error_fread

    # malloc space for matrix
    lw s3 0(s0)
    lw s4 0(s1)
    mul s3 s3 s4
    slli s3 s3 2 # s3: size of matrix
    add a0 s3 zero

    call malloc

    # check if malloc success
    beq a0 zero error_malloc
    add s4 a0 zero # s4: result matrix's address

    # read matrix data
    add a0 s2 zero
    add a1 s4 zero
    add a2 s3 zero

    call fread

    # check if fread success
    bne a0 s3 error_fread

    # call fclose to close file
    add a0 s2 zero

    call fclose

    # check if fclose success
    blt a0 zero error_fclose
    add a0 s4 zero

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24

    jr ra
error_malloc:
    li a0 26
    j exit
error_fopen:
    li a0 27
    j exit
error_fclose:
    li a0 28
    j exit
error_fread:
    li a0 29
    j exit
