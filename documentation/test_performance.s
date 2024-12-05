# Πρόγραμμα ελέγχου μετρήσεων επιδόσεων
# Ενσωματώνει τον κώδικα μέτρησης επιδόσεων με τις υλοποιήσεις πράξεων

.data
    # Μηνύματα εξόδου
    msg_mps: .asciiz "MPS (Πολλαπλασιασμοί/δευτερόλεπτο): "
    msg_mpb: .asciiz "\nMPB (Πολλαπλασιασμοί/byte): "
    newline: .asciiz "\n"

    # Καταχωρητές επιδόσεων
    start_cycles: .word 0
    end_cycles: .word 0
    total_cycles: .word 0

.text
.globl __start
__start:
    # Αποθήκευση αρχικών κύκλων
    mfc0 $t0, $9           # Διάβασμα μετρητή κύκλων
    sw $t0, start_cycles

    # Εκτέλεση της πράξης που θέλουμε να μετρήσουμε
    # (θα αντικατασταθεί με την πραγματική πράξη)
    jal test_operation

    # Αποθήκευση τελικών κύκλων
    mfc0 $t1, $9           # Διάβασμα τελικού μετρητή
    sw $t1, end_cycles

    # Υπολογισμός συνολικών κύκλων
    subu $t2, $t1, $t0
    sw $t2, total_cycles

    # Κλήση υπολογισμού μετρικών
    li $a0, 8              # Παράδειγμα: n=8
    li $a1, 1              # Παράδειγμα: vector-scalar
    jal calculate_metrics

    # Υπολογισμός MPS
    lw $t0, mult_count
    lw $t1, clock_freq
    lw $t2, total_cycles
    mul $t3, $t0, $t1      # mults * freq
    div $t3, $t2           # / cycles
    sw $t3, mps_result

    # Υπολογισμός MPB
    lw $t0, mult_count
    lw $t1, byte_count
    div $t0, $t1           # mults / bytes
    sw $t0, mpb_result

    # Τερματισμός
    j done

test_operation:
    # Εδώ θα μπει η πραγματική πράξη που θέλουμε να μετρήσουμε
    jr $ra

done:
    j done                 # Ατέρμων βρόχος
    nop

# Συμπερίληψη του κώδικα μετρήσεων επιδόσεων
.include "performance_metrics.s"
