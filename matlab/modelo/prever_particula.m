function [kd_p, tr_p] = prever_particula(theta, dens, t_end)
%PREVER_PARTICULA kd e tr previstos para os tres cortes de Martinez-Vargas et al. (2026).
%
% Cinco parametros: theta = [log10 D0, log10 k1, log10 k_dens, n, t_ind].
% t_ind e um periodo de inducao (dissolucao do filme nativo de Al2O3, 2-5 nm) mantido
% INDEPENDENTE do tamanho: a espessura do filme e fixada pela passivacao, nao pelo diametro.
% Os dados confirmam: a diferenca entre o tr medido e a etapa reativa do modelo e quase
% constante (8.5, 12.4, 11.3 min), e nao proporcional a d.
if nargin < 2, dens = 'time'; end
if nargin < 3, t_end = 200; end
K = constantes();
kd_p = zeros(3, 1); tr_p = zeros(3, 1);
for i = 1:3
    r = simular_particula(K.D_UM(i), 'n', theta(4), 'D0', 10^theta(1), 'k1', 10^theta(2), ...
                          'k_dens', 10^theta(3), 't_end_min', t_end, 'dens', dens);
    kd_p(i) = kd_aparente(r.t, r.X);
    tr_p(i) = tempo_reacao(r, theta(5));
end
end
