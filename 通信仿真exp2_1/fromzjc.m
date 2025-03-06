% MATLAB script for exp1
echo on
fs=7;					% 采样频率
ts=1/fs;                % 采样时间间隔
N=50;                   % 采样点数N
t=0:ts:ts*(N-1);        % xs(t)采样时间点
df=0.01;                % 频率分辨率
x=5*cos(6*pi.*t)+3*sin(8*pi.*t);    %设置时间函数
[X,x0,df1]=fftseq(x,ts,df);			% derive the FFT（已经设置好了N为2幂）

X1=X/N;                            		% scaling
f=[0:df1:df1*(length(x0)-1)]-fs/2;   		% FFT移轴
f1=[-5:0.01:5];                		% 半采样率范围画理论图像
y=2.5.*sign((dirac(f1-3)+dirac(f1+3)))+1.5.*sign((dirac(f1-4)+dirac(f1+4)));  		
% 理论傅里叶变换的结果
%pause % Press akey to see the plot of the Fourier Transform derived analytically

figure(1)
subplot(2,1,1)
plot(f1,abs(y));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived analytically') %理论频谱图像
axis([-5 5 -0.1 3]);      % 设置范围
subplot(2,1,2)
plot(f,fftshift(abs(X1)));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived numerically')  %由采样信号恢复频谱
axis([-fs/2 fs/2 -0.1 3]);      % 设置范围

% 重构信号
t_r = (0:length(x0)-1)*ts;
x_r = ifft(X1)*N; %从频域恢复信号
t_org = (0:20*length(x0)-1)*(ts/10); % 增加时间点恢复原信号
x_org = 5*cos(6*pi.*t_org) + 3*sin(8*pi.*t_org);
figure(2);
plot(t_r,x_r,'-r',t_org,x_org,'--b')
title('重构信号与原信号')
xlabel('t/s')
axis([0 3 -10 10]);
grid on;
legend('重构','原始')
