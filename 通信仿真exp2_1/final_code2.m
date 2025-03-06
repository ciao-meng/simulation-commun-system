%% 设置原始信号
t = -6 : 0.005 : 6;%设置信号的时域范围
N = 10000;
k = -N : N;
W = k * 200 / N;%设置信号的频域范围
origin = 3*sin(2 * pi * 4 * t) + 5*cos(2 * pi * 3 * t);% 原始信号为正弦信号
origin_F = origin * exp(-1i * t' * W) / length(t);% 傅里叶变换
origin_F = abs(origin_F);% 取正值

figure;
subplot(2, 1, 1); plot(t, origin); title('原信号时域');
subplot(2, 1, 2); plot(W/(2*pi), origin_F); title('原信号频域');
axis([-10,10,min(origin_F),max(origin_F)]);
%% %抽样信号

Nsampling = 1/7; % 采样频率
ts = -6 : Nsampling : 6;%时域范围
f_10Hz = 3*sin(2 * pi * 4 * ts) + 5*cos(2 * pi * 3 * ts); %采样后的信号
F_10Hz = f_10Hz * exp(-1i * ts' * W) / length(ts); % 采样后的傅里叶变换
F_10Hz = abs(F_10Hz);%取正值

figure;
subplot(2, 1, 1); stem(ts, f_10Hz); title('10Hz采样信号时域');
subplot(2, 1, 2); plot(W/(2*pi), F_10Hz); title('7Hz采样信号频域');

%% 从10Hz采样信号恢复
% n = -100 : 100;
% 
% n_sam = n * Nsampling;
% 
% f_uncovery = 3*sin(2 * pi * 4 * n_sam) + 5*cos(2 * pi * 3 * n_sam);
f_uncovery = f_10Hz;
f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(ts), 1) * t - ts' * ones(1, length(t))));

figure;
subplot(2, 1, 1); plot(t, origin); title('原信号时域');
subplot(2, 1, 2); plot(t, f_covery); title('7Hz信号恢复');
