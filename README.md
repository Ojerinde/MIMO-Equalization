# AI-Driven MIMO Equalization in Rician Fading Channels

## Project Overview

This project investigates the application of machine learning for equalization in MIMO systems under Rician fading conditions. Specifically, it implements and evaluates a neural network-based equalizer against the conventional Zero-Forcing (ZF) method. The system simulates a 4x4 MIMO communication environment with QPSK modulation in MATLAB, comparing Bit Error Rate (BER) and Signal-to-Noise Ratio (SNR) gain across both equalization techniques.

## Research Context

MIMO systems are fundamental to next-generation wireless networks, including 6G, due to their ability to improve capacity and reliability. However, their performance in fading environments is often degraded. Traditional ZF equalizers are known to suffer from noise amplification, especially in channels with a strong line-of-sight component. This project proposes a neural network-based equalizer to address these limitations, learning nonlinear relationships between received signals and transmitted data for improved accuracy in Rician fading channels.

## Key Features

- **Neural Network Equalizer**: Learns to reconstruct transmitted signals from received signals and estimated channels.
- **Zero-Forcing Equalizer**: Implements a baseline using the pseudo-inverse of the channel matrix.
- **Rician Channel Model**: Simulates a realistic wireless environment with a 10 dB K-factor.
- **QPSK Modulation**: Enables efficient transmission and demodulation.
- **Performance Evaluation**: Uses BER and SNR gain as quantitative metrics.
- **Visualization**: Compares equalizers via a BER bar plot.

## Technical Stack

- **MATLAB**: For channel simulation, equalizer design, and result analysis.
- **Neural Network Toolbox**: Trains the AI-based equalizer.
- **Communications Toolbox**: Supports modulation, demodulation, and channel modeling.

## Directory Structure

```
mimo-equalizer/
├── main.m                      # Main simulation and evaluation script
├── MIMO_Equalizer_Results.png # Output plot for BER comparison
├── README.md                   # Project documentation
```

## Installation & Execution

### Requirements

- MATLAB R2020a or newer
- Neural Network Toolbox
- Communications Toolbox

### Steps

1. Clone the repository:

```bash
git clone https://github.com/your-username/mimo-equalizer.git
cd mimo-equalizer
```

2. Open MATLAB and navigate to the project directory.

3. Run the simulation:

```matlab
main
```

This will simulate transmission, apply both equalizers, compute metrics, and save a comparative BER plot.

## Methodology

### 1. Channel Setup

- Simulates a 4×4 Rician fading MIMO system with a 10 dB K-factor.
- Number of QPSK symbols: 1000
- Adds Gaussian noise to simulate a 10 dB SNR environment.

### 2. Equalizers

- **Zero-Forcing (ZF)**:

  - Uses the pseudo-inverse of the channel matrix to estimate transmitted symbols.
  - Prone to noise enhancement in correlated or poorly conditioned channels.

- **Neural Network**:
  - A feedforward network with 128 hidden neurons.
  - Trained on 1000 samples using received signals and channel matrix as input features.
  - Aims to reduce BER by learning nonlinear mappings.

### 3. Performance Metrics

- **Bit Error Rate (BER)**:
  - Measures the fraction of incorrectly decoded bits.
- **SNR Gain**:
  - Compares average output SNR between the two equalizers.

### 4. Output

- Console:
  - Displays individual BER values and SNR gain.
- File:
  - Saves a bar chart comparing BER to `MIMO_Equalizer_Results.png`.

## Sample Results

```
Zero-Forcing BER: 0.02345
Neural Network BER: 0.01234
Neural Network Gain: 2.15 dB
```

![BER Comparison](MIMO_Equalizer_Results.png)

## Suggested Enhancements

- **Advanced Neural Models**: Incorporate CNN or LSTM architectures for improved feature extraction.
- **Robustness Testing**: Evaluate across multiple SNR levels and channel realizations.
- **Channel Extensions**: Integrate mmWave or terahertz fading models relevant for 6G scenarios.
- **Scalability**: Expand to larger MIMO dimensions (e.g., 8×8).
- **Online Processing**: Enable adaptive equalization for real-time communication systems.

## References

1. W. Saad et al., “A vision of 6G wireless systems,” _IEEE Network_, vol. 34, no. 3, pp. 134–142, 2020.
2. A. Goldsmith, _Wireless Communications_. Cambridge University Press, 2005.
3. G. L. Stuber, _Principles of Mobile Communication_, 4th ed., Springer, 2017.
4. H. Ye et al., “Deep learning for channel estimation and signal detection in OFDM,” _IEEE Wireless Commun. Lett._, vol. 7, no. 1, pp. 114–117, 2018.

## License

This project is licensed under the MIT License.
