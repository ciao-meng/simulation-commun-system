clc; 
clear;
N = 100;%Samples per signal
ts = 1/N;%Ƶ�ʲ�������
df = 0.001;%ʱ��ֱ���
f0 = 90;%��λ�ز�Ƶ��
f = -f0:ts:f0;%Ƶ�ʷ�Χ
fmin = 90;%����Ƶ����Сֵ
Xfc = 4*[zeros(1,f0*N),ones(1,20*N+1),zeros(1,(f0-20)*N)];%�����ź�X(f)
fdelta = f0-fmin;
Xf = circshift(Xfc,[0,-fdelta*N]);%��λX(f-f0)
Xff = fliplr(Xf);%X(-f)
Xfd = Xf+Xff;%ͬ�����X~d(f)

figure%��X~d(f)��Ƶ��ͼ
plot(f,Xfd,'LineWidth',1);
axis([-50,50,0,10]);
xlabel('Ƶ��/Hz');
ylabel('����');
title(['X~d(f), f0=',num2str(f0),'Hz']);
set(gca,'Xtick',-50:10:50);

[xd,Xfd,df1]=fftseq(Xfd,ts,df);	%����Ҷ��任�����ݸ���Ҷ�任�ĶԳ��ԣ�F[X(t)]=x(-f)
xd = xd/N;%���������Է��ȵ�Ӱ��
t=[0:df1:df1*(length(Xfd)-1)]-N/2; % ʱ�䷶Χ

%x~d(t)����ֵ
if(f0 == 100)
    xd_theory = 160.*sinc(20.*t);
end
if(f0 == 90)
    xd_theory = 160.*sinc(40.*t);
end
if(f0 == 95)
    xd_theory = 120.*sinc(30.*t)+40.*sinc(10.*t);
end

figure%��x~d(t)��ʱ��ͼ
plot(t,ifftshift(abs(xd)),'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(t,abs(xd_theory),'--','Color',[1,0.27,0],'LineWidth',2);
axis([-0.2,0.2,0,200]);
xlabel('ʱ��/s');
ylabel('����');
title(['|x~d(t)|, f0=',num2str(f0),'Hz']);
legend('����ֵ','����ֵ');


