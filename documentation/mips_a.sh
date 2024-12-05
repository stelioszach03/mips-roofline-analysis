#!/bin/bash
# MIPS-A Configuration: No cache, five-stage pipeline
# Usage: ./mips_a.sh <input_file>

../QtMips/build/target/qtmips_cli \
  --asm \
  --pipelined \
  --hazard-unit forward \
  --read-time 60 \
  --write-time 60 \
  --burst-time 60 \
  --dump-cycles \
  --dump-registers \
  --trace-execute \
  ${1:-validate_features.s}
