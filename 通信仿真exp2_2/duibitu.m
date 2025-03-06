k = 50;			                % samples per lobe
nsamp = 50000;		            % total frequency samples
snrdb = zeros(1,17);		    % initialize memory
x = 4:20;			            % vector for plotting
snrdb1 = sanjiao1(k,nsamp,snrdb);
snrdb2 = MSK2(k,nsamp,snrdb);
snrdb3 = QPSK3(k,nsamp,snrdb);
snrdb4 = eg(k,nsamp,snrdb);

figure
plot(x,snrdb1,'-o');
hold on
plot(x,snrdb2,'-+');
hold on
plot(x,snrdb3,'-diamond');
hold on
plot(x,snrdb4,'-square');
hold off
legend('三角形脉冲','MSK信号','QPSK信号','矩形脉冲');
xlabel('Samples per symbol')
ylabel('Signal-to-aliasing noise ratio')