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
NN = 256;								% number of symbols,符号数
tb = 0.5;								% bit time，每比特的持续时间
fs = 16;                                % samples/symbol，采样频率
ebn0db = [1:2:14];						% Eb/N0 vector，信噪比向量
%
% Establish QPSK signals，产生一个QPSK信号
%
x = random_binary(NN,fs)+i*random_binary(NN,fs);   % QPSK signal，QPSK信号
%
% Input powers and delays，输入功率和延时
%
choice = input('1：功率平均，2：功率指数下降，选择 1 或 2 > ');
if choice == 2%问题2，六路的功率按指数式下降（平均每路-2dB）
    p0 = input('Enter P0 > ');
    p1 = p0/1.585;%input('Enter P1 > ');
    p2 = p1/1.585;%input('Enter P2 > ');
    p3 = p2/1.585;%input('Enter P3 > ');
    p4 = p3/1.585;%input('Enter P4 > ');
    p5 = p4/1.585;%input('Enter P5 > ');
else%问题1，六路的功率平均，个人理解即为功率相同
    p0 = 1;%input('Enter P0 > ');
    p1 = 1;%input('Enter P1 > ');
    p2 = 1;%input('Enter P2 > ');
    p3 = 1;%input('Enter P3 > ');
    p4 = 1;%input('Enter P4 > ');
    p5 = 1;%input('Enter P5 > ');
end

delay = 0;%input('Enter tau > ');%flat fading，平坦衰落，延时一律为0
delay0 = 0; delay1 = 0; delay2 = delay;
%
% Set up the Complex Gaussian (Rayleigh) gains，产生复高斯（瑞利）增益
%
gain1 = sqrt(p1)*abs(randn(1,NN) + i*randn(1,NN));
gain2 = sqrt(p2)*abs(randn(1,NN) + i*randn(1,NN));
gain3 = sqrt(p3)*abs(randn(1,NN) + i*randn(1,NN));
gain4 = sqrt(p4)*abs(randn(1,NN) + i*randn(1,NN));
gain5 = sqrt(p5)*abs(randn(1,NN) + i*randn(1,NN));

for k = 1:NN %此处可改为卷积求采样后的结果，不需要循环
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
%通过信道
%这一步就是每条路径与瑞利衰落的增益相乘，没有delay的事
for k=(delay2+1):(NN*fs)
   y2(1,k)= y1(1,k)*sqrt(p0) + ...
             y1(1,k-delay1)*ggain1(1,k)+...
             y1(1,k-delay2)*ggain2(1,k)+...
             y1(1,k)*ggain3(1,k)+...
             y1(1,k)*ggain4(1,k)+...
             y1(1,k)*ggain5(1,k);
end
%
% Matched filter，匹配滤波
%
b = ones(1,fs); b = b/fs; a = 1;
y = filter(b,a,y2);
%
% End of simulation 
%
% Use the semianalytic BER estimator. The following sets 
% up the semi analytic estimator. Find the maximum magnitude 
% of the cross correlation and the corresponding lag.采用半解析的方法计算误码率
%通过互相关计算时延
[cor lags] = vxcorr(x,y);
[cmax nmax] = max(abs(cor));
timelag = lags(nmax);
theta = angle(cor(nmax))
y = y*exp(-i*theta);     								% derotate 
%
% Noise BW calibration，噪声带宽估计
%
hh = impz(b,a); ts = 1/16; nbw = (fs/2)*sum(hh.^2);
%
% Delay the input, and do BER estimation on the last 128 bits. 
% Use middle sample. Make sure the index does not exceed number 
% of input points. Eb should be computed at the receiver input. 
%采样延时估计
index = (10*fs+8:fs:(NN-10)*fs+8);
xx = x(index);
yy = y(index-timelag+1);
[n1 n2] = size(y2); ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;%调整输入端的比特能量
eb = eb/2;
[peideal,pesystem] = qpsk_berest(xx,yy,ebn0db,eb,tb,nbw);%半解析方法计算误码率
figure%画图
semilogy(ebn0db,peideal,'b*-',ebn0db,pesystem,'r+-')
xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
legend('理论值','仿真值')
axis([0 14 10^(-10) 1])
% End of script file.