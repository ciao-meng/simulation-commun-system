% File: c13_tiv1.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
%��ʼ��
%
f1 = 512;					% default signal frequency���ź�Ƶ��
f2 = 128;
bdoppler = 64;				% default doppler sampling��������Ƶ�ʣ������������غ�Ŀ�խ
fs = 8192; 					% default sampling frequency������Ƶ��
tduration = 1;				% default duration   
%
ts = 1.0/fs;				% sampling period���������� 
n = tduration*fs;			% number of samples����������
t = ts*(0:n-1);			    % time vector��ʵ��ʱ������
x1 = exp(i*2*pi*f1*t)+exp(i*2*pi*f2*t);	    % complex signal�����ź�
zz = zeros(1,n);
%
% Generate Uncorrelated seq of Complex Gaussian Samples�����ɲ���ɵĸ���˹����
%
z = randn(1,n)+ i*randn(1,n);
%
% Filter the uncorrelated samples to generate correlated samples�����˲���������صĲ�����
%
coefft = exp(-bdoppler*2*pi*ts);
h = waitbar(0,'Filtering Loop in Progress');
for k=2:n
   zz(k) = (ts*z(k))+coefft*zz(k-1);
   waitbar(k/n)
end
close(h)
y1 = x1.*zz; 			% filtered output of LTV system��ʱ��ϵͳ�˲�������
%
% Plot the results in time domain and frequency domain����ͼ
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