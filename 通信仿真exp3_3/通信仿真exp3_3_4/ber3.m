% File: c14_Jakes.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
% This program builds up a two-tap TDL model and computes the output 
% for the two inpput signasl of interest.
function [peideal,pesystem]=ber3(ebn0db)
%
%����ȵĳ�ʼ��
%
% ebn0db = [1:10];						% Eb/N0 vector
ebn0=10.^(ebn0db/10);% bit power per noise
L = length(ebn0db);
%
% Generate tapweights. 
%
fd = 100; impw = jakes_filter(fd);
for k=1:L
    %
    % Generate tap input processes and Run through doppler filter.
    %
    x1 = randn(1,256)+i*randn(1,256); y1 = filter(impw,1,x1);
    x2 = randn(1,256)+i*randn(1,256); y2 = filter(impw,1,x2);
    %
    % Discard the first 128 points since the FIR filter transient.
    % Scale them for power and Interpolate weight values.
    % Interpolation factor=100 for the QPSK sampling rate of 160000/sec.
    %
    z1(1:128) = y1(129:256); z2(1:128) = y2(129:256);
    z2 = sqrt(0.5)*z2; m = 100;
    tw1 = linear_interp(z1,m); tw2 = linear_interp(z2,m);
    %
    % Generate QPSK signal and filter it.
    %
    nbits = 512; nsamples = 16; ntotal = 8192;tb=0.5;
    qpsk_sig = random_binary(nbits,nsamples)+i*random_binary(nbits,nsamples);
    %
    % Genrate output of tap1 (size the vectors first).
    %
    input1 = qpsk_sig(1:8184); output1 = tw1(1:8184).*input1;
    %
    % Delay the input by eight samples (this is the delay specified
    % in term of number of samples at the sampling rate of
    % 16,000 samples/sec and genrate the output of tap 2.
    %
    input2 = qpsk_sig(9:8192); output2 = tw2(9:8192).*input2;
    %
    % Add the two outptus and genrate overall output.
    %
    qpsk_output = output1+output2;
    %
    % ������˹������
    %
    EsN0=2*ebn0(k);% symbol power per noise
    N0=1/EsN0;% AWGN noise variance
    noise = sqrt(N0/2)*(randn(1,ntotal-8)+1i*randn(1,ntotal-8));
    %
    % ����˥���Ĺ�AWGN�ŵ�
    %
    y1 = qpsk_output + noise;
    %
    % Matched filter�������˲�
    %
    b = ones(1,nsamples); b = b/nsamples; a = 1;
    y = filter(b,a,y1);
    %
    % End of simulation
    %
    % Use the semianalytic BER estimator. The following sets
    % up the semi analytic estimator. Find the maximum magnitude
    % of the cross correlation and the corresponding lag.
    %
    [cor lags] = vxcorr(qpsk_sig,y);
    [cmax nmax] = max(abs(cor));
    timelag = lags(nmax);
    theta = angle(cor(nmax))
    y = y*exp(-i*theta);     								% derotate
    %
    % Noise BW calibration����������У׼
    %
    hh = impz(b,a); ts = 1/16; nbw = (nsamples/2)*sum(hh.^2);
    %
    % Delay the input, and do BER estimation on the last 128 bits.
    % Use middle sample. Make sure the index does not exceed number
    % of input points. Eb should be computed at the receiver input.
    %
    index = (10*nsamples+8:nsamples:(nbits-10)*nsamples+8);
    xx = qpsk_sig(index);
    yy = y(index-timelag+1);
    [n1 n2] = size(y1); ny2=n1*n2;
    eb = tb*sum(sum(abs(y1).^2))/ny2;
    eb = eb/2;
    [peideal(k),pesystem(k)] = qpsk_berest(xx,yy,ebn0db(k),eb,tb,nbw);
end
% figure
% semilogy(ebn0db,peideal,'b*-',ebn0db,pesystem,'r+-')
% xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
% % legend('����ֵ')
% legend('����ֵ','����ֵ')
% axis([0 11 10^(-6) 1])