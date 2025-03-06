f = -3:0.01:3;
Sxf1 = ((sinc(f/2)).^4);
plot(f,abs(Sxf1));

a = (cos(2*pi*f)).^2;
b = (1-(4*f).^2).^2;
Sxf2 = a./b;
hold on
plot(f,abs(Sxf2));

Sxf3 = (sinc(2*f).^2);
hold on 
plot(f,abs(Sxf3)); 

Sxf = ((sinc(f)).^2);
hold on
plot(f,abs(Sxf));
hold off
legend('三角形脉冲','MSK信号','QPSK信号','矩形脉冲');
xlabel('frequency');
ylabel('magnitude');