% Index: c209_MCBPSKrun.m, c212_filterex1.m
% �����ַ��˲���
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
function [BER,Errors]=MCBPSKrun1(N,EbNo,delay,FilterSwitch)
SamplesPerSymbol = 10;%=20   						% samples per symbol
order = 5;                                          %filter order
NoiseSigma = sqrt(SamplesPerSymbol/(2*EbNo));   % scale noise level
DetectedSymbols = zeros(1,N);			% initialize vector
[BTx,ATx] = butter(order,2/SamplesPerSymbol); 		% compute filter parameters
BRx = ones(1,SamplesPerSymbol);
ARx = [1,zeros(1,SamplesPerSymbol-1)] ;        % matched filter parameters
Errors = 0;										% initialize error counter
[SymbolSamples,TxSymbols] = random_binary(N,SamplesPerSymbol);

%
% Simulation loop begine here.
%

if FilterSwitch==0
    TxOutput = SymbolSamples;               %�˲�����δ����
else
%
% �����ַ��˲�
%
    sreg = zeros(1,order+1);                %��λ�Ĵ�����ʼ��
    for k=1:N*SamplesPerSymbol
        in = SymbolSamples(k);              %determine input
        out = BTx(1)*in + sreg(1,1);		% determine output
        sreg = in*BTx - out*ATx + sreg;		% update register
        sreg = [sreg(1,2:(order+1)),0];	% shift-
        out2(k) = out; 						% create output vector
    end
    TxOutput = out2;%transmission output
end
%
% Generate channel noise.
%
NoiseSamples = NoiseSigma*randn(size(TxOutput));
%
% Add signal and noise.
%
RxInput = TxOutput + NoiseSamples;

%
% �����ַ��˲�
%
sreg2 = zeros(1,SamplesPerSymbol);%��λ�Ĵ�����ʼ��
for k=1:N*SamplesPerSymbol
    in = RxInput(k);%determine input
    out = BRx(1)*in + sreg2(1,1);		% determine output
    sreg2 = in*BRx - out*ARx + sreg2;		% update register
    sreg2 = [sreg2(1,2:SamplesPerSymbol),0];	% shift-
    out2(k) = out; 						% create output vector
end
IntegratorOutput = out2;
%
% ���ն˸�����ʱ������Ԫ�о������
%
for k=1:N
    m = k*SamplesPerSymbol+delay;%������ʱ��ÿ�����Ų���һ��
    if (m < length(IntegratorOutput))
        DetectedSymbols(k) = (1-sign(IntegratorOutput(m)))/2;%�о�+����
        if (DetectedSymbols(k) ~= TxSymbols(k))
            Errors = Errors + 1;
        end
    end
end

BER = Errors/N; 	% calculate BER

% End of function file.