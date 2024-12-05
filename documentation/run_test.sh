#!/bin/bash

# Configuration parameters
BLOCK_SIZES=(2 4 8)  # words per block
ASSOCIATIVITIES=(1 2 4)  # ways

# Calculate cache sets based on total size, block size, and associativity
# Parameters: total_size_kb block_size assoc
calculate_sets() {
    local total_words=$((($1 * 1024) / 4))  # Convert KB to words (4 bytes per word)
    echo $((total_words / ($2 * $3)))  # sets = total_words / (block_size * associativity)
}

# Test function
run_test() {
    local config=$1
    local block_size=$2
    local assoc=$3
    local test_file=$4

    echo "=== Testing configuration ==="
    echo "Config: $config"
    echo "Block size: $block_size words"
    echo "Associativity: $assoc-way"
    echo "Test file: $test_file"
    echo "=========================="

    case $config in
        "mips-a")
            ./mips_a.sh "$test_file"
            ;;
        "mips-b")
            # 8KB L1 caches
            local l1_sets=$(calculate_sets 8 $block_size $assoc)
            ./mips_b.sh \
                --i-cache "lru,$l1_sets,$block_size,$assoc,wb" \
                --d-cache "lru,$l1_sets,$block_size,$assoc,wb" \
                "$test_file"
            ;;
        "mips-c")
            # 8KB L1 caches and 64KB L2 cache
            local l1_sets=$(calculate_sets 8 $block_size $assoc)
            local l2_sets=$(calculate_sets 64 $block_size $assoc)
            ./mips_c.sh \
                --i-cache "lru,$l1_sets,$block_size,$assoc,wb" \
                --d-cache "lru,$l1_sets,$block_size,$assoc,wb" \
                --l2-cache "lru,$l2_sets,$block_size,$assoc,wb" \
                "$test_file"
            ;;
    esac
}

# Verify test file exists
if [ $# -lt 1 ]; then
    echo "Usage: $0 <test_file>"
    exit 1
fi

TEST_FILE=$1
if [ ! -f "$TEST_FILE" ]; then
    echo "Error: Test file '$TEST_FILE' not found"
    exit 1
fi

# Run tests for each configuration
echo "Testing MIPS-A (no cache)"
run_test "mips-a" 0 0 "$TEST_FILE"

echo -e "\nTesting MIPS-B configurations:"
for block_size in "${BLOCK_SIZES[@]}"; do
    for assoc in "${ASSOCIATIVITIES[@]}"; do
        echo -e "\n---"
        run_test "mips-b" "$block_size" "$assoc" "$TEST_FILE"
    done
done

echo -e "\nTesting MIPS-C configurations:"
for block_size in "${BLOCK_SIZES[@]}"; do
    for assoc in "${ASSOCIATIVITIES[@]}"; do
        echo -e "\n---"
        run_test "mips-c" "$block_size" "$assoc" "$TEST_FILE"
    done
done
