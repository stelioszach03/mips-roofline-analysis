#!/bin/bash
# Build script for MIPS assembly programs

# Ensure MIPS toolchain is installed
if ! command -v mips-linux-gnu-as &> /dev/null; then
    echo "Installing MIPS toolchain..."
    sudo apt-get update
    sudo apt-get install -y gcc-mips-linux-gnu
fi

# Set memory addresses according to QtMips requirements
echo "Building ELF file..."
mips-linux-gnu-as -mips32 -EB -o validate_features.o validate_features.s
mips-linux-gnu-ld -EB -Ttext=0x00400000 -Tdata=0x10000000 -o validate_features.elf validate_features.o

echo "Build complete. Running tests..."

# Run tests with different configurations
echo -e "\nMIPS-A (No cache):"
./mips_a.sh ./validate_features.elf 2>&1 | tee mips_a_results.txt

echo -e "\nMIPS-B (L1 cache - 2 words, 1-way):"
./mips_b.sh 2 1 ./validate_features.elf 2>&1 | tee mips_b_results_2_1.txt

echo -e "\nMIPS-B (L1 cache - 4 words, 2-way):"
./mips_b.sh 4 2 ./validate_features.elf 2>&1 | tee mips_b_results_4_2.txt

echo -e "\nMIPS-C (Combined L1+L2 - 2 words, 1-way):"
./mips_c.sh 2 1 ./validate_features.elf 2>&1 | tee mips_c_results.txt
