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
t = tiledlayout(3,2,'TileSpacing','none','Padding','none');
xlabel(t,'Frequency (MHz)','FontName','Times New Roman','FontSize',10);
ylabel(t,'Power Spectral Density  (dB/Hz)','FontName','Times New Roman','FontSize',10);
%% 导频分量1(正交)
ax1 = nexttile;
[p,f] = pwelch(sP1,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax1.Title.String = 'B1C Pilot Component (Quadrature)';
ax1.Title.Color = 'r';
ax1.FontName = 'Times New Roman';
ax1.FontSize = 6;
ax1.XTick = 1550e6:10e6:1600e6;
ax1.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax1.XLabel.String = 'Frequency (MHz)';
% ax1.YLabel.String = 'PSD (dB/Hz)';
ax1.YLim = [-265 -220];
grid on
ax1.GridAlpha = 0.5;
ax1.GridLineStyle = '--';
line([fb1c fb1c],ax1.YLim,'LineStyle',':');
text(fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% 导频分量2(同相)
ax2 = nexttile;
[p,f]=pwelch(sP2,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax2.Title.String = 'B1C Pilot Component (In-phase)';
ax2.Title.Color = 'r';
ax2.FontName = 'Times New Roman';
ax2.FontSize = 6;
ax2.XTick = 1550e6:10e6:1600e6;
ax2.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax2.XLabel.String = 'Frequency (MHz)';
% ax2.YLabel.String = 'PSD (dB/Hz)';
ax2.YLim = [-265 -220];
grid on
ax2.GridAlpha = 0.5;
ax2.GridLineStyle = '--';
line([fb1c fb1c],ax2.YLim,'LineStyle',':');
text(fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C数据分量
ax3 = nexttile;
[p,f]=pwelch(sD,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax3.Title.String = 'B1C Data Component';
ax3.Title.Color = 'r';
ax3.FontName = 'Times New Roman';
ax3.FontSize = 6;
ax3.XTick = 1550e6:10e6:1600e6;
ax3.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax3.XLabel.String = 'Frequency (MHz)';
% ax3.YLabel.String = 'PSD (dB/Hz)';
ax3.YLim = [-265 -220];
grid on
ax3.GridAlpha = 0.5;
ax3.GridLineStyle = '--';
line([fb1c fb1c],ax3.YLim,'LineStyle',':');
text(fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C全体分量
ax4 = nexttile;
[p,f] = pwelch(b1c,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax4.Title.String = 'B1C (All Components)';
ax4.Title.Color = 'r';
ax4.FontName = 'Times New Roman';
ax4.FontSize = 6;
ax4.XTick = 1550e6:10e6:1600e6;
ax4.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax4.XLabel.String = 'Frequency (MHz)';
% ax4.YLabel.String = 'PSD (dB/Hz)';
ax4.YLim = [-265 -220];
grid on
ax4.GridAlpha = 0.5;
ax4.GridLineStyle = '--';
line([fb1c fb1c],ax4.YLim,'LineStyle',':');
text(fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1I
ax5 = nexttile;
[p,f] = pwelch(b1i,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax5.Title.String = 'B1I';
ax5.Title.Color = 'r';
ax5.FontName = 'Times New Roman';
ax5.FontSize = 6;
ax5.XTick = 1550e6:10e6:1600e6;
ax5.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax5.XLabel.String = 'Frequency (MHz)';
% ax5.YLabel.String = 'PSD (dB/Hz)';
ax5.YLim = [-265 -220];
grid on
ax5.GridAlpha = 0.5;
ax5.GridLineStyle = '--';
line([fb1i fb1i],ax5.YLim,'LineStyle',':');
text(fb1i,-230,'1561.098','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
%% B1C + B1I
ax6 = nexttile;
[p,f] = pwelch(b1c + b1i,500,250,512,fs);
plot(f+fb1c-fIFc,10*log10(p));
ax6.Title.String = 'B1C + B1I';
ax6.Title.Color = 'r';
ax6.FontName = 'Times New Roman';
ax6.FontSize = 6;
ax6.XTick = 1550e6:10e6:1600e6;
ax6.XTickLabel = {'1550' '1560' '1570' '1580' '1590' '1600'};
% ax6.XLabel.String = 'Frequency (MHz)';
% ax6.YLabel.String = 'PSD (dB/Hz)';
grid on
ax6.GridAlpha = 0.5;
ax6.GridLineStyle = '--';
ax6.YLim = [-265 -220];
line([fb1c fb1c],ax6.YLim,'LineStyle',':');
line([fb1i fb1i],ax6.YLim,'LineStyle',':');
text(fb1i,-230,'1561.098','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);
text(fb1c,-230,'1575.42','HorizontalAlignment','center','FontName','Times New Roman','FontSize',7);