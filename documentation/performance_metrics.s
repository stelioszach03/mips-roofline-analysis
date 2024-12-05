# Μετρήσεις επιδόσεων για τις υλοποιήσεις πράξεων πινάκων
# Υπολογισμός MPS (πολλαπλασιασμοί ανά δευτερόλεπτο) και MPB (πολλαπλασιασμοί ανά byte)

.data
    # Μετρητές επιδόσεων
    mult_count: .word 0    # Συνολικός αριθμός πολλαπλασιασμών
    cycle_count: .word 0   # Συνολικός αριθμός κύκλων
    byte_count: .word 0    # Συνολικός αριθμός bytes δεδομένων

    # Σταθερές για υπολογισμούς
    clock_freq: .word 100000000  # Συχνότητα ρολογιού (100 MHz)

    # Αποτελέσματα
    mps_result: .word 0    # Πολλαπλασιασμοί ανά δευτερόλεπτο
    mpb_result: .word 0    # Πολλαπλασιασμοί ανά byte

.text
.globl calculate_metrics
calculate_metrics:
    # Παράμετροι:
    # $a0 = μέγεθος n
    # $a1 = τύπος λειτουργίας (1=vector-scalar, 2=matrix-scalar, 3=matrix-matrix)

    # Υπολογισμός bytes δεδομένων
    mul $t0, $a0, $a0      # n^2 για πίνακες
    sll $t0, $t0, 2        # * 4 bytes ανά στοιχείο

    # Υπολογισμός πλήθους πολλαπλασιασμών
    beq $a1, 1, vec_scalar_mults
    beq $a1, 2, mat_scalar_mults
    beq $a1, 3, mat_mat_mults

vec_scalar_mults:
    move $t1, $a0          # n πολλαπλασιασμοί
    j store_counts

mat_scalar_mults:
    mul $t1, $a0, $a0      # n^2 πολλαπλασιασμοί
    j store_counts

mat_mat_mults:
    mul $t1, $a0, $a0      # n^2 για κάθε στοιχείο του αποτελέσματος
    mul $t1, $t1, $a0      # * n για τον εσωτερικό βρόχο

store_counts:
    sw $t0, byte_count     # Αποθήκευση bytes
    sw $t1, mult_count     # Αποθήκευση πολλαπλασιασμών

    # Υπολογισμός MPS και MPB θα γίνει στο κύριο πρόγραμμα
    # καθώς χρειάζεται μέτρηση πραγματικών κύκλων εκτέλεσης

    jr $ra                 # Επιστροφή
