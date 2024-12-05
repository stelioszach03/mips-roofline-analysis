#!/bin/bash
# MIPS-B Configuration: 8KB instruction and data caches
# Usage: ./mips_b.sh <block_size> <associativity> <input_file>
# Example: ./mips_b.sh 2 1 program.s

BLOCK_SIZE=${1:-2}  # Default block size: 2 words
ASSOCIATIVITY=${2:-1}  # Default associativity: 1-way
SETS=$((8192 / (4 * BLOCK_SIZE * ASSOCIATIVITY)))  # 8KB = 8192 bytes = 2048 words

../QtMips/build/target/qtmips_cli \
  --asm \
  --pipelined \
  --hazard-unit forward \
  --read-time 60 \
  --write-time 60 \
  --burst-time 60 \
  --i-cache "lru,$SETS,$BLOCK_SIZE,$ASSOCIATIVITY,wb" \
  --d-cache "lru,$SETS,$BLOCK_SIZE,$ASSOCIATIVITY,wb" \
  --dump-cycles \
  --dump-cache-stats \
  --dump-registers \
  --trace-execute \
  ${3:-validate_features.s}
