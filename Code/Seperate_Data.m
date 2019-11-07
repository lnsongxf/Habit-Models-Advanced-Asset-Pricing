%% Main data examination
Dat = readtable('ts1.txt');

tsc = 12;
g=0.0189/tsc;
sig=0.015/sqrt(tsc);
rf0=0.0094/tsc;
phi=0.87^(1/tsc);
gamma=2;
B=0;
verd=0;
ann=0;
S_bar=sig*sqrt(gamma/(1-phi-B/gamma));
s_bar = log(S_bar);
s_max = s_bar + (1-S_bar^2)/2;
S_max = exp(s_max);
%% Variables
s_t = Dat.S_t;
pd_t = Dat.PCratio;
ret_t = Dat.ExPostReturns;
%% State Variables
T = size(s_t, 1);

S_state_Rec = zeros(T, 1);
S_state_Exp = zeros(T, 1);
Dummy_Rec   = zeros(T, 1);
for i=1:size(s_t, 1)
    if s_t(i) > s_bar
        S_state_Exp(i) = s_t(i);
        S_state_Rec(i) = 0;
        Dummy_Rec(i)   = 0;
    else
        S_state_Exp(i) = 0;
        S_state_Rec(i) = s_t(i);
        Dummy_Rec(i)   = 1;
    end
end
%% Recession only sample
TableRec = table(S_state_Rec, ret_t, pd_t);
TableRec=TableRec(~any(ismissing(TableRec),2),:);
TableRec=TableRec(1:3000,:);
%% Regression
y = TableRec.ret_t;
x = TableRec.S_state_Rec;
x = cat(2, ones(size(x, 1), 1), x);
[b, bint, ~, ~, stats] = regress(y,x)

%% Expansion only sample
TableExp = table(S_state_Exp, ret_t, pd_t);
TableExp=TableExp(~any(ismissing(TableExp),2),:);
TableExp = TableExp(1:3000,:);
y = TableExp.ret_t;
x = TableExp.S_state_Exp;
x = cat(2, ones(size(x, 1), 1), x);
[b, bint, ~, ~, stats] = regress(y,x)