%源网址:https://zhuanlan.zhihu.com/p/402136509
clc;
close all;
clear all;

%%%%%%%%%%%参数设定%%%%%%%%%%%%%%%%%%%%

bit_rate = 1000;            %比特率
sample = 16;                %每个符号的采样点数
fc = 2000;                  %载波频率
fs = bit_rate*sample;       %采样频率=比特率*每个符号的采样点数
source_number = 352;        %发送信号的长度
rollof_factor = 0.5;        %滚降因子,可调整

%%%%%%%%%%%%%%%%信源%%%%%%%%%%%%%%%%%%

%随机信号
source = randi([0 1],1,source_number);
%给出标志性帧头，方便调试
frame_pre = ones(1,32); %用于捕获和同步
frame_begin = [0 1 1 1 1 1 1 0]; %帧开始的标志
frame_head = [frame_pre frame_begin];  %帧数据
frame_end = [0 1 1 1 1 1 1 0];   %帧结束的标志
%组帧
frame_msg = [frame_head source frame_end];

%%%%%%%%%%%%发射机%%%%%%%%%%%%%%%%%%%%

%双极性转换
bipolar_msg_source = 2*frame_msg-1;   %双极性信号

%pi/4-DQPSK映射
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

% 波形观察
figure(1);
subplot(211);plot(bipolar_msg_source_i);
title('I路时域波形');
subplot(212);plot(bipolar_msg_source_q);
title('Q路时域波形');

