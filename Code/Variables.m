%% Variables:
%------------------------------------------%
% Load workspace output from "Principal.m" %
%------------------------------------------%
load('FULL_Workspace_Principal_run_03_11_2019_time_11_42.mat');
%%% Consumption %%%
% ln(C_t) or c_t
ct = cumsum(alndctsim_pf);
% delta c_t
dct = alndctsim_pf;

%%% Surplus Consumption ratio %%%
% ln(S_t) or s_t
st = astsim_pf;
% S_t
St = exp(astsim_pf);

%%% Price/Consumption ratio %%%
% ln(P_t/C_t) or p_t - c_t
pct = alnpctsim_pf;

%%% Returns %%%
% ln(R_t) or r_t
rt = alnrtsim_pf;

%  std(r_t) or Volatility
std_rt = asdlnrtsim_pf;

%%% Risk-free rate %%%
% log(R^f _t) or r^f_t
rft = alnrfsim_pf;

%%% LOM: Prices %%%
% (p_t - c_t) - (p_(t-1) - c_(t-1)) + delta c_t
pt = alnchpsim_pf;

clearvars -except ct dct st pct rt std_rt rft pt s_max s_bar g Eexrett_pf Stdexrett_pf
%%
Model_Calibration;
%%
indicator_rec = NaN(size(st,1),1);
for i=1:size(st,1)
    if st(i) < s_bar
        indicator_rec(i) = 1;
    else
        indicator_rec(i) = 0;
    end
end
%%
RetAM = importdata('Annual_rets.csv');
RFR   = importdata('Bonds_INF.csv'); 
RFR   = log(1 + RFR.data(:,2)) - log(1 + RFR.data(:,4));
ExcessRet =   log(1 + RetAM.data(:,2)) - RFR;
HistEexrets = mean(ExcessRet);
HistStdexretsstd = std(ExcessRet);
HistSHRPRatio = HistEexrets/HistStdexretsstd
SimSHRPRatio = Eexrett_pf/Stdexrett_pf
%%
pred = [ones(size(st,1)-1,1) indicator_rec(1:end-1) .* pct(1:end-1) st(1:end-1)];
y = st(2:end);
[b, bstd, ~,~,stats] = regress(y,pred)
stats(1)