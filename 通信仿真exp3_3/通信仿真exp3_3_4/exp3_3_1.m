% File: c14_threeray.m
% Software given here is to accompany the textbook: W.H. Tranter,
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of
% Communication Systems Simulation with Wireless Applications,
% Prentice Hall PTR, 2004.
%
% Default parameters
%
function [peideal,pesystem]=ber1(ebn0db)
NN = 512;								% number of symbols
tb = 0.5;								% bit time
fs = 16;                                % samples/symbol
ebn0db = [1:1:10];						% Eb/N0 vector
ebn0=10.^(ebn0db/10);% bit power per noise
L = length(ebn0db);
for k=1:L
    %
    % Establish QPSK signals
    %
    x = random_binary(NN,fs)+i*random_binary(NN,fs);   % QPSK signal
    %
    % 过AWGN信道
    %
    y1 = x;
    %
    % Matched filter，积分滤波
    %
    b = ones(1,fs); b = b/fs; a = 1;
    y = filter(b,a,y1);
    %
    % End of simulation
    %
    % Use the semianalytic BER estimator. The following sets
    % up the semi analytic estimator. Find the maximum magnitude
    % of the cross correlation and the corresponding lag.
    %
    [cor lags] = vxcorr(x,y);
    [cmax nmax] = max(abs(cor));
    timelag = lags(nmax);
    theta = angle(cor(nmax))
    y = y*exp(-i*theta);     								% derotate
    %
    % Noise BW calibration，噪声带宽校准
    %
    hh = impz(b,a); ts = 1/16; nbw = (fs/2)*sum(hh.^2);
    %
    % Delay the input, and do BER estimation on the last 128 bits.
    % Use middle sample. Make sure the index does not exceed number
    % of input points. Eb should be computed at the receiver input.
    %
    index = (10*fs+8:fs:(NN-10)*fs+8);
    xx = x(index);
    yy = y(index-timelag+1);
    [n1 n2] = size(y1); ny2=n1*n2;
    eb = tb*sum(sum(abs(y1).^2))/ny2;
    eb = eb/2;
    [peideal(k),pesystem(k)] = qpsk_berest(xx,yy,ebn0(k),eb,tb,nbw);
end
% figure
% semilogy(ebn0db,peideal,'b*-',ebn0db,pesystem,'r+-')
% xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
% legend('理论值','仿真值')
% axis([0 11 10^(-6) 1])
% End of script file.