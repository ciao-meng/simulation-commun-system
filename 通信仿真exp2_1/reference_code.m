%% ����ԭʼ�ź�

t = -0.2 : 0.0005 : 0.2;
N = 1000;
k = -N : N;
W = k * 2000 / N;
origin = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t);% ԭʼ�ź�Ϊ�����ź�
origin_F = origin * exp(-1i * t' * W) * 0.0005;% ����Ҷ�任
origin_F = abs(origin_F);% ȡ��ֵ
figure;
subplot(4, 2, 1); plot(t, origin); title('ԭ�ź�ʱ��');

subplot(4, 2, 2); plot(W, origin_F); title('ԭ�ź�Ƶ��');

%% %�����ź�

Nsampling = 1/80; % ����Ƶ��

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %��������ź�

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % ������ĸ���Ҷ�任

F_80Hz = abs(F_80Hz);

subplot(4, 2, 3); stem(t, f_80Hz); title('80Hz�����ź�ʱ��');

subplot(4, 2, 4); plot(W, F_80Hz); title('80Hz�����ź�Ƶ��');
%% ��ԭʼ�źŽ���121Hz�����ʲ���

Nsampling = 1/121; % ����Ƶ��

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %��������ź�

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % ������ĸ���Ҷ�任

F_80Hz = abs(F_80Hz);

subplot(4, 2, 5); stem(t, f_80Hz); title('121Hz�����ź�ʱ��');

subplot(4, 2, 6); plot(W, F_80Hz); title('121Hz�����ź�Ƶ��');

%% ��ԭʼ�źŽ���150Hz�����ʲ���

Nsampling = 1/150; % ����Ƶ��

t = -0.2 : Nsampling : 0.2;

f_80Hz = sin(2 * pi * 60 * t) + cos(2 * pi * 25 * t) + sin(2 * pi * 30 * t); %��������ź�

F_80Hz = f_80Hz * exp(-1i * t' * W) * Nsampling; % ������ĸ���Ҷ�任

F_80Hz = abs(F_80Hz);

subplot(4, 2, 7); stem(t, f_80Hz); title('150Hz�����ź�ʱ��');

subplot(4, 2, 8); plot(W, F_80Hz); title('150Hz�����ź�Ƶ��');

%% �ָ�ԭʼ�ź�

%% ��80Hz�����źŻָ�

figure;

n = -100 : 100;

Nsampling = 1/80;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 1); plot(t, f_covery); title('80Hz�źŻָ�');
% ��121Hz�����źŻָ�

Nsampling = 1/121;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 2); plot(t, f_covery); title('121Hz�źŻָ�');

% ��150Hz�����źŻָ�

Nsampling = 1/150;

n_sam = n * Nsampling;

f_uncovery = sin(2 * pi * 60 * n_sam) + cos(2 * pi * 25 * n_sam) + sin(2 * pi * 30 * n_sam);

t = -0.2 : 0.0005 : 0.2;

f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(n_sam), 1) * t - n_sam' * ones(1, length(t))));

subplot(3, 1, 3); plot(t, f_covery); title('150Hz�źŻָ�');