# Πολλαπλασιασμός τετραγωνικού πίνακα με βαθμωτό (n=8)
# Υλοποίηση για QtMips με βασικές εντολές

.data
    # Πίνακας εισόδου 8x8
    matrix: .word 1, 2, 3, 4, 5, 6, 7, 8
           .word 9, 10, 11, 12, 13, 14, 15, 16
           .word 17, 18, 19, 20, 21, 22, 23, 24
           .word 25, 26, 27, 28, 29, 30, 31, 32
           .word 33, 34, 35, 36, 37, 38, 39, 40
           .word 41, 42, 43, 44, 45, 46, 47, 48
           .word 49, 50, 51, 52, 53, 54, 55, 56
           .word 57, 58, 59, 60, 61, 62, 63, 64

    # Βαθμωτός αριθμός
    scalar: .word 2

    # Πίνακας αποτελέσματος 8x8
    result: .word 0:64    # 64 μηδενικά (8x8)

.text
.globl __start
__start:
    # Αρχικοποίηση μετρητών και διευθύνσεων
    addiu $8, $0, 0        # i = 0 (γραμμή)
    addiu $9, $0, 0        # j = 0 (στήλη)
    addiu $10, $0, 8       # όριο = 8
    lui $1, 0x1000         # Βάση διεύθυνσης δεδομένων
    lw $11, 256($1)        # Φόρτωση βαθμωτού

outer_loop:
    beq $8, $10, done      # Εάν i = όριο, τέλος
    nop                    # Καθυστέρηση διακλάδωσης

    addiu $9, $0, 0        # j = 0

inner_loop:
    beq $9, $10, next_row  # Εάν j = όριο, επόμενη γραμμή
    nop                    # Καθυστέρηση διακλάδωσης

    # Υπολογισμός διεύθυνσης στοιχείου matrix[i][j]
    sll $5, $8, 5          # i * 32 (8 words * 4 bytes)
    sll $6, $9, 2          # j * 4 (1 word)
    addu $7, $5, $6        # Συνολική μετατόπιση
    addu $12, $1, $7       # Διεύθυνση στοιχείου
    lw $13, 0($12)         # Φόρτωση στοιχείου

    # Πολλαπλασιασμός με προσθέσεις
    addiu $14, $0, 0       # αποτέλεσμα = 0
    addiu $15, $0, 0       # μετρητής επαναλήψεων
    addu $16, $0, $11      # αντίγραφο πολλαπλασιαστή

mult_loop:
    beq $15, $16, store_result  # Εάν τέλος πολλαπλασιασμού
    nop                         # Καθυστέρηση διακλάδωσης

    # Έλεγχος υπερχείλισης
    addu $17, $14, $13     # Δοκιμαστική πρόσθεση
    sltu $18, $17, $14     # Έλεγχος υπερχείλισης
    bne $18, $0, overflow_handler
    nop                    # Καθυστέρηση διακλάδωσης

    addu $14, $14, $13     # αποτέλεσμα += στοιχείο
    addiu $15, $15, 1      # μετρητής++
    j mult_loop
    nop                    # Καθυστέρηση άλματος

store_result:
    addiu $19, $12, 260    # Διεύθυνση αποτελέσματος
    sw $14, 0($19)         # Αποθήκευση αποτελέσματος
    addiu $9, $9, 1        # j++
    j inner_loop
    nop                    # Καθυστέρηση άλματος

next_row:
    addiu $8, $8, 1        # i++
    j outer_loop
    nop                    # Καθυστέρηση άλματος

overflow_handler:
    j overflow_handler     # Ατέρμων βρόχος σε περίπτωση υπερχείλισης
    nop                    # Καθυστέρηση άλματος

done:
    j done                 # Ατέρμων βρόχος για κανονικό τερματισμό
    nop                    # Καθυστέρηση άλματος
