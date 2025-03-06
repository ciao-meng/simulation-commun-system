% File: dqplot.m
% Software given here is to accompany the textbook: W.H. Tranter, 
% K.S. Shanmugan, T.S. Rappaport, and K.S. Kosbar, Principles of 
% Communication Systems Simulation with Wireless Applications, 
% Prentice Hall PTR, 2004.
%
function [] = dqplot(xdr,xqr,xd,xq)
lx = length(xdr);
t = 0:lx-1;
nt = t/(lx-1);
nxdr = xdr(1,1:lx);
nxqr = xqr(1,1:lx);
nxd = xd(1,1:lx);
nxq = xq(1,1:lx);
figure(3)
subplot(211)
plot(nt,nxdr,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(nt,nxd,'--','Color',[1,0.27,0],'LineWidth',2);
a = axis;
axis([a(1) a(2) 1.5*a(3) 1.5*a(4)]);
title('Direct and Quadrature Channel Signals');
xlabel('Normalized Time');
ylabel('Direct');
legend('Receiver','Transmiter');
subplot(212)
plot(nt,nxqr,'-','Color',[30,144,255]/255,'LineWidth',2);
hold on
plot(nt,nxq,'--','Color',[1,0.27,0],'LineWidth',2);
a = axis;
axis([a(1) a(2) 1.5*a(3) 1.5*a(4)]);
xlabel('Normalized Time');
ylabel('Quadratute');
legend('Receiver','Transmiter');
subplot(111)
% End of function file.
