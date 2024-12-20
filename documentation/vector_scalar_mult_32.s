# Πολλαπλασιασμός διανύσματος με βαθμωτό (n=32)
# Υλοποίηση για QtMips με βασικές εντολές

.data
    # Διάνυσμα εισόδου (n=32)
    vector: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
           .word 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
    # Βαθμωτός αριθμός
    scalar: .word 2
    # Διάνυσμα αποτελέσματος
    result: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
.globl __start
__start:
    # Αρχικοποίηση μετρητών και διευθύνσεων
    addiu $8, $0, 0        # μετρητής = 0
    addiu $9, $0, 32       # όριο = 32
    lui $1, 0x1000         # Βάση διεύθυνσης δεδομένων
    lw $10, 128($1)        # Φόρτωση βαθμωτού

loop:
    beq $8, $9, done       # Εάν μετρητής = όριο, τέλος
    nop                    # Καθυστέρηση διακλάδωσης

    # Υπολογισμός διεύθυνσης στοιχείου
    sll $5, $8, 2          # μετρητής * 4 (μέγεθος word)
    addu $6, $1, $5        # Διεύθυνση πηγής
    lw $12, 0($6)          # Φόρτωση στοιχείου

    # Πολλαπλασιασμός με προσθέσεις
    addiu $14, $0, 0       # αποτέλεσμα = 0
    addiu $15, $0, 0       # μετρητής επαναλήψεων
    addu $16, $0, $10      # αντίγραφο πολλαπλασιαστή

mult_loop:
    beq $15, $16, store_result  # Εάν τέλος πολλαπλασιασμού
    nop                         # Καθυστέρηση διακλάδωσης

    # Έλεγχος υπερχείλισης
    addu $17, $14, $12     # Δοκιμαστική πρόσθεση
    sltu $18, $17, $14     # Έλεγχος υπερχείλισης
    bne $18, $0, overflow_handler
    nop                    # Καθυστέρηση διακλάδωσης

    addu $14, $14, $12     # αποτέλεσμα += στοιχείο
    addiu $15, $15, 1      # μετρητής++
    j mult_loop
    nop                    # Καθυστέρηση άλματος

store_result:
    addiu $7, $6, 132      # Διεύθυνση αποτελέσματος
    sw $14, 0($7)          # Αποθήκευση αποτελέσματος
    addiu $8, $8, 1        # μετρητής++
    j loop
    nop                    # Καθυστέρηση άλματος

overflow_handler:
    j overflow_handler     # Ατέρμων βρόχος σε περίπτωση υπερχείλισης
    nop                    # Καθυστέρηση άλματος

done:
    j done                 # Ατέρμων βρόχος για κανονικό τερματισμό
    nop                    # Καθυστέρηση άλματος
