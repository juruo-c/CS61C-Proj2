.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t0 1
    blt a1 t0 error
    add t0 a0 zero
    add t1 a1 zero
    slli t1 t1 2
    add t1 a0 t1
    add a1 a0 zero
    addi a0 a0 4

loop_start:
    bge a0 t1 loop_end
    lw t2 0(t0)
    lw t3 0(a0)
    bge t2 t3 loop_continue
    add t0 a0 zero

loop_continue:
    addi a0 a0 4
    j loop_start

loop_end:
    # Epilogue
    sub t0 t0 a1
    srli a0 t0 2
    jr ra
error:
    li a0 36
    j exit
