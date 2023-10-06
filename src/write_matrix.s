.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)

    add s0 a1 zero # s0: matrix address
    addi sp sp -8
    sw a2 0(sp)
    sw a3 4(sp)    
    addi s1 sp 0 # s1: row address
    addi s2 sp 4 # s2: column address

    # open the file for writing
    li a1 1
    call fopen

    # check if fopen success
    blt a0 zero error_fopen
    add s3 a0 zero # s3: fd value

    # write row
    add a1 s1 zero
    li a2 1
    li a3 4
    call fwrite
    
    # check if fwrite success
    li t0 1
    bne a0 t0 error_fwrite

    # write column
    add a0 s3 zero
    add a1 s2 zero
    li a2 1
    li a3 4
    call fwrite

    # check if fwrite success
    li t0 1
    bne a0 t0 error_fwrite

    # write the matrix
    add a0 s3 zero
    add a1 s0 zero
    lw t0 0(sp)
    lw t1 4(sp)
    mul a2 t0 t1
    li a3 4
    call fwrite

    # check if fwrite success
    lw t0 0(sp)
    lw t1 4(sp)
    mul t0 t0 t1
    bne a0 t0 error_fwrite

    # close the file
    add a0 s3 zero
    call fclose

    # check if fclose success
    blt a0 zero error_fclose

    # Epilogue
    addi sp sp 8
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    addi sp sp 20

    jr ra
error_fopen:
    li a0 27
    j exit
error_fclose:
    li a0 28
    j exit
error_fwrite:
    li a0 30
    j exit