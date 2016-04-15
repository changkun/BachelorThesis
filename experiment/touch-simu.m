%matlab2014nb
fun=@(p,x) p(1)./x.*exp(-((log(x)-p(2))/p(3)).^2/2); %对数正态分布密度函数

x=1:1:20;
xl={'0~50','50~100','100~150','150~200','200~250','250~300','300~350','350~400','400~450','450~500','500~550','550~600','600~650','650~700','700~750','750~800','800~850','850~900','900~950','950~1000'};
y=[1981,2546,4189,5581,7773,7376,6345,5905,4485,4845,3512,2041,1384,1493,785,350,289,213,190,157];
bar(x,y,0.8,'FaceColor',[1,0.96,0.6]);hold on;
%bar(x,y,0.5,'blue');hold on; %根据x，y数据画柱状图
set(gca,'XTick', x, 'XTickLabel', xl)
set(gca,'XLim',[1,20])
[maxy ind]=max(y);

p=nlinfit(x,y,fun,[maxy*x(ind),log(x(ind)),1]); %拟合
%p(1)~和幅度有关    p(2)~mu    p(3)~sigma
xfit=[1:0.1:20];
yfit=fun(p,xfit);  %计算拟合曲线
plot(xfit,yfit,'--r','Color',[0.92,0.41,0.25],'linewidth',2);

xmax=exp(p(2)-p(3)^2);%计算分布极大分布处和值 x=exp(mu-sigma^2);
ymax=fun(p,xmax);
plot([xmax xmax],[0 ymax],'Color',[0,0.42,0.93],'linewidth',3);

hold off;
%xlim([min(x) max(x)]);
xlabel('Duration of Finger Stay on Screen(ms)');
ylabel('Count');
legend('Count',['Log-Normal: \mu=' num2str(p(2)) ',\sigma=' num2str(p(3))],['Maximum Likelihood:x=' num2str(xmax*49)]);
%text(xmean+10000,ymean+10,'$ y=\frac{A}{x}e^{-\frac{(lnx-\mu)^2}{2\sigma^2}} $','interpreter','latex','FontSize',14);
set(gca,'FontSize',14)
ax=gca;
ax.XTickLabelRotation=90;
