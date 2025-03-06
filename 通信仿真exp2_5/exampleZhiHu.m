%Դ��ַ:https://zhuanlan.zhihu.com/p/402136509
clc;
close all;
clear all;

%%%%%%%%%%%�����趨%%%%%%%%%%%%%%%%%%%%

bit_rate = 1000;            %������
sample = 16;                %ÿ�����ŵĲ�������
fc = 2000;                  %�ز�Ƶ��
fs = bit_rate*sample;       %����Ƶ��=������*ÿ�����ŵĲ�������
source_number = 352;        %�����źŵĳ���
rollof_factor = 0.5;        %��������,�ɵ���

%%%%%%%%%%%%%%%%��Դ%%%%%%%%%%%%%%%%%%

%����ź�
source = randi([0 1],1,source_number);
%������־��֡ͷ���������
frame_pre = ones(1,32); %���ڲ����ͬ��
frame_begin = [0 1 1 1 1 1 1 0]; %֡��ʼ�ı�־
frame_head = [frame_pre frame_begin];  %֡����
frame_end = [0 1 1 1 1 1 1 0];   %֡�����ı�־
%��֡
frame_msg = [frame_head source frame_end];

%%%%%%%%%%%%�����%%%%%%%%%%%%%%%%%%%%

%˫����ת��
bipolar_msg_source = 2*frame_msg-1;   %˫�����ź�

%pi/4-DQPSKӳ��
bipolar_msg_source_i = bipolar_msg_source(2:2:end);
bipolar_msg_source_q = bipolar_msg_source(1:2:end);

xk=ones(1,length(bipolar_msg_source_i)+1);
yk=ones(1,length(bipolar_msg_source_i)+1);

for i=2:length(bipolar_msg_source_i)+1
    if bipolar_msg_source_i(i-1)==1 && bipolar_msg_source_q(i-1)==1
        xk(i)=xk(i-1)*cos(pi/4)-yk(i-1)*sin(pi/4);
        yk(i)=yk(i-1)*cos(pi/4)+xk(i-1)*sin(pi/4);
    elseif bipolar_msg_source_i(i-1)==1 && bipolar_msg_source_q(i-1)==-1
        xk(i)=xk(i-1)*cos(-pi/4)-yk(i-1)*sin(-pi/4);
        yk(i)=yk(i-1)*cos(-pi/4)+xk(i-1)*sin(-pi/4);
    elseif bipolar_msg_source_i(i-1)==-1 && bipolar_msg_source_q(i-1)==1
        xk(i)=xk(i-1)*cos(3*pi/4)-yk(i-1)*sin(3*pi/4);
        yk(i)=yk(i-1)*cos(3*pi/4)+xk(i-1)*sin(3*pi/4);
    elseif bipolar_msg_source_i(i-1)==-1 && bipolar_msg_source_q(i-1)==-1 
        xk(i)=xk(i-1)*cos(-3*pi/4)-yk(i-1)*sin(-3*pi/4);
        yk(i)=yk(i-1)*cos(-3*pi/4)+xk(i-1)*sin(-3*pi/4);
    end
end

bipolar_msg_source_i = xk(1,2:end);
bipolar_msg_source_q = yk(1,2:end);

% ���ι۲�
figure(1);
subplot(211);plot(bipolar_msg_source_i);
title('I·ʱ����');
subplot(212);plot(bipolar_msg_source_q);
title('Q·ʱ����');

