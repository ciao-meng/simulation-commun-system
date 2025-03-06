clc
clear
echo on
fs=1024;
ts=1/fs;						% set parameters
df=1;
%
%解析并确定的画出xd(t),xq(t)
%
t = -0.4:ts:0.4;
N = length(t)-1;
xd_theory = 6*cos(2*sin(24*pi*t));
xq_theory = 6*sin(2*sin(24*pi*t));
subplot(2,1,1)
plot(t,xd_theory);
title('xd(t)');
axis([-0.3,0.3,-10,10]);
subplot(2,1,2)
plot(t,xq_theory);
title('xq(t)');
axis([-0.3,0.3,-10,10]);
xlabel('time/s');
ylabel('Magnitude');
%
%FFT画出X(f)的幅度和相位
%
x = 6*cos(240*pi*t+2*sin(24*pi*t));
[X,x,df1]=fftseq(x,ts);
X1=X/fs;
f=[0:df1:df1*(length(X1)-1)]-fs/2;
figure
subplot(2,1,1)
plot(f,fftshift(abs(X1)));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived numerically')
axis([-200,200,0,2]);
subplot(2,1,2)
plot(f,fftshift(angle(X1)));%大雾，不知道为啥长这样
xlabel('Frequency')
title('Phase-pectrum of x(t) derived numerically')
axis([-200,200,-4,4]);
%
%画等效低通信号的频谱X~f
%
f0 = 120;%由频域图像确定，Hz
u = heaviside(f)-heaviside(f-2*f0);
X2 = fftshift(X1);
Xf = 2.*X2.*u;
Xf = circshift(Xf,[0,-round(f0/df1)]);
% Xf = Xf(1,2:end);
% f = f(1,2:end);
figure
subplot(2,1,1)
plot(f,abs(Xf));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived numerically')
axis([-100,100,0,4]);
subplot(2,1,2)
plot(f,angle(Xf));%大雾，不知道为啥长这样
xlabel('Frequency')
title('Phase-pectrum of x(t) derived numerically')
axis([-100,100,-4,4]);
%
%画xd和xq
%
% t1 = -0.5:0.001:0.5;%时域方法
% x = 6*cos(240*pi*t1+2*sin(24*pi*t1));
% z = hilbert(x);
% xl = z.*exp(-j*2*pi*120*t1);
% xd = real(xl);
% xq = -j*(xl-xd);

Xf = [Xf,Xf(1)];%频域方法
Xd = (Xf+fliplr(conj(Xf)))/2;
Xd = Xf(1,1:end-1);
Xd = ifftshift(Xd);
Xd = circshift(Xd,[0,round(f0/df1)]);
[xd,Xd,ts1]=fftseq(Xd,df1,ts);
t1 =[0:ts1:ts1*(length(Xd)-1)]-1/2/df1;

%
%比较xd,xq的理论值和计算值
%
figure
plot(t1,xd,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xd_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('测量值','理论值');
xlabel('time/s');
ylabel('Magnitude');

figure
plot(t1,xq,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xq_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('测量值','理论值');
xlabel('time/s');
ylabel('Magnitude');

