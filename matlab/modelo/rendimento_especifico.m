function [tau, V] = rendimento_especifico(d50_um, span, theta, t_end_min, n_points)
%RENDIMENTO_ESPECIFICO Volume acumulado de H2 por grama de Al carregado (mL/g) em funcao do
%tempo desde a carga da parcela (sem a inducao; quem chama reaplica a inducao uma vez).
%
% Devolvido como curva ACUMULADA V(tau), nao como sua derivada (a vazao). Para particulas
% finas a vazao e um pico de centesimos de minuto; reamostrar esse pico numa malha de reator
% (~0.1 min) nao conserva sua integral -- uma versao anterior fazia isso e superestimava o
% rendimento do caso de 6.8 um em quase 2x. A curva acumulada e suave e limitada, entao
% reamostra-la nunca viola a conservacao de massa; so a forma da subida e suavizada.
if nargin < 2, span = 0.5; end
if nargin < 3, theta = []; end
if nargin < 4, t_end_min = 400; end
if nargin < 5, n_points = 3000; end
persistent cache
chave = sprintf('%.10g|%.10g|%s|%g|%d', d50_um, span, mat2str(theta, 12), t_end_min, n_points);
if isempty(cache), cache = containers.Map(); end
if isKey(cache, chave)
    c = cache(chave); tau = c{1}; V = c{2}; return
end
r = simular_batelada(d50_um, 1.0, 1e6, 1.0, 'theta', theta, 'span', span, ...
                     't_end_min', t_end_min, 'n_points', n_points, 'termico', false, 'esgotar', false);
tau = r.t - r.t(1);                       % retira a inducao; reaplicada depois
V = cummax(max(r.V_cum, 0));              % mL por g alimentado
cache(chave) = {tau, V};
end
