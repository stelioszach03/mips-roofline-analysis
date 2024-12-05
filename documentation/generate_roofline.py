#!/usr/bin/env python3
# Δημιουργία διαγραμμάτων Roofline για τις διαμορφώσεις MIPS

import matplotlib.pyplot as plt
import numpy as np

def calculate_peak_performance(config):
    """Υπολογισμός μέγιστης επίδοσης"""
    clock_freq = 100e6  # 100 MHz
    base_cpi = 1.2
    if config == 'MIPS-A':
        cpi_eff = 21.0
    elif config == 'MIPS-B':
        cpi_eff = 10.2
    else:  # MIPS-C
        cpi_eff = 6.12
    return clock_freq / (cpi_eff * 4)  # 4 instructions per multiplication

def calculate_memory_bandwidth(config):
    """Υπολογισμός εύρους ζώνης μνήμης"""
    word_size = 4  # bytes
    clock_freq = 100e6  # 100 MHz
    if config == 'MIPS-A':
        return (word_size * clock_freq) / 60  # Main memory latency
    elif config == 'MIPS-B':
        return (word_size * clock_freq) / 10.2  # L1 cache effective latency
    else:  # MIPS-C
        return (word_size * clock_freq) / 6.12  # L1+L2 effective latency

def plot_roofline(config):
    """Δημιουργία διαγράμματος Roofline"""
    peak_perf = calculate_peak_performance(config)
    mem_bandwidth = calculate_memory_bandwidth(config)

    # Δημιουργία καμπύλης Roofline
    ai = np.logspace(-2, 2, 1000)
    memory_bound = mem_bandwidth * ai
    compute_bound = np.full_like(ai, peak_perf)
    performance = np.minimum(memory_bound, compute_bound)

    plt.figure(figsize=(12, 8))
    plt.plot(ai, performance, 'b-', linewidth=2, label='Roofline')
    plt.axhline(y=peak_perf, color='r', linestyle='--',
                label=f'Μέγιστη Επίδοση ({peak_perf/1e6:.2f} MMPS)')

    # Σημεία εργασιών
    n_values = [8, 16, 32]

    # Vector and scalar matrix multiplication
    ai_vec = 0.125  # 1 multiplication per 8 bytes (2 words)
    perf_vec = {
        'MIPS-A': 1.19e6,
        'MIPS-B': 2.45e6,
        'MIPS-C': 4.08e6
    }
    plt.scatter([ai_vec], [perf_vec[config]], marker='o', s=100,
                label='Διανυσματικός/Βαθμωτός', color='green')

    # Matrix multiplication: AI increases with matrix size
    ai_mat = [n/8 for n in n_values]  # n multiplications per 8n bytes
    perf_mat = {
        'MIPS-A': [6.61e5, 6.04e5, 5.56e5],
        'MIPS-B': [1.32e6, 1.21e6, 1.11e6],
        'MIPS-C': [2.28e6, 2.04e6, 1.85e6]
    }

    for i, (ai_val, perf_val) in enumerate(zip(ai_mat, perf_mat[config])):
        plt.scatter([ai_val], [perf_val], marker='s', s=100,
                    label=f'Πίνακας-Πίνακας n={n_values[i]}', color=f'C{i+2}')

    plt.xscale('log')
    plt.yscale('log')
    plt.grid(True, which="both", ls="-", alpha=0.2)
    plt.xlabel('Αριθμητική Ένταση (πολλαπλασιασμοί/byte)')
    plt.ylabel('Επίδοση (MPS)')
    plt.title(f'Διάγραμμα Roofline - {config}')
    plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')

    # Adjust layout to prevent legend cutoff
    plt.tight_layout()
    plt.savefig(f'/home/ubuntu/roofline_analysis/roofline_{config.lower()}.pdf',
                bbox_inches='tight', dpi=300)
    plt.close()

def main():
    """Κύρια συνάρτηση"""
    for config in ['MIPS-A', 'MIPS-B', 'MIPS-C']:
        plot_roofline(config)

if __name__ == '__main__':
    main()