%%%%上采样
%I路上采样
bipolar_msg_source_temp_i = [bipolar_msg_source_i',zeros(size(bipolar_msg_source_i,2),sample-1)];
length_x = size(bipolar_msg_source_temp_i,1);
length_y = size(bipolar_msg_source_temp_i,2);
up16_bipolar_msg_source_i = reshape(bipolar_msg_source_temp_i',1,length_x*length_y);

%波形观察
figure(2);
subplot(211);plot(up16_bipolar_msg_source_i);
title('I路上采样时域波形');
subplot(212);plot(abs(fft(up16_bipolar_msg_source_i)));
title('I路上采样频域波形');

%Q路上采样
bipolar_msg_source_temp_q = [bipolar_msg_source_q',zeros(size(bipolar_msg_source_q,2),sample-1)];
length_x = size(bipolar_msg_source_temp_q,1);
length_y = size(bipolar_msg_source_temp_q,2);
up16_bipolar_msg_source_q = reshape(bipolar_msg_source_temp_q',1,length_x*length_y);

%波形观察
figure(3);
subplot(211);plot(up16_bipolar_msg_source_q);
title('Q路上采样时域波形');
subplot(212);plot(abs(fft(up16_bipolar_msg_source_q)));
title('Q路上采样频域波形');
%%%滤波器
%滚降滤波器

rcos_fir = rcosdesign(rollof_factor,6,sample);
% fvtool(rcos_fir,'Analysis','impulse');    %将脉冲响应可视化
%采用滚降滤波器进行滤波
% rcos_msg_source = filter(rcos_fir,1,up16_bipolar_msg_source);
rcos_msg_source_i = conv(up16_bipolar_msg_source_i,rcos_fir);%I路上采样之后的信号
rcos_msg_source_q = conv(up16_bipolar_msg_source_q,rcos_fir);%Q路上采样之后的信号
filter_delay1 = (length(rcos_fir)-1)/2;  %滚降滤波器的延迟时长


%I路波形观察
figure(4);
subplot(211);plot(rcos_msg_source_i(1:1024));
title('I路通过成型滤波器的时域波形');
subplot(212);plot(abs(fft(rcos_msg_source_i)));
title('I路通过成型滤波器的频域波形');

%Q路波形观察
figure(5);
subplot(211);plot(rcos_msg_source_q(1:1024));
title('Q路通过成型滤波器的时域波形');
subplot(212);plot(abs(fft(rcos_msg_source_q)));
title('Q路通过成型滤波器的频域波形');
%%%%%%%%%%%%调制器%%%%%%%%%%%%%%%%%%%%
%%%载波发送
time = 1:length(rcos_msg_source_i);
rcos_msg_source_carrier = rcos_msg_source_i.*cos(2*pi*fc.*time/fs)-rcos_msg_source_q.*sin(2*pi*fc.*time/fs);
%波形观察
figure(6);
subplot(211);plot(rcos_msg_source_carrier(1:1024));
title('载波调制时域波形');
subplot(212);plot(abs(fft(rcos_msg_source_carrier)));
title('载波调制频域波形');

%%%%%%%%%%%%信道%%%%%%%%%%%%%%%%%%%%%%
%设置信噪比
ebn0 = -6:8;
snr = ebn0 - 10*log10(0.5*16);
for i = 1:length(snr)
    %线性高斯白噪声信道
    rcos_msg_source_carrier_addnoise = awgn(rcos_msg_source_carrier,snr(i),'measured');
    
    %%%%%%%%%%%%接收机%%%%%%%%%%%%%%%%%%%%
    %%%%%%载波恢复
    %%%相干解调
    rcos_msg_source_addnoise_i =rcos_msg_source_carrier_addnoise.*cos(2*pi*fc.*time/fs);
    rcos_msg_source_addnoise_q =-(rcos_msg_source_carrier_addnoise.*sin(2*pi*fc.*time/fs));


    %%%%%%%滤波
    %%%%低通滤波
    fir_lp =fir1(128,0.2); %截止频率为0.2*(fs/2) 使用汉明窗设计一个128阶低通带线性相位的FIR滤波器。
    rcos_msg_source_1p_i = conv(fir_lp,rcos_msg_source_addnoise_i);
    rcos_msg_source_1p_q = conv(fir_lp,rcos_msg_source_addnoise_q);
    %延迟64个采样点输出
    filter_delay2 = (length(fir_lp)-1)/2;  %低通滤波器的延迟时长

    %%%%%%匹配滤波
    %生成匹配滤波器
    rcos_fir = rcosdesign(rollof_factor,6,sample);
    %滤波
    rcos_msg_source_MF_i = conv(rcos_fir,rcos_msg_source_1p_i);
    rcos_msg_source_MF_q = conv(rcos_fir,rcos_msg_source_1p_q);
    filter_delay3 = (length(rcos_fir)-1)/2;  %滚降滤波器的延迟时长

    %%%%%最佳采样
    %%%选取最佳采样点
    decision_site = filter_delay1+filter_delay2+filter_delay3; %(96+128+96)/2 =160 三个滤波器的延迟 96 128 96


    %下采样
    rcos_msg_source_MF_option_i = rcos_msg_source_MF_i(decision_site+1:sample:end-decision_site);
    rcos_msg_source_MF_option_q = rcos_msg_source_MF_q(decision_site+1:sample:end-decision_site);
    %涉及到三个滤波器，固含有滤波器延迟累加


   %PI/4QPSK译码
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
    %%%串并转换
    rx_data = zeros(1,2*length(rx_data_decode_pi4_i));
    rx_data(1,2:2:end) = rx_data_decode_pi4_i;
    rx_data(1,1:2:end) = rx_data_decode_pi4_q;



%%%%%%%%%%%%%%%%%   信宿    %%%%%%%%%%%%%%%%%%%%
%%%误码率性能比对
%[err_number,bit_err_ratio]=biterr(x,y)
[err_number(i),bit_err_ratio(i)]=biterr(frame_msg,(rx_data+1)/2);

end 
%%%%%%%%%%%%%%%%%   仿真结果    %%%%%%%%%%%%%%%%%%%%
ber = berawgn(ebn0,'dpsk',4,'nondiff');
figure(7);
semilogy(ebn0,bit_err_ratio,'-*',ebn0,ber,'-+');
xlabel('比特信噪比');
ylabel('误码率');
title('不同信噪比下误码率仿真曲线');
legend('实验曲线','理论曲线');
grid on;