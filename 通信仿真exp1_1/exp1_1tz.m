clc
clear
snrdB_min = -3; 
snrdB_max = 8;	    % SNR (in dB) limits 
snrdB = snrdB_min:1:snrdB_max;
Nsymbols = input('Enter number of symbols > ');
% [ber_sim1 ber_theor1] = comsimexp1_1(snrdB,Nsymbols);
[ber_sim2 ber_theor2] = c203_MCBPSK(snrdB,Nsymbols);
[ber_sim3 ber_theor3] = c204_MCBFSK(snrdB,Nsymbols);
[ber_sim4 ber_theor4] = kaiguanxinhao(snrdB,Nsymbols);
% semilogy(snrdB,ber_theor1,snrdB,ber_sim1,'o');
% hold on
semilogy(snrdB,ber_theor2,snrdB,ber_sim2,'square');
hold on
semilogy(snrdB,ber_theor3,snrdB,ber_sim3,'+');
hold on
semilogy(snrdB,ber_theor4,snrdB,ber_sim4,'diamond');

axis([snrdB_min snrdB_max 0.0001 1]);
xlabel('SNR in dB')
ylabel('BER')
legend('BPSK-Theor','BPSK-Simu','BFSK-Theor','BFSK-Simu','BASK-Theor','BASK-Simu')
