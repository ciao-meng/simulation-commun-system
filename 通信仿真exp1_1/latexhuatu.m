clc
clear
x = 0:0.01:0.5*(sqrt(3));
y1 = -0.5 + x*(sqrt(3));
y2 = -x/(sqrt(3))+0.5;

plot(x,y1,'--');
hold on
plot(x,y2,'--');
hold on 
plot([0 0.86],[0.5 0],'o');
hold off
axis equal
axis([0 1 0 1]);
xlabel('{\itx}');
ylabel('{\ity}');
text(0,0.55,'d[n]=1');
text(0.86,0.05,'d[n]=0');
latexf=['$$\sqrt{3}x-y=0.5$$'];
lgh=text(0.63,0.59,latexf);
set(lgh,'interpreter','latex');




