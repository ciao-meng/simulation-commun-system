% File: c14_threeray.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
function [peideal,pesystem]=ber2(ebn0db)
%
% Default parameters
% 
NN = 512;								% number of symbols
tb = 0.5;								% bit time
fs = 16;                                % samples/symbol
% ebn0db = [1:2:14];						% Eb/N0 vector
%
% Establish QPSK signals
%
x = random_binary(NN,fs)+i*random_binary(NN,fs);   % QPSK signal
%
% Input powers and delays
%
p1 = 0.2;%input('Enter P1 > ');
%
% Set up the Complex Gaussian (Rayleigh) gains
%
gain1 = sqrt(p1)*abs(randn(1,NN) + i*randn(1,NN));

for k = 1:NN%此处可改为卷积求采样后的结果，不需要循环
    for kk=1:fs
        index=(k-1)*fs+kk;
        ggain1(1,index)=gain1(1,k);
    end
end
y1 = x;

for k=1:(NN*fs)
    y2(1,k)=  y1(1,k)*ggain1(1,k);
end
%
% Matched filter
%
b = ones(1,fs); b = b/fs; a = 1;
y = filter(b,a,y2);
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
% Noise BW calibration
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
[n1 n2] = size(y2); ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;
eb = eb/2;
[peideal,pesystem] = qpsk_berest(xx,yy,ebn0db,eb,tb,nbw);
% figure
% semilogy(ebn0db,peideal,'b*-',ebn0db,pesystem,'r+-')
% xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
% legend('理论值','仿真值')
% axis([0 14 10^(-10) 1])
% End of script file.