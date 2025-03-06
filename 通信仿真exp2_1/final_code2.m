%% ����ԭʼ�ź�
t = -6 : 0.005 : 6;%�����źŵ�ʱ��Χ
N = 10000;
k = -N : N;
W = k * 200 / N;%�����źŵ�Ƶ��Χ
origin = 3*sin(2 * pi * 4 * t) + 5*cos(2 * pi * 3 * t);% ԭʼ�ź�Ϊ�����ź�
origin_F = origin * exp(-1i * t' * W) / length(t);% ����Ҷ�任
origin_F = abs(origin_F);% ȡ��ֵ

figure;
subplot(2, 1, 1); plot(t, origin); title('ԭ�ź�ʱ��');
subplot(2, 1, 2); plot(W/(2*pi), origin_F); title('ԭ�ź�Ƶ��');
axis([-10,10,min(origin_F),max(origin_F)]);
%% %�����ź�

Nsampling = 1/7; % ����Ƶ��
ts = -6 : Nsampling : 6;%ʱ��Χ
f_10Hz = 3*sin(2 * pi * 4 * ts) + 5*cos(2 * pi * 3 * ts); %��������ź�
F_10Hz = f_10Hz * exp(-1i * ts' * W) / length(ts); % ������ĸ���Ҷ�任
F_10Hz = abs(F_10Hz);%ȡ��ֵ

figure;
subplot(2, 1, 1); stem(ts, f_10Hz); title('10Hz�����ź�ʱ��');
subplot(2, 1, 2); plot(W/(2*pi), F_10Hz); title('7Hz�����ź�Ƶ��');

%% ��10Hz�����źŻָ�
% n = -100 : 100;
% 
% n_sam = n * Nsampling;
% 
% f_uncovery = 3*sin(2 * pi * 4 * n_sam) + 5*cos(2 * pi * 3 * n_sam);
f_uncovery = f_10Hz;
f_covery = f_uncovery * sinc((1/Nsampling) * (ones(length(ts), 1) * t - ts' * ones(1, length(t))));

figure;
subplot(2, 1, 1); plot(t, origin); title('ԭ�ź�ʱ��');
subplot(2, 1, 2); plot(t, f_covery); title('7Hz�źŻָ�');
