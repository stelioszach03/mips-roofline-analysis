# Ελάχιστο πρόγραμμα δοκιμής
# Minimal test program

.text
.globl __start
__start:
    addiu $2, $0, 1      # Set $2 = 1
    addiu $3, $0, 2      # Set $3 = 2
    addu $4, $2, $3      # Add without overflow
    j __start            # Loop
    nop                  # Delay slot
