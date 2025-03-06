clc; 
clear;
N = 100;%Samples per signal
ts = 1/N;%频率采样周期
df = 0.001;%时域分辨率
f0 = 90;%移位载波频率
f = -f0:ts:f0;%频率范围
fmin = 90;%带宽频率最小值
Xfc = 4*[zeros(1,f0*N),ones(1,20*N+1),zeros(1,(f0-20)*N)];%带宽信号X(f)
fdelta = f0-fmin;
Xf = circshift(Xfc,[0,-fdelta*N]);%移位X(f-f0)
Xff = fliplr(Xf);%X(-f)
Xfd = Xf+Xff;%同相分量X~d(f)

figure%画X~d(f)的频谱图
plot(f,Xfd,'LineWidth',1);
axis([-50,50,0,10]);
xlabel('频率/Hz');
ylabel('幅度');
title(['X~d(f), f0=',num2str(f0),'Hz']);
set(gca,'Xtick',-50:10:50);

[xd,Xfd,df1]=fftseq(Xfd,ts,df);	%傅里叶逆变换，根据傅里叶变换的对称性，F[X(t)]=x(-f)
xd = xd/N;%消除采样对幅度的影响
t=[0:df1:df1*(length(Xfd)-1)]-N/2; % 时间范围

%x~d(t)理论值
if(f0 == 100)
    xd_theory = 160.*sinc(20.*t);
end
if(f0 == 90)
    xd_theory = 160.*sinc(40.*t);
end
if(f0 == 95)
    xd_theory = 120.*sinc(30.*t)+40.*sinc(10.*t);
end

figure%画x~d(t)的时域图
plot(t,ifftshift(abs(xd)),'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,abs(xd_theory),'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.2,0.2,0,200]);
xlabel('时间/s');
ylabel('幅度');
title(['|x~d(t)|, f0=',num2str(f0),'Hz']);
legend('测量值','理论值');


