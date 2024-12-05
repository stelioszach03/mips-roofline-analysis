# Πρόγραμμα επαλήθευσης χαρακτηριστικών του επεξεργαστή MIPS
# (MIPS processor features validation program)

.data
    counter: .word 10    # Counter for loop
    result:  .word 0     # Result storage

.text
main:
    # Φόρτωση αρχικών τιμών
    # (Load initial values)
    lui $t2, 0x1000          # Load base address of data segment
    lw $t0, 0($t2)          # Load counter value from counter
    add $t1, $zero, $zero   # Initialize sum (tests forwarding)

loop:
    beq $t0, $zero, end     # Test branch prediction
    nop                     # Branch delay slot

    add $t1, $t1, $t0       # Accumulate sum (tests ALU forwarding)
    addi $t0, $t0, -1       # Decrement counter

    j loop                  # Test jump prediction
    nop                     # Jump delay slot

end:
    sw $t1, 4($t2)         # Store final result to result

    # Exit program
    addi $v0, $zero, 10    # Exit syscall
    syscall                # End program
