function [inside] = pdivsmotor(w)
% Procedure to be used for numeric integration when calculating
% the fixed point. It has as argument only w ~ N (0, sig_w). Returns VALUE of
% P / D for each iteration over the current value of s {t} in each iteration.
% ----------------------------------------------------------------------- %
global delta g gamma s sg lnpd debug rhow sig_w sig
s1=strans(s,w);
inside = exp(g) .* exp(0.5 * (1-rhow ^2) * sig_w^2) .*... Before expectations
    delta * exp(g)^(-gamma) * exp(-gamma*(s1-s + w)).*... 
    exp(rhow * sig_w/sig * w)...
    .* (1+exp(interp(s1,sg,lnpd)))';
debug(:,2)=inside';
  
% (1+exp(interp(s1,sg,lnpd)))' = P/D_t+1

end

%{inside = delta*exp(g*(1-gamma))*exp(-gamma*(s1-s)).*...
% (1+exp(interp(s1,sg,lnpd)))'.*exp((1-gamma)*w);}

%%
% inside = exp(g) .* exp(0.5 * (1-rhow ^2) * sig_w^2) .*... Before expectations
%     delta * exp(g)^(-gamma) * exp(-gamma*(s1-s)).*... 
%     exp((1-gamma) * rhow * sig_w/sig .* w)...
%     .* (1+exp(interp(s1,sg,lnpd)))';
% debug(:,2)=inside';