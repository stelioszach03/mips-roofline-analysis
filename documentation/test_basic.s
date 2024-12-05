# Δοκιμαστικό πρόγραμμα για έλεγχο βασικών εντολών
# Test program for basic instructions

.data
    test: .word 1, 2

.text
main:
    # Φόρτωση τιμής
    lui $1, 0x1000      # Load upper immediate
    lw $2, 0($1)        # Load word
    add $3, $2, $2      # Add
    sw $3, 4($1)        # Store word
    j main              # Jump
    nop                 # No operation
