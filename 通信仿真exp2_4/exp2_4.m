clc
clear
fs=1024;%����Ƶ��Hz
ts=1/fs;%��������						
N=1024;%��������
df = fs/N;%Ƶ�׷ֱ���
%
%������ȷ���Ļ���xd(t),xq(t)
%
t = [-N/2:N/2-1]*ts;%����ʱ��Χ
xd_theory = 6*cos(2*sin(24*pi*t));%xd(t)������ֵ
xq_theory = 6*sin(2*sin(24*pi*t));%xq(t)������ֵ
%��ͼ
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
%FFT����X(f)�ķ��Ⱥ���λ
%
t = [0:N-1]*ts;%����ʱ��Χ
x = 6*cos(240*pi*t+2*sin(24*pi*t));%��ͨ�ź�
X = fft(x,N);%fft�任�õ�X(f)
X1 = X/N;%fft��ķ��ȴ���
X1 = X1(1:N/2+1);%ȡ[0,fs/2]��Ƶ��
X1(2:end-1) = 2*X1(2:end-1);%��ֱ�������ķ�ֵ��fft֮��/(2N)
f=[0:df:df*(length(X1)-1)];%fft���Ӧ��ʵ��Ƶ��
figure%��ͼ
subplot(2,1,1)%X(f)������
plot(f,abs(X1));
xlabel('Frequency')
title('Magnitude-pectrum of X(f)')
axis([0,240,0,4]);
subplot(2,1,2)%X(f)��λ��
plot(f,angle(X1));
xlabel('Frequency')
title('Phase-pectrum of X(f)')
axis([0,240,-4,4]);
%
%����Ч��ͨ�źŵ�Ƶ��X~f
%
f0 = 120;%��Ƶ��ͼ��ȷ����Hz
k = find(f == f0);%�ҵ�f0��Ӧ������λ��
f1 = f-(k*df-1);%��λ���൱��X(f-f0)
figure%��ͼ
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
%��xd��xq
%
%ʱ�򷽷�
% t1 = -0.5:0.001:0.5;
% x = 6*cos(240*pi*t1+2*sin(24*pi*t1));
% z = hilbert(x);
% xl = z.*exp(-j*2*pi*120*t1);
% xd = real(xl);
% xq = -j*(xl-xd);
%Ƶ�򷽷�
d = length(X((k+1):end))-length(X(1:(k-1)));
X2 = 2*[zeros(1,d),X];%���㴦��ʹf=f0λ�ھ������ģ����ں����Գ�����
Xd = (X2 + fliplr(conj(X2)))/2;%Xd(f)=[X~(f)+X~*(-f)]/2
Xq = (X2 - fliplr(conj(X2)))/(2*j);%Xq(f)=[X~(f)-X~*(-f)]/(2*j)

a = (length(Xd)+1)/2;%ȷ��f=f0��λ��
Xd1 = fftshift(Xd(a-512:a+511));%��ȡ��Ч���֣�������fft��N=1024��Ӧ��
Xq1 = fftshift(Xq(a-512:a+511));

t1 =[-length(Xd1)/2:length(Xd1)/2-1]*ts;%�Ƶ���ֵifft���Ӧ��ʱ����
t = [-N/2:N/2-1]*ts;%����ֵ��Ӧ��ʱ����
xd = ifft(Xd1);
xq = ifft(Xq1);%����Ҷ��任

%
%�Ƚ�xd,xq������ֵ�ͼ���ֵ
%
figure
subplot(2,1,1)
plot(t1,xd,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xd_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('����ֵ','����ֵ');
xlabel('time/s');
ylabel('Magnitude');
title('xd(t)');
subplot(2,1,2)
plot(t1,xq,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,xq_theory,'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.3,0.3,-10,10])
legend('����ֵ','����ֵ');
xlabel('time/s');
ylabel('Magnitude');
title('xq(t)');