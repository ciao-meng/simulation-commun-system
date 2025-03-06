% File: c13_tiv2.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%

clc
clear
%
%设置变量
%
ndelay = 8; %时延时间
f1 = 512;					% default signal frequency
f2 = 128;
bdoppler = 16;				% default doppler sampling
fs = 8192; 					% default sampling frequency
tduration = 1;				% default duration   
ts = 1.0/fs;				% sampling period 
n = tduration*fs;			% number of samples
t = ts*(0:n-1);			    % time vector
x1 = exp(i*2*pi*f1*t)+exp(i*2*pi*f2*t);	    % complex signal
%
% Generate a seq of Complex Gaussian Samples
%
z1 = randn(1,n)+i*randn(1,n);
%
% Filter the two uncorrelated samples to generate correlated sequences
%
coefft = exp(-bdoppler*2*pi*ts);     
zz1 = zeros(1,n);
for k = 2:n   
   zz1(k) = z1(k)+coefft*zz1(k-1);
end
%
% compute the output
%
y1 = x1.*zz1;					 	% first output component 
y2 = x1.*zz1; 						% second output component
y(1:ndelay) = y1(1:ndelay);
y(ndelay+1:n) = y1(ndelay+1:n)+y2(1:n-ndelay);%延时相加
%
% Plot the results 
%
[psdzz1,freq] = log_psd(zz1,n,ts);%h~的冲激响应
figure; plot(freq,psdzz1); grid;
title('PSD of the First Component Impulse Response');
[psdx1,freq] = log_psd(x1,n,ts); %输入信号
figure; 
plot(freq,psdx1); grid;
ylabel('PSD of Tone Input in dB')
xlabel('Frequency')
title('PSD of Tone Input to the LTV System');
[psdx1,freq] = log_psd(y1,n,ts); %发生频谱扩展的输出
figure; 
plot(freq,psdx1); grid;
ylabel('PSD of First Output in dB')
xlabel('Frequency')
title('PSD of First Component to the LTV System');
[psdy,freq] = log_psd(y,n,ts);%发生频率选择性衰落的输出
figure; 
plot(freq,psdy); grid;
ylabel('PSD of Output in dB')
xlabel('Frequency')
title('Spread Output of the LTV System');
% End of script file.