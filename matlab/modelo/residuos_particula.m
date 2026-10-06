function res = residuos_particula(theta, dens)
%RESIDUOS_PARTICULA Residuos ponderados (kd e tr) do modelo de particula; 6 valores.
% Se theta tiver 4 elementos, n e fixado em 2.68 (theta = [log10 D0, log10 k1, log10 k_dens, t_ind]),
% pois a serie de tamanhos sozinha nao identifica n -- ver ajuste/identificabilidade.m.
if nargin < 2, dens = 'time'; end
K = constantes();
if numel(theta) == 4
    theta = [theta(1), theta(2), theta(3), K.N_FIXO, theta(4)];
end
[kd_p, tr_p] = prever_particula(theta, dens);
if ~all(isfinite(kd_p))
    res = 1e3 * ones(6, 1); return
end
res = [(kd_p - K.KD_OBS) ./ K.KD_SEM; (tr_p - K.TR_OBS) ./ K.TR_SEM];
end
