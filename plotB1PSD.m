% B1 信号功率谱图
%% 参数设置
% 载波频率
fb1c = 1575.42e6;
fb1i = 1561.098e6;
fs = 100e6;      % 采样频率
fIFc = 25.42e6;     % B1C中频
fIFi = fIFc + fb1i - fb1c; % B1I中频
PRN = 16;
t = 0.01;
% 由多普勒效应与本地时钟频偏引起的频率偏移
deltaF = 1625; 
% 初始相位偏移
phi = 0.2;
% 接收信号功率
pb1c = -159;   % -159 dBW (MEO卫星)
pb1i = -163;   % -163 dBW 
%% 生成b1c/b1i信号
[b1c,sD,sP1,sP2] = b1cSignalGen(t,PRN,fs,fIFc,deltaF,phi,pb1c);
b1i = b1iSignalGen(t,PRN,fs,fIFi,deltaF/fb1c*fb1i,phi,pb1i);
%% 功率谱密度估计
fig = figure('Position',[100 100 500 500]);
t = tiledlayout(3,2,'Parent',fig,'TileSpacing','none','Padding','none');
xlabel(t,'Frequency (MHz)','FontName','Times New Roman','FontSize',10,'Color','r');
ylabel(t,'Power Spectral Density  (dB/Hz)','FontName','Times New Roman','FontSize',10,'Color','r');
ax = gobjects(3,2);
for i = 1:6
    ax(i) = nexttile;
    ax(i).Box = 'on';
    ax(i).Title.Color = 'r';
    ax(i).FontName = 'Times New Roman';
    ax(i).FontSize = 7;
    ax(i).XLim = [1550e6 1600e6];
    ax(i).XTick = 1550e6:10e6:1600e6;
    ax(i).XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
    ax(i).YLim = [-265 -220];
    grid(ax(i),'on');
    ax(i).GridAlpha = 0.5;
    ax(i).GridLineStyle = '--';   
end
%% 导频分量1(正交)
[p,f] = pwelch(sP1,500,250,512,fs);
line(ax(1),f+fb1c-fIFc,10*log10(p));
ax(1).Title.String = 'B1C Pilot Component (Quadrature)';
line(ax(1),[fb1c fb1c],ax(1).YLim,'LineStyle',':');
text(ax(1),fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% 导频分量2(同相)
[p,f]=pwelch(sP2,500,250,512,fs);
line(ax(2),f+fb1c-fIFc,10*log10(p));
ax(2).Title.String = 'B1C Pilot Component (In-phase)';
line(ax(2),[fb1c fb1c],ax(2).YLim,'LineStyle',':');
text(ax(2),fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C数据分量
ax(3).Title.String = 'B1C Data Component';
[p,f]=pwelch(sD,500,250,512,fs);
line(ax(3),f+fb1c-fIFc,10*log10(p));
line(ax(3),[fb1c fb1c],ax(3).YLim,'LineStyle',':');
text(ax(3),fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C全体分量
ax(4).Title.String = 'B1C (All Component)';
[p,f] = pwelch(b1c,500,250,512,fs);
line(ax(4),f+fb1c-fIFc,10*log10(p));
line(ax(4),[fb1c fb1c],ax(4).YLim,'LineStyle',':');
text(ax(4),fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1I
ax(5).Title.String = 'B1I';
[p,f] = pwelch(b1i,500,250,512,fs);
line(ax(5),f+fb1c-fIFc,10*log10(p));
line(ax(5),[fb1i fb1i],ax(5).YLim,'LineStyle',':');
text(ax(5),fb1i,-230,'1561.098','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C + B1I
ax(6).Title.String = 'B1C & B1I';
[p,f] = pwelch(b1c + b1i,500,250,512,fs);
line(ax(6),f+fb1c-fIFc,10*log10(p));
line(ax(6),[fb1c fb1c],ax(6).YLim,'LineStyle',':');
line(ax(6),[fb1i fb1i],ax(6).YLim,'LineStyle',':');
text(ax(6),fb1i,-230,'1561.098','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
text(ax(6),fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
print('-r200','B1_PSD','-dpng');