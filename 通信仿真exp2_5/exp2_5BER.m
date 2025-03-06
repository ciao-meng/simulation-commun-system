clc
clear
m = 1000;	bits = 2*m;	% number of symbols and bits,���Ÿ�������Ϣ����log(4)=2
sps = 10;	% samples per symbol��ÿ�����ŵĲ�������
iphase = 0;	% initial phase����λ��ʼ��
order = 5;	% filter order���˲�������
bw = 0.2;	% normalized filter bandwidth����һ�����˲�������
error = 0;%�����ķ��Ŵ�����
delay = 5;%������ʱ
%
% initialize vectors������������ʼ��
%
%���Ͷ�
data = zeros(1,bits); d = zeros(1,m); q = zeros(1,m);
dd = zeros(1,m); qq = zeros(1,m); theta = zeros(1,m);
thetaout = zeros(1,sps*m);
%���ն�
U = zeros(1,m);V = zeros(1,m);
datafinal = zeros(1,bits);
%
% set direct and quadrature bit streams���õ�ͬ�����������������
%
data = round(rand(1,bits));%��ʼ��ϢԴ��01���У�
dd = data(1:2:bits-1);%����Ϊͬ�����
qq = data(2:2:bits);%ż��Ϊ��������
%
% ���Ͷ�
%
theta(1) = iphase;% set initial phase�����ó�ʼ��λ
thetaout(1:sps) = theta(1)*ones(1,sps);%������ĳ�ʼ��λ
for k=2:m
   if dd(k) == 1%���ݱ���е�d,qӳ����λ
      phi_k = (2*qq(k)-1)*pi/4;
   else
      phi_k = (2*qq(k)-1)*3*pi/4;
   end   
   theta(k) = phi_k + theta(k-1);%�����λ
   for i=1:sps%��λ����
      j = (k-1)*sps+i;
      thetaout(j) = theta(k);
   end
end
d = cos(thetaout);
q = sin(thetaout);%�źŵĵ�ͨ��������ʽ
[b,a] = butter(order,bw);%����һ��butterworth��ͨ�˲�����ʹ�����źű������
                         %�ŵ��������ʽ
df = filter(b,a,d);
qf = filter(b,a,q);%ͬ������������ֱ���˲���


Eb = 0.75;%�����źŵ�ƽ������ /bit
EbNodB = -6:8;% vector of Eb/No (dB) values������ȵ�����
for i = 1:length(EbNodB)%���㲻ͬ������µ�������
    %���ն˲�����ͬ�����������ĳ�ʼ��
    W = zeros(1,m);
    Z = zeros(1,m);
    
    z = 10.^(EbNodB(i)/10);			% convert to linear scale����dB�����ת��Ϊ����ֵ
    NoiseSigma = sqrt((sps*Eb)/(2*z));   % scale noise level����������ȵ�����������
    
    %
    % Generate channel noise.�����ŵ�����
    %
    NoiseSamples = NoiseSigma*randn(size(df));
    %
    % Add signal and noise.�źż���
    %
    Rxdf = df + NoiseSamples;
    Rxqf = qf + NoiseSamples;       
    %
    % Pass Received signal through matched filter.ͨ�����ն˵��ۼ��˲���
    %
    % dfi = d;
    % qfi = q;%����ʹ��
    BRx = ones(1,sps);
    ARx=1;    % matched filter parameters���˲�����������
    dfi = filter(BRx,ARx,Rxdf);
    qfi = filter(BRx,ARx,Rxqf);    
    %
    % Sample matched filter output every SamplesPerSymbol samples,
    % compare to transmitted bit, and count errors.���ն�ȡ��
    %
    for k=1:m
        a = k*sps+delay;%��k=1��ʼ���Ѿ������˳�ʼ��λ���в���
        if (a < length(dfi))
            W(k) = dfi(a);
            Z(k) = qfi(a);
        end
    end
    %
    %����
    %
    W = [1,W];%���ӳ�ʹ��λ��ͬ���ʾcos(0)
    Z = [0,Z];%���ӳ�ʼ��λ��������ʾsin(0)
    for k=1:m
        U(k) = W(k+1)*W(k)+Z(k+1)*Z(k);
        I(k) = (sign(U(k))+1)/2;
        V(k) = Z(k+1)*W(k)-W(k+1)*Z(k);
        Q(k) = (sign(V(k))+1)/2;
        datafinal(2*k-1) = I(k);
        datafinal(2*k) = Q(k);
    end

    error(i) = sum(I ~= dd)+sum(Q ~= qq);%ͳ�������
    BER(i) = error(i)/bits;%ʵ��������
    ber(i) = berawgn(EbNodB(i),'dpsk',4,'nondiff');%���������ʣ�������ʵ��
                                                   %��DQPSK���ο�
end
figure(4)%������������ͼ
semilogy(EbNodB,BER,'-*',EbNodB,ber,'-+');
xlabel('���������');
ylabel('������');
title('��ͬ������������ʷ�������');
legend('ʵ������','��������');
grid on;
%
%���ն˵ĺ���
%�൱���Խ��ն˵Ľ����Ϊ�����źţ�������һ�鷢�Ͷ˵Ĳ������е���������Ż�
%
ddr = datafinal(1:2:bits-1);
qqr = datafinal(2:2:bits);
%
% main programs
%
thetar(1) = iphase;						% set initial phase
thetaoutr(1:sps) = thetar(1)*ones(1,sps);
for k=2:m
   if ddr(k) == 1
      phi_kr = (2*qqr(k)-1)*pi/4;
   else
      phi_kr = (2*qqr(k)-1)*3*pi/4;
   end   
   thetar(k) = phi_kr + thetar(k-1);
   for i=1:sps
      j = (k-1)*sps+i;
      thetaoutr(j) = thetar(k);
   end
end
dr = cos(thetaoutr);
qr = sin(thetaoutr);

%
% postprocessor for plotting��������
%
while 1                          % test exit counter
list = {'pi/4 QPSK Receiver Signal Constellation',...
        'pi/4 QPSK Reciever Eye Diagram',...
        'Comparison plot of Direct and Quadrature Signals',...
        'Exit'};
[k,tf] = listdlg('PromptString','pi/4 QPSK Plot Options',...
                           'SelectionMode','single',...
                           'ListString',list);
    if tf == 1
        if k == 1
                sigcon(dr,qr)             	% plot signal con. 
                pause
        elseif k ==2
                dqeye(dr,qr,4*sps)        	% plot eye diagram
                pause
        elseif k == 3
                numbsym = 50;           	% number of symbols plotted
                dtr = dr(1:numbsym*sps);  	% truncate d vector
                qtr = qr(1:numbsym*sps);  	% truncate q vector
                dt = d(1:numbsym*sps);  	% truncate d vector
                qt = q(1:numbsym*sps);  	% truncate q vector
                dqplotnew(dtr,qtr,dt,qt)          	    % plot truncated d and q signals
                pause
        elseif k == 4
                break;                 	% set exit counter to exit value
        end
    end
end
% End of script file.