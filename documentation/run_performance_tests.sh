#!/bin/bash

# Εκτέλεση δοκιμών επιδόσεων για όλες τις υλοποιήσεις

# Συνάρτηση για εκτέλεση δοκιμής και υπολογισμό μετρικών
run_test() {
    local size=$1
    local type=$2
    local config=$3
    local program=$4

    echo "=== Εκτέλεση δοκιμής: μέγεθος=${size}, τύπος=${type}, διαμόρφωση=${config} ==="

    # Εκτέλεση του προγράμματος στον QtMips
    case $config in
        "MIPS-A")
            ./mips_a.sh $program
            ;;
        "MIPS-B")
            ./mips_b.sh $program
            ;;
        "MIPS-C")
            ./mips_c.sh $program
            ;;
    esac

    # Υπολογισμός μετρικών από τα αποτελέσματα
    # Οι τιμές θα διαβαστούν από τα αρχεία εξόδου του QtMips
    echo "Υπολογισμός MPS και MPB..."
}

# Μεγέθη πινάκων για δοκιμή
SIZES=(8 16 32)

# Διαμορφώσεις MIPS
CONFIGS=("MIPS-A" "MIPS-B" "MIPS-C")

# Εκτέλεση δοκιμών για vector-scalar multiplication
for size in "${SIZES[@]}"; do
    for config in "${CONFIGS[@]}"; do
        run_test $size "vector-scalar" $config "vector_scalar_mult_${size}.s"
    done
done

# Εκτέλεση δοκιμών για matrix-scalar multiplication
for size in "${SIZES[@]}"; do
    for config in "${CONFIGS[@]}"; do
        run_test $size "matrix-scalar" $config "matrix_scalar_mult_${size}.s"
    done
done

# Εκτέλεση δοκιμών για matrix-matrix multiplication
for size in "${SIZES[@]}"; do
    for config in "${CONFIGS[@]}"; do
        run_test $size "matrix-matrix" $config "matrix_matrix_mult_${size}.s"
    done
done

echo "Ολοκλήρωση δοκιμών επιδόσεων"
