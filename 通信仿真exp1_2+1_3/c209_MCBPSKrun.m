% File: c10_MCBPSKrun.m
% ���鷨�˲�
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
function [BER,Errors]=MCBPSKrun(N,EbNo,delay,FilterSwitch)
SamplesPerSymbol = 10;%=20   						% samples per symbol
BlockSize = 1000;								% block size              
NoiseSigma = sqrt(SamplesPerSymbol/(2*EbNo));   % scale noise level
DetectedSymbols = zeros(1,BlockSize);			% initialize vector           
NumberOfBlocks = floor(N/BlockSize);			% number of blocks processed      
[BTx,ATx] = butter(5,2/SamplesPerSymbol);  		% compute filter parameters
[TxOutput,TxFilterState] = filter(BTx,ATx,0);	% initialize state vector
BRx = ones(1,SamplesPerSymbol);
ARx=1;          % matched filter parameters
Errors = 0;										% initialize error counter                
%                       
% Simulation loop begine here.
%
for Block=1:NumberOfBlocks           
     %
     % Generate transmitted symbols.
     %
     [SymbolSamples,TxSymbols] = random_binary(BlockSize,SamplesPerSymbol);
     %
     % Transmitter filter if desired.
     %
     if FilterSwitch==0
        TxOutput = SymbolSamples;
     else   
        [TxOutput,TxFilterState] = filter(BTx,ATx,SymbolSamples,TxFilterState);
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
     % Pass Received signal through matched filter.
     %
     IntegratorOutput = filter(BRx,ARx,RxInput);
     %
     % Sample matched filter output every SamplesPerSymbol samples,
     % compare to transmitted bit, and count errors.
     %
     for k=1:BlockSize,
        m = k*SamplesPerSymbol+delay;
        if (m < length(IntegratorOutput))
           DetectedSymbols(k) = (1-sign(IntegratorOutput(m)))/2;%�о�+����
           if (DetectedSymbols(k) ~= TxSymbols(k))
              Errors = Errors + 1;
           end
        end
     end   
end                            
BER = Errors/(BlockSize*NumberOfBlocks); 	% calculate BER
% End of function file.
