function [stsim vtsim lndctsim lnpctsim lnrtsim lnrfsim ertsim elnrtsim sdrtsim...
    sdlnrtsim elnrcbsim sdlnrcbsim lnysim lnrcbsim testerf]=simvars(dc,lnpca,er,elnr,sdr,sdlnr,elnrcb,sdlnrcb,lny,lnrf1)

%
% Esta rotina simular� s�ries temporais das principais grandezas deste    %
% modelo e ter� a op��o de utilizar dados reais ou fict�cios.             %
%                                                                         %
% Simular�:                                                               %
% - processo de s=log(S);                                                 %
% - P/C; % % - R{t+1};                                                    %
% - E{t}[R{t+1}];                                                         %
% - SD{t}[R{t+1}];                                                        %
% - USA Rf{t+1} calibrado;                                                %
% - Rf{t+1} com consumo correlacionado com os USA                         %
% - Bonds                                                                 %
%                                                                         %
% Todas as s�ries simuladas ser�o sufixadas por 'tsim' e ter�o a mesma    %
% nomea��o herdada dos programas anteriores (findlpc e finders).          %
%                                                                         %
% Se o input de simvars � nulo, que dizer que este programa ir� simular o %
% processo de consumo do modelo. Caso o usu�rio queira inserir os dados   %
% reais da economia americana, as outras vari�veis ser�o simuladas atrav�s%
% destes dados de consumo.                                                %
% ----------------------------------------------------------------------- %

global ncalc gamma sig g phi delta s_max s_bar sg maxcb tsc bondsel
%% Ajustando o input do programa de simula��o dos dados Americanos
if dc == 0 T=ncalc;             % Simvars ir� simular os dados de consumo.
    
    vtsim = sig*randn(T,1);
    
    lndctsim = g + vtsim;

else                         % Simvars ir� utilizar dados reais de consumo.
    if min(dc) <= 0
        
        disp('simvars: Voc� inseriu o log do crescimento do consumo.');
        disp('Preciso que voc� insira os dados de crescimento do consumo ');
        disp('bruto, isto �, nem log nem crescimento l�quido.');
        
    end
    T = length(dc); lndctsim = log(dc); 
    vtsim = lndctsim - g; 
end

%% Simular vari�vel de estado log(S)

stsim = zeros(T+1,1);

stsim(1) = s_bar;           % A economia come�a no seu estado estacion�rio.

for i=2:T+1
    if strans(stsim(i-1),vtsim(i-1)) <= s_max
        
        stsim(i) = strans(stsim(i-1),vtsim(i-1));
        
    else
        stsim(i)=(1-phi)*s_bar+phi*stsim(i-1);
    end
end

%% Simulando a raz�o P/C                                                  % 

lnpctsim = interp(stsim,sg,lnpca)';

%% Retornos ex-post                                                       %
%                                                                         % 
%                        R = (C'/C){(1+(P/C)')/(P/C)}                     % 
% ----------------------------------------------------------------------- %

lnrtsim = log(1+exp(lnpctsim(2:T+1))) - lnpctsim(1:T) + lndctsim;

%% Log de Rf variante no tempo

lnrfsim = -log(delta) + gamma*g - gamma*(1-phi)*(stsim-s_bar)... 
    - 0.5*(gamma*sig*(1+lambda(stsim))).^2;

%% Retornos esperados e desvio condicional 

testerf = interp(stsim,sg,lnrf1)';
ertsim = interp(stsim,sg,er)';
elnrtsim = interp(stsim,sg,elnr)'; 
sdrtsim = interp(stsim,sg,sdr)'; 
sdlnrtsim = interp(stsim,sg,sdlnr)';

%% Retornos esperados das T-Bill 90

elnrcbsim = interp(stsim,sg,elnrcb(:,1))'; % Retornos esperados do bonds
sdlnrcbsim = interp(stsim,sg,sdlnrcb(:,1))'; 
lnysim = interp(stsim,sg,lny(:,1))';       % Bond yields
lny2sim = zeros(size(lnysim,1),1);

for i = 2:(maxcb*tsc)
    if find(i == bondsel*tsc)
        
        lnysim = cat(2,lnysim,interp(stsim,sg,lny(:,i))');
        lny2sim = cat(2,lny2sim,interp(stsim,sg,lny(:,i-1))'); 
        elnrcbsim = cat(2,elnrcbsim,interp(stsim,sg,elnrcb(:,i))'); 
        sdlnrcbsim = cat(2,sdlnrcbsim,interp(stsim,sg,sdlnrcb(:,i))');
    
    end
end

% Retornos das maturidades ajustadas em bondsel = [1 2 4 8 12 16 20] 

lnrcbsim = cat(1,0,lnysim(1:T-1,1));
for i = 2:length(bondsel)
    lnrcbsim = cat(2,lnrcbsim,cat(1,0,(-lny2sim(2:T,i)*((bondsel(i)- 1/tsc))+...
        lnysim(1:T-1,i)*bondsel(i))/tsc));
end
end


