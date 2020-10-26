function [code_d, code_p] = b2aMainCodeGen(PRNs)
% 寄存器初始状态
reg1_ini = true(13,1);
reg2_ini = [4133;4148;4269;4431;4437;4526;4590;4603;4905;5082;...
    5173;5188;5205;5211;5212;5283;5367;5377;5438;5547;...
    5553;5715;5730;5784;5814;5874;5887;5906;5948;6049;...
    6088;6100;6123;6131;6225;6292;6327;6417;6425;6571;...
    6577;6610;6741;6772;6859;6999;7220;7299;7307;7331;...
    7336;7483;7575;7752;7828;7833;7898;7928;7935;8117;...
    1026;7157; 978];
reg2_ini = bsxfun(@bitget,reg2_ini,13:-1:1);
% PRN数目
numPRNs = numel(PRNs);
% 数据分量 生成多项式系数
g1_d = [ 1, 5,11,13];
g2_d = [ 3, 5, 9,11,12,13];
% 导频分量 生成多项式系数
g1_p = [ 3, 6, 7,13];
g2_p = [ 1, 5, 7, 8,12,13];
% 初始化-data分量
code_d = false(10230,numPRNs);
% 初始化-pilot分量
code_p = false(10230,numPRNs);
for i = 1:numPRNs
    % 寄存器初始化
    reg1_d = reg1_ini;
    reg2_d = reg2_ini(PRNs(i),:);
    reg1_p = reg1_ini;
    reg2_p = reg2_ini(PRN(i),:);
    for j = 1:10230
        % data分量
        code_d(j,i) = arrayXor([reg1_d(end) reg2_d(end)]);
        reg1_d(end) = arrayXor(reg1_d(g1_d));
        reg2_d(end) = arrayXor(reg2_d(g2_d));
        reg1_d = circshift(reg1_d,1);
        reg2_d = circshift(reg2_d,1);
        % pilot分量
        code_p(j,i) = arrayXor([reg1_p(end) reg2_p(end)]);
        reg1_p(end) = arrayXor(reg1_p(g1_p));
        reg2_p(end) = arrayXor(reg2_p(g2_p));
        reg1_p = circshift(reg1_p,1);
        reg2_p = circshift(reg2_p,1);
        % 寄存器1复位
        if j == 8190
            reg1_d = reg1_ini;
            reg1_p = reg1_ini;
        end
    end
end
% 0 ==> 1; 1 ==> -1
code_d = -2*code_d + 1;
code_p = -2*code_p + 1;
end
%% 异或
function res = arrayXor(X)
res = false;
for ii = 1:numel(X)
    res = xor(res,X(ii));
end
end