name = string(['Tables/RegressionTable.tex']);
if isfile(name)
delete name;
end

%%
diary(name);
diary on

disp['\begin{table}[H] \centering   ']
disp['  \caption{Regressions}           ']
disp['  \label{tab:regress}     ']
disp['  \begin{threeparttable}']    
disp['\begin{tabular}{@{\hspace{5pt}}l@{\hspace{5pt}}cccc} ']
disp['\toprule ']
disp[' & \multicolumn{4}{c}{\textit{Dependent variable:}} \\ ']
disp[' & \multicolumn{4}{c}{$\left[ r_{t+1}-r^f\right]$} \\ ']
disp[' \cmidrule(rr){2-5}']
disp[' & (1)   &   (2) &   (3) &  (4)\\ ']
disp['\midrule  ']
disp['\\[-2.1ex] $\left( p_t - c_t \right)_{REC}$ & $-$0.1516  & &  \\ ']
disp['  & (0.0107) & & & \\ ']
disp[' \addlinespace ']
disp['  $\left( p_t - c_t \right)_{EXP}$ & $-$ 0.1484 & &  \\ ']
disp['  & (0.0093) & & &\\ ']
disp[' \addlinespace ']
disp[' $p_t - c_t$ &  & $-$0.1349 & & \\']
disp[' & & (0.0066) \\']
disp[' \addlinespace ']
disp['  $\left( p_t - d_t \right)_{REC}$ & & & $-$0.1555   &  \\ ']
disp['  & & & (0.0177)    &\\ ']
disp[' \addlinespace ']
disp['  $\left( p_t - d_t \right)_{EXP}$ & & & $-$ 0.1527 &  \\ ']
disp['  &  & & (0.0154) &\\ ']
disp[' \addlinespace ']
disp[' $p_t - d_t$ & & & & $-$0.1413  \\']
disp[' & & & &  (0.0103)  \\']
disp[' \addlinespace ']
disp[' Constant & 0.55 & 0.5039 & 0.5635 & 0.5239 \\ ']
disp['  & (0.0321) & (0.0226) & (0.0531)  & (0.0350) \\ ']
disp[' \addlinespace ']
disp['\midrule  ']
disp['Observations & 8,331 & 8,331 & 8,331 & 8,331 \\ ']
disp['R$^{2}$ & 0.0681 & 0.0676 & 0.0259 & 0.0258\\ ']
disp['Residual Std. Error & 0.0087 & 0.0087 & 0.0262 & 0.0262  \\ ']
disp['\bottomrule ']
disp['\end{tabular} ']
disp['\begin{tablenotes}']
disp['\footnotesize{']
disp['\item[1] Brackets below estimates contains Newey-West corrected standard errors. ']
disp['\item[2] Regressions on 8.331 years of simulated data.']
disp['}']
disp['\end{tablenotes}']
disp['\end{threeparttable}']
disp['\end{table} ']
