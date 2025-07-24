% AI-Driven MIMO Equalization in Rician Fading Channels

%% Step 1: System Parameters
numTx = 4; 
numRx = 4; 
numSymbols = 1000;
K_dB = 10; 
K = 10^(K_dB/10);
snr_dB = 10; 
txPower = 0.1; 
noisePower = txPower / (10^(snr_dB/10));

%% Step 2: Generate Rician Fading MIMO Channel
H = zeros(numRx, numTx, numSymbols);
for t = 1:numSymbols
    LOS = sqrt(K/(K+1)) * ones(numRx, numTx);
    scatter = sqrt(1/(K+1)) * (randn(numRx, numTx) + 1i*randn(numRx, numTx)) / sqrt(2);
    H(:,:,t) = LOS + scatter;
end

%% Step 3: Transmit & Receive QPSK Symbols
bits = randi([0 1], numTx*2, numSymbols);
x = qammod(bits, 4, 'InputType', 'bit');
y = zeros(numRx, numSymbols);
for t = 1:numSymbols
    y(:,t) = H(:,:,t) * x(:,t) + sqrt(noisePower/2)*(randn(numRx,1)+1i*randn(numRx,1));
end

%% Step 4: Zero-Forcing Equalizer (Baseline)
zfSymbols = zeros(numTx, numSymbols);
zfSnr = zeros(1, numSymbols);
for t = 1:numSymbols
    W_zf = pinv(H(:,:,t));
    zfSymbols(:,t) = W_zf * y(:,t);
    % Calculate SNR for Zero-Forcing
    signalPower = norm(H(:,:,t) * x(:,t))^2 / numTx;
    noisePower_zf = norm(y(:,t) - H(:,:,t) * zfSymbols(:,t))^2 / numRx;
    zfSnr(t) = 10 * log10(signalPower / noisePower_zf);
end
zfBer = sum(sum(bits ~= qamdemod(zfSymbols, 4, 'OutputType', 'bit'))) / (numTx*2*numSymbols);
fprintf("[LOG] Zero-Forcing Equalizer BER: %.5f\n", zfBer);

% Log the average Gain for Zero-Forcing
zfGain = mean(zfSnr) - snr_dB;
fprintf("[LOG] Zero-Forcing Gain: %.5f dB\n", zfGain);

%% Step 5: Neural Network Equalizer - Data Generation
numTrain = 1000;
X = zeros(numTrain, numRx*numTx*2 + numRx*2);
Y = zeros(numTrain, numTx*2);
for i = 1:numTrain
    Htrain = sqrt(K/(K+1)) + sqrt(1/(K+1))*(randn(numRx,numTx)+1i*randn(numRx,numTx))/sqrt(2);
    b = randi([0 1], numTx*2, 1);
    xt = qammod(b, 4, 'InputType','bit');
    yt = Htrain * xt + sqrt(noisePower/2)*(randn(numRx,1)+1i*randn(numRx,1));
    X(i,:) = [real(Htrain(:)); imag(Htrain(:)); real(yt); imag(yt)]';
    Y(i,:) = b';
end
fprintf("[LOG] Training data shape: %d samples, %d features\n", size(X,1), size(X,2));

%% Step 6: Define & Train Network
layers = [
    featureInputLayer(size(X,2))
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(numTx*2)
    sigmoidLayer
    regressionLayer];

options = trainingOptions('adam', 'MaxEpochs', 50, 'MiniBatchSize', 32, 'Verbose', 1, 'Plots', 'training-progress');
net = trainNetwork(X, Y, layers, options);

%% Step 7: Evaluate Neural Equalizer
nnSymbols = zeros(numTx, numSymbols);
nnSnr = zeros(1, numSymbols);
for t = 1:numSymbols
    xtest = [real(reshape(H(:,:,t),[],1)); imag(reshape(H(:,:,t),[],1)); real(y(:,t)); imag(y(:,t))]';
    nnBits = round(predict(net, xtest))';
    nnSymbols(:,t) = qammod(nnBits, 4, 'InputType', 'bit');
    
    % Calculate SNR for Neural Network
    signalPower = norm(H(:,:,t) * x(:,t))^2 / numTx;
    noisePower_nn = norm(y(:,t) - H(:,:,t) * nnSymbols(:,t))^2 / numRx;
    nnSnr(t) = 10 * log10(signalPower / noisePower_nn);
end
nnBer = sum(sum(bits ~= nnBits)) / (numTx*2*numSymbols);
fprintf("[LOG] Neural Network Equalizer BER: %.5f\n", nnBer);

% Log the average Gain for Neural Network
nnGain = mean(nnSnr) - snr_dB;
fprintf("[LOG] Neural Network Gain: %.5f dB\n", nnGain);

%% Step 8: Results
fprintf('\n========== FINAL RESULTS ==========' );
fprintf('\nZero-Forcing BER: %.5f', zfBer);
fprintf('\nNeural Network BER: %.5f\n', nnBer);

% Display the Gain Comparison
fprintf("\n========== Gain Comparison ==========");
fprintf("\nZero-Forcing Gain: %.5f dB", zfGain);
fprintf("\nNeural Network Gain: %.5f dB", nnGain);

figure;
bar([zfBer, nnBer]);
set(gca, 'XTickLabel', {'Zero-Forcing', 'Neural Network'});
ylabel('Bit Error Rate');
title('MIMO Equalizer Performance under Rician Fading');
grid on;
saveas(gcf, 'MIMO_Equalizer_Results.png');

