function code = b2bCodeGen(PRNs)
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
% 生成多项式系数
g1 = [ 1, 9,10,13];
g2 = [ 3, 4, 6, 9,12,13];
% 初始化
code = false(10230,numPRNs);
for i = 1:numPRNs
    % 寄存器初始化
    reg1 = reg1_ini;
    reg2 = reg2_ini(PRNs(i),:);
    for j = 1:10230
        % data分量
        code(j,i) = arrayXor([reg1(end) reg2(end)]);
        reg1(end) = arrayXor(reg1(g1));
        reg2(end) = arrayXor(reg2(g2));
        reg1 = circshift(reg1,1);
        reg2 = circshift(reg2,1);
        % 寄存器1复位
        if j == 8190
            reg1 = reg1_ini;
        end
    end
end
% 0 ==> 1; 1 ==> -1
code = -2*code + 1;
end
%% 异或
function res = arrayXor(X)
res = false;
for ii = 1:numel(X)
    res = xor(res,X(ii));
end
end