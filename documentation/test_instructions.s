.data
    value: .word 1

.text
.globl main
main:
    lui $1, 0x1000
    lw $2, 0($1)
    add $3, $2, $2
    sw $3, 4($1)
    j main
    nop
