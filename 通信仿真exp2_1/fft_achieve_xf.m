clc;clear;
echo on
ts=0.1;	% Sampling period					% set parameters
fs=1/ts; % Sampling frequency    
df=0.01;
L=1500;% Length of signal
t = (0:L-1)*ts;        % Time vector
x = 5*cos(2*pi*3*t) + 3*sin(2*pi*4*t);

[X,x,df1]=fftseq(x,ts,df);			% derive the FFT

X1=X/L;                            		% scaling
f=[0:df1:df1*(length(x)-1)]-fs/2;   		% frequency vector for FFT
plot(f,fftshift(abs(X1)));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived numerically')
