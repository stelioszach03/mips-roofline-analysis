# MIPS Processor Performance Analysis

## Overview
This repository contains a comprehensive performance analysis of three MIPS processor configurations (MIPS-A, MIPS-B, MIPS-C) using the Roofline model. The analysis focuses on computational efficiency, memory hierarchy impact, and overall system performance across various computational tasks.

## Repository Structure
```
.
├── documentation_en.pdf    # Detailed technical documentation
├── roofline_analysis/     # Performance analysis diagrams
├── assembly/              # MIPS assembly test programs
│   ├── matrix_operations/
│   ├── vector_operations/
│   └── performance_tests/
└── scripts/               # Build and test scripts
```

## Key Features
- Performance analysis using the Roofline model
- Comparative study of three MIPS configurations
- Implementation of various computational kernels:
  - Matrix-Matrix multiplication
  - Matrix-Scalar multiplication
  - Vector-Scalar multiplication
- Comprehensive performance metrics collection

## Performance Metrics
The analysis includes key performance indicators:
- MPS (Multiplications Per Second)
- MPB (Multiplications Per Byte)
- Cache hierarchy impact
- Memory bandwidth utilization
- Arithmetic intensity analysis

## Building and Running Tests
```bash
# Build all test programs
./build.sh

# Run performance tests
./run_performance_tests.sh

# Generate roofline diagrams
python3 generate_roofline.py
```

## Documentation
For detailed technical analysis and methodology, refer to `documentation_en.pdf`. The document includes:
- Detailed system characteristics
- Performance analysis methodology
- Roofline model implementation
- Comparative analysis results
- Conclusions and recommendations

## Test Programs
The repository includes various MIPS assembly test programs:
- Basic instruction tests
- Performance measurement routines
- Matrix and vector operation implementations
- Cache overflow tests

## Results
Performance analysis results are visualized through Roofline diagrams for each MIPS configuration, showing:
- Peak computational performance
- Memory bandwidth limitations
- Cache effects on performance
- Operational intensity characteristics

## License
[Specify License]

## Contributing
[Contribution Guidelines]
