% File: c10_MCQPSKber.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%QPSK在不同信噪比下的误差计算
%
Eb = 30:5:40; No = -50;					% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;					% Channel attenuation in dB
EbNodB = (Eb-ChannelAttenuation)-No;	    % Eb/No in dB
EbNo = 10.^(EbNodB./10);					% Eb/No in linear units
BER_T = 0.5*erfc(sqrt(EbNo)); 			    % BER (theoretical)
N = round(100./BER_T);          			% Symbols to transmit
BER = zeros(size(Eb)); 					% Initialize BER vector
for k=1:length(Eb)        					% Main Loop
  BER(k) = c214_QPSKrun(N(k),Eb(k),No,ChannelAttenuation,0.2,0,0,0);
  disp(['Simulation ',num2str(k*100/length(Eb)),'% Complete']);
end
figure
semilogy(EbNodB,BER,'o',EbNodB,BER_T,'-');
% axis([min(EbNodB) max(EbNodB) 0.001 0.1]);
xlabel('Eb/No (dB)'); ylabel('Bit Error Rate'); 
legend('BER Estimate','Theoretical BER'); grid;
% End of script file.
