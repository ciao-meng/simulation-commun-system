% File: c13_tiv1.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
%初始化
%
f1 = 512;					% default signal frequency，信号频率
f2 = 128;
bdoppler = 64;				% default doppler sampling，多普勒频率，决定脉冲延拓后的宽窄
fs = 8192; 					% default sampling frequency，采样频率
tduration = 1;				% default duration   
%
ts = 1.0/fs;				% sampling period，采样周期 
n = tduration*fs;			% number of samples，采样点数
t = ts*(0:n-1);			    % time vector，实际时间向量
x1 = exp(i*2*pi*f1*t)+exp(i*2*pi*f2*t);	    % complex signal，复信号
zz = zeros(1,n);
%
% Generate Uncorrelated seq of Complex Gaussian Samples，生成不相干的复高斯采样
%
z = randn(1,n)+ i*randn(1,n);
%
% Filter the uncorrelated samples to generate correlated samples，过滤波器产生相关的采样点
%
coefft = exp(-bdoppler*2*pi*ts);
h = waitbar(0,'Filtering Loop in Progress');
for k=2:n
   zz(k) = (ts*z(k))+coefft*zz(k-1);
   waitbar(k/n)
end
close(h)
y1 = x1.*zz; 			% filtered output of LTV system，时变系统滤波后的输出
%
% Plot the results in time domain and frequency domain，画图
%
[psdzz,freq] = log_psd(zz,n,ts);
figure;
plot(freq,psdzz); grid;
ylabel('Impulse Response in dB')
xlabel('Frequency')
title('PSD of the Impulse Response');
zzz = abs(zz.^2)/(mean(abs(zz.^2)));
figure; 
plot(10*log10(zzz)); grid;
ylabel('Sq. Mag. of h(t) in dB')
xlabel('Time Sample Index')
title('Normalized Magnitude Square of the Impulse Response in dB');
[psdx1,freq] = log_psd(x1,n,ts); 
figure; 
plot(freq,psdx1); grid;
ylabel('PSD of Tone Input in dB')
xlabel('Frequency')
title('PSD of Tone Input to the LTV System');
[psdy1,freq] = log_psd(y1,n,ts);
figure; 
plot(freq,psdy1); grid;
ylabel('PSD of Output in dB')
xlabel('Frequency')
title('Spread Output of the LTV System');
% End of script file.