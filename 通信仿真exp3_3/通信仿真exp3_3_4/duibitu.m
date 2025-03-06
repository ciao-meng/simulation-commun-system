clc;
clear;
ebn0db = [1:1:10];
[peideal1,pesystem1]=ber1(ebn0db);
[peideal2,pesystem2]=ber2(ebn0db);
[peideal3,pesystem3]=ber3(ebn0db);
figure
semilogy(ebn0db,peideal1,'*-',ebn0db,pesystem1,'+-')
hold on
semilogy(ebn0db,pesystem2,'+-')
hold on
semilogy(ebn0db,pesystem3,'+-')
xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
legend('理论值','情况一','情况二','情况三')
axis([0 11 10^(-6) 10])
