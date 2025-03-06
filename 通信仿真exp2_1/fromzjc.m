% MATLAB script for exp1
echo on
fs=7;					% ����Ƶ��
ts=1/fs;                % ����ʱ����
N=50;                   % ��������N
t=0:ts:ts*(N-1);        % xs(t)����ʱ���
df=0.01;                % Ƶ�ʷֱ���
x=5*cos(6*pi.*t)+3*sin(8*pi.*t);    %����ʱ�亯��
[X,x0,df1]=fftseq(x,ts,df);			% derive the FFT���Ѿ����ú���NΪ2�ݣ�

X1=X/N;                            		% scaling
f=[0:df1:df1*(length(x0)-1)]-fs/2;   		% FFT����
f1=[-5:0.01:5];                		% ������ʷ�Χ������ͼ��
y=2.5.*sign((dirac(f1-3)+dirac(f1+3)))+1.5.*sign((dirac(f1-4)+dirac(f1+4)));  		
% ���۸���Ҷ�任�Ľ��
%pause % Press akey to see the plot of the Fourier Transform derived analytically

figure(1)
subplot(2,1,1)
plot(f1,abs(y));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived analytically') %����Ƶ��ͼ��
axis([-5 5 -0.1 3]);      % ���÷�Χ
subplot(2,1,2)
plot(f,fftshift(abs(X1)));
xlabel('Frequency')
title('Magnitude-pectrum of x(t) derived numerically')  %�ɲ����źŻָ�Ƶ��
axis([-fs/2 fs/2 -0.1 3]);      % ���÷�Χ

% �ع��ź�
t_r = (0:length(x0)-1)*ts;
x_r = ifft(X1)*N; %��Ƶ��ָ��ź�
t_org = (0:20*length(x0)-1)*(ts/10); % ����ʱ���ָ�ԭ�ź�
x_org = 5*cos(6*pi.*t_org) + 3*sin(8*pi.*t_org);
figure(2);
plot(t_r,x_r,'-r',t_org,x_org,'--b')
title('�ع��ź���ԭ�ź�')
xlabel('t/s')
axis([0 3 -10 10]);
grid on;
legend('�ع�','ԭʼ')
