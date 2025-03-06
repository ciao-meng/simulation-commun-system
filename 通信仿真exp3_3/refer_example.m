% close all
% clear all
% clc
% 
% j = sqrt(-1);                           % define complex number
% N = 1e+6;                               % define number of symbols
% s = [-1+j -1-j +1+j +1-j];              % define BPSK symbols
% s = s/norm(s)*sqrt(length(s));          % normalize the energy
% txd = randsrc(1,N,s);                   % generate QPSK symbols
% SNR_dB = linspace(0,30,11);             % range of SNR dB values
% SNR = db2pow(SNR_dB);                   % convert dB to power
% sigma = 1./sqrt(2*SNR);                 % define noise standard deviation
% noise = randn(1,N) + j*randn(1,N);      % generate noise
% ch = (randn(1,N)+j*randn(1,N))/sqrt(2); % generate complex-gaussian channel with unit power
% error = zeros(1,length(SNR));           % initialize the error
% 
% for i = 1:length(SNR)    
% 
%     % rayleigh fading and AWGN channel porcess
%     rxd = ch.*txd + noise*sigma(i);
%     
%     % ML decoding (find minimum distance)
%     ML =  [   (rxd-(s(1)*ones(1,length(rxd))).*ch).^2;
%               (rxd-(s(2)*ones(1,length(rxd))).*ch).^2;
%               (rxd-(s(3)*ones(1,length(rxd))).*ch).^2;
%               (rxd-(s(4)*ones(1,length(rxd))).*ch).^2];           
%     [ ~, index] = min(ML);               
%     index(index == 1) = s(1);
%     index(index == 2) = s(2);  
%     index(index == 3) = s(3);
%     index(index == 4) = s(4);     
%     
%     % count the error
%     error(i) = size(find(index-txd),2);
%     
% end
% error = error/N;
% 
% M = 4;
% b = sqrt((2*(sin(pi/M))^2)^2.*SNR/2)./sqrt(1 + (2*(sin(pi/M))^2)^2.*SNR/2);
% Pe = ((M-1)/M).*(1-b.*((M-1)/M)^-1/pi.*(pi/2+atan(b*cot(pi/M))));    
% 
% figure(1)
% semilogy(SNR_dB,Pe,'k-o');
% hold on
% semilogy(SNR_dB,error,'r-x');
% grid on
% legend('QPSK Theory','QPSK Simulation');
% axis([min(SNR_dB) max(SNR_dB) 10^-6 10^0])
% xlabel('SNR [dB]');
% ylabel('SER');
clc        %for clearing the command window
close all  %for closing all the window except command window
clear all  %for deleting all the variables from the memory
nPSK=2;    %QPSK
nSymbol=100000;%Number of Input Symbol
nbit=nSymbol*nPSK;%Number of Input Bit
Eb=1;      %Energy Bit
itr=10;    %Number of Itration
BER=1:itr; %Bit Error Rate
%Bit Error Rate Calculation
for SNRdb=1:1:itr   % SNR in dB
    counter=0;  
    SNR=10.^(SNRdb/10);
    No=1/SNR;
    v=(No/Eb)/(2*nPSK);   % Noise Equation
for n=1:1:nSymbol
    u1=rand(1);      %random  first bit generation 
    u2=rand(1);      %random second bit generation
    
    u1=round(u1);    %round first bit to(1 or 0)
    u2=round(u2);    %round second bit to(1 or 0)
    
    %Modulation Process
    if(u1==0 && u2==0)
        real=cosd(0);
        img=sind(0);
 
    elseif(u1==0 && u2==1)
        real=cosd(90);
        img=sind(90);
        
       
     elseif(u1==1 && u2==0)
        real=cosd(180);
        img=sind(180);
            
     elseif(u1==1 && u2==1)
        real=cosd(270);
        img=sind(270);
 
    end
    
   %Transmition Process
    AWGN1=sqrt(v)*randn(1);
    AWGN2=sqrt(v)*randn(1);
    
   %Channel
    realn=real+AWGN1;          
    imgn=img+AWGN2;
    
   %RX
   phin=mod(atan2d(imgn,realn)+360,360);
   
   if((phin>=0&&phin<=45)||(phin>315))
        uu1=0;
        uu2=0;
    elseif(phin>45&&phin<=135)
        uu1=0;
        uu2=1;
    elseif(phin>135&&phin<=225)
        uu1=1;
        uu2=0; 
    elseif(phin>225&&phin<=315)
        uu1=1;
        uu2=1;            
    end
    %Detection Process
    if(u1~=uu1)          %logic according to 8PSK
        counter=counter+1;
    end
    if(u2~=uu2)          %logic according to 8PSK
        counter=counter+1;
    end
end
BER(SNRdb)=(counter/nbit);  %Calculate error/bit
end
SNRdb=1:1:itr;
pe=0.5*erfc(sqrt(10.^(SNRdb/10))); %Theoretical Bit Error Rate
figure(1)%('name','BER_QPSK','numbertitle','off');
semilogy(SNRdb,BER,'--g*','linewidth',1.5,'markersize',8);
% axis([1 itr 10^(-4) 1]);
title(' curve for Bit Error Rate Vs SNRdb for QPSK modulation');
xlabel(' SNRdb(dB)');
ylabel('BER');
grid on;
hold on;
%Plot Bit Error Rate
semilogy(SNRdb,pe,'--bs','linewidth',1.5,'markersize',6);
% axis([1 itr 10^(-4) 1]);
xlabel('SNRdb(dB)');
ylabel('BER');
grid on;
hold on;
legend('simulation','theoretical');