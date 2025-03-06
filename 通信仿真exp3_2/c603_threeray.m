% File: c14_threeray.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
% Default parameters
% 
clc
clear
NN = 256;								% number of symbols,������
tb = 0.5;								% bit time��ÿ���صĳ���ʱ��
fs = 16;                                % samples/symbol������Ƶ��
ebn0db = [1:2:14];						% Eb/N0 vector�����������
%
% Establish QPSK signals������һ��QPSK�ź�
%
x = random_binary(NN,fs)+i*random_binary(NN,fs);   % QPSK signal��QPSK�ź�
%
% Input powers and delays�����빦�ʺ���ʱ
%
choice = input('1������ƽ����2������ָ���½���ѡ�� 1 �� 2 > ');
if choice == 2%����2����·�Ĺ��ʰ�ָ��ʽ�½���ƽ��ÿ·-2dB��
    p0 = input('Enter P0 > ');
    p1 = p0/1.585;%input('Enter P1 > ');
    p2 = p1/1.585;%input('Enter P2 > ');
    p3 = p2/1.585;%input('Enter P3 > ');
    p4 = p3/1.585;%input('Enter P4 > ');
    p5 = p4/1.585;%input('Enter P5 > ');
else%����1����·�Ĺ���ƽ����������⼴Ϊ������ͬ
    p0 = 1;%input('Enter P0 > ');
    p1 = 1;%input('Enter P1 > ');
    p2 = 1;%input('Enter P2 > ');
    p3 = 1;%input('Enter P3 > ');
    p4 = 1;%input('Enter P4 > ');
    p5 = 1;%input('Enter P5 > ');
end

delay = 0;%input('Enter tau > ');%flat fading��ƽ̹˥�䣬��ʱһ��Ϊ0
delay0 = 0; delay1 = 0; delay2 = delay;
%
% Set up the Complex Gaussian (Rayleigh) gains����������˹������������
%
gain1 = sqrt(p1)*abs(randn(1,NN) + i*randn(1,NN));
gain2 = sqrt(p2)*abs(randn(1,NN) + i*randn(1,NN));
gain3 = sqrt(p3)*abs(randn(1,NN) + i*randn(1,NN));
gain4 = sqrt(p4)*abs(randn(1,NN) + i*randn(1,NN));
gain5 = sqrt(p5)*abs(randn(1,NN) + i*randn(1,NN));

for k = 1:NN %�˴��ɸ�Ϊ����������Ľ��������Ҫѭ��
   for kk=1:fs
      index=(k-1)*fs+kk;
      ggain1(1,index)=gain1(1,k);
      ggain2(1,index)=gain2(1,k);
      ggain3(1,index)=gain3(1,k);
      ggain4(1,index)=gain4(1,k);
      ggain5(1,index)=gain5(1,k);
   end
end
y1 = x;
%ͨ���ŵ�
%��һ������ÿ��·��������˥���������ˣ�û��delay����
for k=(delay2+1):(NN*fs)
   y2(1,k)= y1(1,k)*sqrt(p0) + ...
             y1(1,k-delay1)*ggain1(1,k)+...
             y1(1,k-delay2)*ggain2(1,k)+...
             y1(1,k)*ggain3(1,k)+...
             y1(1,k)*ggain4(1,k)+...
             y1(1,k)*ggain5(1,k);
end
%
% Matched filter��ƥ���˲�
%
b = ones(1,fs); b = b/fs; a = 1;
y = filter(b,a,y2);
%
% End of simulation 
%
% Use the semianalytic BER estimator. The following sets 
% up the semi analytic estimator. Find the maximum magnitude 
% of the cross correlation and the corresponding lag.���ð�����ķ�������������
%ͨ������ؼ���ʱ��
[cor lags] = vxcorr(x,y);
[cmax nmax] = max(abs(cor));
timelag = lags(nmax);
theta = angle(cor(nmax))
y = y*exp(-i*theta);     								% derotate 
%
% Noise BW calibration�������������
%
hh = impz(b,a); ts = 1/16; nbw = (fs/2)*sum(hh.^2);
%
% Delay the input, and do BER estimation on the last 128 bits. 
% Use middle sample. Make sure the index does not exceed number 
% of input points. Eb should be computed at the receiver input. 
%������ʱ����
index = (10*fs+8:fs:(NN-10)*fs+8);
xx = x(index);
yy = y(index-timelag+1);
[n1 n2] = size(y2); ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;%��������˵ı�������
eb = eb/2;
[peideal,pesystem] = qpsk_berest(xx,yy,ebn0db,eb,tb,nbw);%�������������������
figure%��ͼ
semilogy(ebn0db,peideal,'b*-',ebn0db,pesystem,'r+-')
xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
legend('����ֵ','����ֵ')
axis([0 14 10^(-10) 1])
% End of script file.