clc
clear
m = 1000;	bits = 2*m;	% number of symbols and bits,符号个数与信息量，log(4)=2
sps = 10;	% samples per symbol，每个符号的采样个数
iphase = 0;	% initial phase，相位初始化
order = 5;	% filter order，滤波器阶数
bw = 0.2;	% normalized filter bandwidth，归一化的滤波器带宽
error = 0;%解码后的符号错误数
delay = 5;%采样延时
%
% initialize vectors，所需向量初始化
%
%发送端
data = zeros(1,bits); d = zeros(1,m); q = zeros(1,m);
dd = zeros(1,m); qq = zeros(1,m); theta = zeros(1,m);
thetaout = zeros(1,sps*m);
%接收端
U = zeros(1,m);V = zeros(1,m);
datafinal = zeros(1,bits);
%
% set direct and quadrature bit streams，得到同相和正交分量比特流
%
data = round(rand(1,bits));%初始信息源（01序列）
dd = data(1:2:bits-1);%奇数为同相分量
qq = data(2:2:bits);%偶数为正交分量
%
% 发送端
%
theta(1) = iphase;% set initial phase，设置初始相位
thetaout(1:sps) = theta(1)*ones(1,sps);%采样后的初始相位
for k=2:m
   if dd(k) == 1%根据表格中的d,q映射相位
      phi_k = (2*qq(k)-1)*pi/4;
   else
      phi_k = (2*qq(k)-1)*3*pi/4;
   end   
   theta(k) = phi_k + theta(k-1);%差分相位
   for i=1:sps%相位采样
      j = (k-1)*sps+i;
      thetaout(j) = theta(k);
   end
end
d = cos(thetaout);
q = sin(thetaout);%信号的低通复包络形式
[b,a] = butter(order,bw);%产生一个butterworth低通滤波器，使数字信号变成利于
                         %信道传输的形式
df = filter(b,a,d);
qf = filter(b,a,q);%同相和正交分量分别过滤波器


Eb = 0.75;%传输信号的平均能量 /bit
EbNodB = -6:8;% vector of Eb/No (dB) values，信噪比的向量
for i = 1:length(EbNodB)%计算不同信噪比下的误码率
    %接收端采样后，同相正交分量的初始化
    W = zeros(1,m);
    Z = zeros(1,m);
    
    z = 10.^(EbNodB(i)/10);			% convert to linear scale，将dB信噪比转化为线性值
    NoiseSigma = sqrt((sps*Eb)/(2*z));   % scale noise level，根据信噪比调整噪声功率
    
    %
    % Generate channel noise.产生信道噪声
    %
    NoiseSamples = NoiseSigma*randn(size(df));
    %
    % Add signal and noise.信号加噪
    %
    Rxdf = df + NoiseSamples;
    Rxqf = qf + NoiseSamples;       
    %
    % Pass Received signal through matched filter.通过接收端的累加滤波器
    %
    % dfi = d;
    % qfi = q;%调试使用
    BRx = ones(1,sps);
    ARx=1;    % matched filter parameters，滤波器参数设置
    dfi = filter(BRx,ARx,Rxdf);
    qfi = filter(BRx,ARx,Rxqf);    
    %
    % Sample matched filter output every SamplesPerSymbol samples,
    % compare to transmitted bit, and count errors.接收端取样
    %
    for k=1:m
        a = k*sps+delay;%从k=1开始，已经跳过了初始相位进行采样
        if (a < length(dfi))
            W(k) = dfi(a);
            Z(k) = qfi(a);
        end
    end
    %
    %解码
    %
    W = [1,W];%增加初使相位的同相表示cos(0)
    Z = [0,Z];%增加初始相位的正交表示sin(0)
    for k=1:m
        U(k) = W(k+1)*W(k)+Z(k+1)*Z(k);
        I(k) = (sign(U(k))+1)/2;
        V(k) = Z(k+1)*W(k)-W(k+1)*Z(k);
        Q(k) = (sign(V(k))+1)/2;
        datafinal(2*k-1) = I(k);
        datafinal(2*k) = Q(k);
    end

    error(i) = sum(I ~= dd)+sum(Q ~= qq);%统计误差数
    BER(i) = error(i)/bits;%实际误码率
    ber(i) = berawgn(EbNodB(i),'dpsk',4,'nondiff');%理论误码率，不是真实的
                                                   %用DQPSK作参考
end
figure(4)%画误码率曲线图
semilogy(EbNodB,BER,'-*',EbNodB,ber,'-+');
xlabel('比特信噪比');
ylabel('误码率');
title('不同信噪比下误码率仿真曲线');
legend('实验曲线','理论曲线');
grid on;
%
%接收端的后处理
%相当于以接收端的结果作为发送信号，进行了一遍发送端的操作，有点冗余可以优化
%
ddr = datafinal(1:2:bits-1);
qqr = datafinal(2:2:bits);
%
% main programs
%
thetar(1) = iphase;						% set initial phase
thetaoutr(1:sps) = thetar(1)*ones(1,sps);
for k=2:m
   if ddr(k) == 1
      phi_kr = (2*qqr(k)-1)*pi/4;
   else
      phi_kr = (2*qqr(k)-1)*3*pi/4;
   end   
   thetar(k) = phi_kr + thetar(k-1);
   for i=1:sps
      j = (k-1)*sps+i;
      thetaoutr(j) = thetar(k);
   end
end
dr = cos(thetaoutr);
qr = sin(thetaoutr);

%
% postprocessor for plotting，操作框
%
while 1                          % test exit counter
list = {'pi/4 QPSK Receiver Signal Constellation',...
        'pi/4 QPSK Reciever Eye Diagram',...
        'Comparison plot of Direct and Quadrature Signals',...
        'Exit'};
[k,tf] = listdlg('PromptString','pi/4 QPSK Plot Options',...
                           'SelectionMode','single',...
                           'ListString',list);
    if tf == 1
        if k == 1
                sigcon(dr,qr)             	% plot signal con. 
                pause
        elseif k ==2
                dqeye(dr,qr,4*sps)        	% plot eye diagram
                pause
        elseif k == 3
                numbsym = 50;           	% number of symbols plotted
                dtr = dr(1:numbsym*sps);  	% truncate d vector
                qtr = qr(1:numbsym*sps);  	% truncate q vector
                dt = d(1:numbsym*sps);  	% truncate d vector
                qt = q(1:numbsym*sps);  	% truncate q vector
                dqplotnew(dtr,qtr,dt,qt)          	    % plot truncated d and q signals
                pause
        elseif k == 4
                break;                 	% set exit counter to exit value
        end
    end
end
% End of script file.