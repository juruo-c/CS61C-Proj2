.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0 1
    blt a1 t0 error
    add t0 a1 zero
    slli t0 t0 2
    add t0 a0 t0

loop_start:
    beq a0 t0 loop_end
    lw t1 0(a0)
    bge t1 zero loop_continue
    li t1 0

loop_continue:
    sw t1 0(a0)
    addi a0 a0 4
    j loop_start

loop_end:


    # Epilogue


    jr ra
error:
    li a0 36
    j exit
