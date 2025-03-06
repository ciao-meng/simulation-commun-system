clc
clear
fs=1024;%采样频率Hz
ts=1/fs;%采样周期						
N=1024;%采样点数
df = fs/N;%频谱分辨率
%
%解析并确定的画出xd(t),xq(t)
%
t = [-N/2:N/2-1]*ts;%设置时域范围
xd_theory = 6*cos(2*sin(24*pi*t));%xd(t)的理论值
xq_theory = 6*sin(2*sin(24*pi*t));%xq(t)的理论值
%画图
subplot(2,1,1)
plot(t,xd_theory);
title('xd(t)');
axis([-0.3,0.3,-10,10]);
xlabel('time/s');
ylabel('Magnitude');
subplot(2,1,2)
plot(t,xq_theory);
title('xq(t)');
axis([-0.3,0.3,-10,10]);
xlabel('time/s');
ylabel('Magnitude');
%
%FFT画出X(f)的幅度和相位
%
t = [0:N-1]*ts;%设置时域范围
x = 6*cos(240*pi*t+2*sin(24*pi*t));%带通信号
X = fft(x,N);%fft变换得到X(f)
X1 = X/N;%fft后的幅度处理
X1 = X1(1:N/2+1);%取[0,fs/2]的频谱
X1(2:end-1) = 2*X1(2:end-1);%非直流分量的幅值在fft之后/(2N)
f=[0:df:df*(length(X1)-1)];%fft后对应的实际频率
figure%画图
subplot(2,1,1)%X(f)幅度谱
plot(f,abs(X1));
xlabel('Frequency')
title('Magnitude-pectrum of X(f)')
axis([0,240,0,4]);
subplot(2,1,2)%X(f)相位谱
plot(f,angle(X1));
xlabel('Frequency')
title('Phase-pectrum of X(f)')
axis([0,240,-4,4]);
%
%画等效低通信号的频谱X~f
%
f0 = 120;%由频域图像确定，Hz
k = find(f == f0);%找到f0对应的数组位置
f1 = f-(k*df-1);%移位，相当于X(f-f0)
figure%画图
subplot(2,1,1)
plot(f1,2*abs(X1));%X~(f)=2*X(f-f0)U(f-f0)
xlabel('Frequency')
title('Magnitude-pectrum of X~(f)')
axis([-100,100,0,8]);
subplot(2,1,2)
plot(f1,angle(X1));
xlabel('Frequency')
title('Phase-pectrum of X~(f)')
axis([-100,100,-4,4]);
%
%画xd和xq
%
%时域方法
% t1 = -0.5:0.001:0.5;
% x = 6*cos(240*pi*t1+2*sin(24*pi*t1));
% z = hilbert(x);
% xl = z.*exp(-j*2*pi*120*t1);
% xd = real(xl);
% xq = -j*(xl-xd);
%频域方法
d = length(X((k+1):end))-length(X(1:(k-1)));
X2 = 2*[zeros(1,d),X];%补零处理，使f=f0位于矩阵中心，便于后续对称运算
Xd = (X2 + fliplr(conj(X2)))/2;%Xd(f)=[X~(f)+X~*(-f)]/2
Xq = (X2 - fliplr(conj(X2)))/(2*j);%Xq(f)=[X~(f)-X~*(-f)]/(2*j)

a = (length(Xd)+1)/2;%确定f=f0的位置
Xd1 = fftshift(Xd(a-512:a+511));%截取有效部分（与理论fft的N=1024对应）
Xq1 = fftshift(Xq(a-512:a+511));

t1 =[-length(Xd1)/2:length(Xd1)/2-1]*ts;%推导的值ifft后对应的时域轴
t = [-N/2:N/2-1]*ts;%理论值对应的时域轴
xd = ifft(Xd1);
xq = ifft(Xq1);%傅里叶逆变换

%
%比较xd,xq的理论值和计算值
%
figure
subplot(2,1,1)
plot(t1,xd,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xd_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('测量值','理论值');
xlabel('time/s');
ylabel('Magnitude');
title('xd(t)');
subplot(2,1,2)
plot(t1,xq,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xq_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('测量值','理论值');
xlabel('time/s');
ylabel('Magnitude');
title('xq(t)');