%%%%�ϲ���
%I·�ϲ���
bipolar_msg_source_temp_i = [bipolar_msg_source_i',zeros(size(bipolar_msg_source_i,2),sample-1)];
length_x = size(bipolar_msg_source_temp_i,1);
length_y = size(bipolar_msg_source_temp_i,2);
up16_bipolar_msg_source_i = reshape(bipolar_msg_source_temp_i',1,length_x*length_y);

%���ι۲�
figure(2);
subplot(211);plot(up16_bipolar_msg_source_i);
title('I·�ϲ���ʱ����');
subplot(212);plot(abs(fft(up16_bipolar_msg_source_i)));
title('I·�ϲ���Ƶ����');

%Q·�ϲ���
bipolar_msg_source_temp_q = [bipolar_msg_source_q',zeros(size(bipolar_msg_source_q,2),sample-1)];
length_x = size(bipolar_msg_source_temp_q,1);
length_y = size(bipolar_msg_source_temp_q,2);
up16_bipolar_msg_source_q = reshape(bipolar_msg_source_temp_q',1,length_x*length_y);

%���ι۲�
figure(3);
subplot(211);plot(up16_bipolar_msg_source_q);
title('Q·�ϲ���ʱ����');
subplot(212);plot(abs(fft(up16_bipolar_msg_source_q)));
title('Q·�ϲ���Ƶ����');
%%%�˲���
%�����˲���

rcos_fir = rcosdesign(rollof_factor,6,sample);
% fvtool(rcos_fir,'Analysis','impulse');    %��������Ӧ���ӻ�
%���ù����˲��������˲�
% rcos_msg_source = filter(rcos_fir,1,up16_bipolar_msg_source);
rcos_msg_source_i = conv(up16_bipolar_msg_source_i,rcos_fir);%I·�ϲ���֮����ź�
rcos_msg_source_q = conv(up16_bipolar_msg_source_q,rcos_fir);%Q·�ϲ���֮����ź�
filter_delay1 = (length(rcos_fir)-1)/2;  %�����˲������ӳ�ʱ��


%I·���ι۲�
figure(4);
subplot(211);plot(rcos_msg_source_i(1:1024));
title('I·ͨ�������˲�����ʱ����');
subplot(212);plot(abs(fft(rcos_msg_source_i)));
title('I·ͨ�������˲�����Ƶ����');

%Q·���ι۲�
figure(5);
subplot(211);plot(rcos_msg_source_q(1:1024));
title('Q·ͨ�������˲�����ʱ����');
subplot(212);plot(abs(fft(rcos_msg_source_q)));
title('Q·ͨ�������˲�����Ƶ����');
%%%%%%%%%%%%������%%%%%%%%%%%%%%%%%%%%
%%%�ز�����
time = 1:length(rcos_msg_source_i);
rcos_msg_source_carrier = rcos_msg_source_i.*cos(2*pi*fc.*time/fs)-rcos_msg_source_q.*sin(2*pi*fc.*time/fs);
%���ι۲�
figure(6);
subplot(211);plot(rcos_msg_source_carrier(1:1024));
title('�ز�����ʱ����');
subplot(212);plot(abs(fft(rcos_msg_source_carrier)));
title('�ز�����Ƶ����');

%%%%%%%%%%%%�ŵ�%%%%%%%%%%%%%%%%%%%%%%
%���������
ebn0 = -6:8;
snr = ebn0 - 10*log10(0.5*16);
for i = 1:length(snr)
    %���Ը�˹�������ŵ�
    rcos_msg_source_carrier_addnoise = awgn(rcos_msg_source_carrier,snr(i),'measured');
    
    %%%%%%%%%%%%���ջ�%%%%%%%%%%%%%%%%%%%%
    %%%%%%�ز��ָ�
    %%%��ɽ��
    rcos_msg_source_addnoise_i =rcos_msg_source_carrier_addnoise.*cos(2*pi*fc.*time/fs);
    rcos_msg_source_addnoise_q =-(rcos_msg_source_carrier_addnoise.*sin(2*pi*fc.*time/fs));


    %%%%%%%�˲�
    %%%%��ͨ�˲�
    fir_lp =fir1(128,0.2); %��ֹƵ��Ϊ0.2*(fs/2) ʹ�ú��������һ��128�׵�ͨ��������λ��FIR�˲�����
    rcos_msg_source_1p_i = conv(fir_lp,rcos_msg_source_addnoise_i);
    rcos_msg_source_1p_q = conv(fir_lp,rcos_msg_source_addnoise_q);
    %�ӳ�64�����������
    filter_delay2 = (length(fir_lp)-1)/2;  %��ͨ�˲������ӳ�ʱ��

    %%%%%%ƥ���˲�
    %����ƥ���˲���
    rcos_fir = rcosdesign(rollof_factor,6,sample);
    %�˲�
    rcos_msg_source_MF_i = conv(rcos_fir,rcos_msg_source_1p_i);
    rcos_msg_source_MF_q = conv(rcos_fir,rcos_msg_source_1p_q);
    filter_delay3 = (length(rcos_fir)-1)/2;  %�����˲������ӳ�ʱ��

    %%%%%��Ѳ���
    %%%ѡȡ��Ѳ�����
    decision_site = filter_delay1+filter_delay2+filter_delay3; %(96+128+96)/2 =160 �����˲������ӳ� 96 128 96


    %�²���
    rcos_msg_source_MF_option_i = rcos_msg_source_MF_i(decision_site+1:sample:end-decision_site);
    rcos_msg_source_MF_option_q = rcos_msg_source_MF_q(decision_site+1:sample:end-decision_site);
    %�漰�������˲������̺����˲����ӳ��ۼ�


   %PI/4QPSK����
   rx_data_decode_pi4_i = zeros(1,length(rcos_msg_source_MF_option_i));
   rx_data_decode_pi4_q = zeros(1,length(rcos_msg_source_MF_option_i));
   rx_data_decode_pi4_i(1) = 1*rcos_msg_source_MF_option_i(1)+rcos_msg_source_MF_option_q(1)*1;
   rx_data_decode_pi4_q(1) = rcos_msg_source_MF_option_q(1)*1- rcos_msg_source_MF_option_i(1)*1;
   for m = 2:length(rcos_msg_source_MF_option_i)
       rx_data_decode_pi4_i(m) = rcos_msg_source_MF_option_i(m)*rcos_msg_source_MF_option_i(m-1)+rcos_msg_source_MF_option_q(m)*rcos_msg_source_MF_option_q(m-1);
       rx_data_decode_pi4_q(m) = rcos_msg_source_MF_option_q(m)*rcos_msg_source_MF_option_i(m-1)-rcos_msg_source_MF_option_i(m)*rcos_msg_source_MF_option_q(m-1);
   end
    

    for j = 1:length(rx_data_decode_pi4_i)
        if(rx_data_decode_pi4_i(j)<0)
            rx_data_decode_pi4_i(j)=-1;
        else
            rx_data_decode_pi4_i(j)=1;
        end
    end
    for k = 1:length(rx_data_decode_pi4_q)
        if(rx_data_decode_pi4_q(k)<0)
            rx_data_decode_pi4_q(k)=-1;
        else
            rx_data_decode_pi4_q(k)=1;
        end
    end
    %%%����ת��
    rx_data = zeros(1,2*length(rx_data_decode_pi4_i));
    rx_data(1,2:2:end) = rx_data_decode_pi4_i;
    rx_data(1,1:2:end) = rx_data_decode_pi4_q;



%%%%%%%%%%%%%%%%%   ����    %%%%%%%%%%%%%%%%%%%%
%%%���������ܱȶ�
%[err_number,bit_err_ratio]=biterr(x,y)
[err_number(i),bit_err_ratio(i)]=biterr(frame_msg,(rx_data+1)/2);

end 
%%%%%%%%%%%%%%%%%   ������    %%%%%%%%%%%%%%%%%%%%
ber = berawgn(ebn0,'dpsk',4,'nondiff');
figure(7);
semilogy(ebn0,bit_err_ratio,'-*',ebn0,ber,'-+');
xlabel('���������');
ylabel('������');
title('��ͬ������������ʷ�������');
legend('ʵ������','��������');
grid on;