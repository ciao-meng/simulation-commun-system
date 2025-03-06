% File: c10_MCBPSKdelay.m
% ¼ÆËã×î¼ÑÑÓÊ±
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
clc;clear;
EbNodB = 6;										% Eb/No (dB) value
z = 10.^(EbNodB/10);							% convert to linear scale
delay = 0:8;%0:16									% delay vector
BER = zeros(1,length(delay));					% initialize BER vector
Errors = zeros(1,length(delay));				% initialize Errors vector
BER_T = qfunc(sqrt(2*z))*ones(1,length(delay));	    % theoretical BER vector
N = round(20./BER_T);							% 100 errors for ideal (zero ISI) system							
FilterSwitch = 1;								% set filter switch (in=1 or out=0)
for k=1:length(delay)
   [BER(k),Errors(k)] = MCBPSKrun1(N(k),z,delay(k),FilterSwitch);
end
figure
semilogy(delay,BER,'o',delay,BER_T,'-'); grid;
xlabel('Delay'); ylabel('Bit Error Rate');
% End of script file.