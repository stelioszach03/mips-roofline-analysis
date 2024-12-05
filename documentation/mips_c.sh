#!/bin/bash
# MIPS-C Configuration: 8KB L1 + 64KB L2 unified cache
# Usage: ./mips_c.sh <block_size> <associativity> <input_file>

BLOCK_SIZE=${1:-2}  # Default block size: 2 words
ASSOCIATIVITY=${2:-1}  # Default associativity: 1-way
L1_SETS=$((8192 / (4 * BLOCK_SIZE * ASSOCIATIVITY)))  # 8KB L1

# Calculate effective access time based on L2 cache
# L2 hit time: 6 cycles, Main memory: 60 cycles
# Effective time = L2_hit_rate * L2_time + (1-L2_hit_rate) * mem_time
EFFECTIVE_TIME=33  # Approximated based on typical L2 hit rates

../QtMips/build/target/qtmips_cli \
  --asm \
  --pipelined \
  --hazard-unit forward \
  --read-time $EFFECTIVE_TIME \
  --write-time $EFFECTIVE_TIME \
  --burst-time $EFFECTIVE_TIME \
  --i-cache "lru,$L1_SETS,$BLOCK_SIZE,$ASSOCIATIVITY,wb" \
  --d-cache "lru,$L1_SETS,$BLOCK_SIZE,$ASSOCIATIVITY,wb" \
  --dump-cycles \
  --dump-cache-stats \
  --dump-registers \
  --trace-execute \
  ${3:-validate_features.s}
