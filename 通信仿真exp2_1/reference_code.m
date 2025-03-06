%% 设置原始信号

t = -0.2 : 0.0005 : 0.2;
N = 1000;
k = -N : N;
W = k * 2000 / N;
origin = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t);% 原始信号为正弦信号
origin_F = origin * exp(-1i * t' * W) * 0.0005;% 傅里叶变换
origin_F = abs(origin_F);% 取正值
figure;
subplot(4, 2, 1); plot(t, origin); title('原信号时域');

subplot(4, 2, 2); plot(W, origin_F); title('原信号频域');

%% %抽样信号

Nsampling = 1/80; % 采样频率

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %采样后的信号

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % 采样后的傅里叶变换

F_80Hz = abs(F_80Hz);

subplot(4, 2, 3); stem(t, f_80Hz); title('80Hz采样信号时域');

subplot(4, 2, 4); plot(W, F_80Hz); title('80Hz采样信号频域');
%% 对原始信号进行121Hz采样率采样

Nsampling = 1/121; % 采样频率

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %采样后的信号

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % 采样后的傅里叶变换

F_80Hz = abs(F_80Hz);

subplot(4, 2, 5); stem(t, f_80Hz); title('121Hz采样信号时域');

subplot(4, 2, 6); plot(W, F_80Hz); title('121Hz采样信号频域');

%% 对原始信号进行150Hz采样率采样

Nsampling = 1/150; % 采样频率

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %采样后的信号

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % 采样后的傅里叶变换

F_80Hz = abs(F_80Hz);

subplot(4, 2, 7); stem(t, f_80Hz); title('150Hz采样信号时域');

subplot(4, 2, 8); plot(W, F_80Hz); title('150Hz采样信号频域');

%% 恢复原始信号

%% 从80Hz采样信号恢复

figure;

n = -100 : 100;

Nsampling = 1/80;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 1); plot(t, f_covery); title('80Hz信号恢复');
% 从121Hz采样信号恢复

Nsampling = 1/121;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 2); plot(t, f_covery); title('121Hz信号恢复');

% 从150Hz采样信号恢复

Nsampling = 1/150;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 3); plot(t, f_covery); title('150Hz信号恢复');