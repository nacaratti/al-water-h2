function exportar_dados(quais)
%EXPORTAR_DADOS Recalcula, a partir do modelo, os dados de cada figura e grava dados/<fig>.mat.
%
% Uso:  >> exportar_dados            % todas as figuras (alguns minutos)
%       >> exportar_dados({'fig6_energy', 'fig8_cost'})
% Depois rode  >> gerar_todas  para refazer os graficos.
% Usa os parametros ajustados em dados/parametros_ajuste.mat (ver ajuste/busca_multipartida.m).
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, 'modelo'));
todas = {'fig2_fit', 'fig3_size', 'fig4_designcurve', 'fig5_design', 'fig5b_sensitivity', ...
         'fig6_energy', 'fig7_bayerloop', 'fig8_cost', 'figS1_designmap'};
if nargin < 1, quais = todas; end
if ischar(quais), quais = {quais}; end
for k = 1:numel(quais)
    tic;
    D = feval(['dados_' quais{k}]);
    save(fullfile(aqui, 'dados', [quais{k} '.mat']), '-struct', 'D');
    fprintf('  %s.mat  (%.0f s)\n', quais{k}, toc);
end
end

% ------------------------------------------------------------------------------------
function D = dados_fig2_fit()
K = constantes(); th = parametros_ajuste();
D.tind = th(5); D.d_um = K.D_UM; D.tr_obs = K.TR_OBS;
for i = 1:3
    r = simular_ajuste(K.D_UM(i));
    alpha = r.X / max(max(r.X), 1e-12);
    kd = kd_aparente(r.t, r.X);
    tt = linspace(0, min(r.t(end), 25), 20)';
    D.(sprintf('t%d', i)) = r.t;   D.(sprintf('X%d', i)) = r.X;
    D.(sprintf('Fd%d', i)) = F_difusao(alpha);
    D.(sprintf('tt%d', i)) = tt;   D.(sprintf('kdt%d', i)) = kd * tt;
end
end

function D = dados_fig3_size()
K = constantes(); th = parametros_ajuste();
ds = logspace(log10(0.05), log10(1000), 40)';
kds = zeros(size(ds)); xend = kds; tr_pred = kds;
for j = 1:numel(ds)
    r = simular_ajuste(ds(j));
    kds(j) = kd_aparente(r.t, r.X); xend(j) = r.X(end);
    tr_pred(j) = tempo_reacao(r, th(5));
end
ok = isfinite(kds);
local = gradiente_np(log(kds(ok)), log(ds(ok)), 1);
p = polyfit(log(K.D_UM), log(K.KD_OBS), 1);
D = struct('ds', ds, 'kds', kds, 'xend', xend, 'tr_pred', tr_pred, 'ds_ok', ds(ok), ...
           'kds_ok', kds(ok), 'local_exp', -local, 'e_obs', -p(1), 'd_um', K.D_UM, ...
           'kd_obs', K.KD_OBS, 'tr_obs', K.TR_OBS, 'tr_sem', K.TR_SEM, 'v_obs', K.V_OBS);
end

function D = dados_fig4_designcurve()
th = parametros_ajuste();
d50s = logspace(log10(0.5), log10(500), 60)';
t90 = zeros(size(d50s)); t96 = t90;
for j = 1:numel(d50s)
    r = simular_ajuste(d50s(j));
    t90(j) = interp_lim(0.90, r.X, r.t + th(5));
    t96(j) = interp_lim(0.96, r.X, r.t + th(5));
end
r = simular_ajuste(6.8);
D = struct('d50s', d50s, 't90', t90, 't96', t96, ...
           't68_96', interp_lim(0.96, r.X, r.t + th(5)), 'tind', th(5));
end

function D = dados_fig5_design()
K = constantes();
s = dimensionar_reator(1.0, 0.96, 1.0);
m_al = s.kg_Al * 1000;
ss = regime_permanente(6.8, 25.0, 0.5, 150);
b = simular_batelada(6.8, m_al, 4000, 1.0, 'span', 0.5, 't_end_min', 90, 'UA', 25, 'n_points', 900);
c = ss.cont;
D = struct('t_cont', c.t, 'flow_cont', c.flow, 'T_cont', c.T, 'boiloff', c.boiloff_g_min, ...
           'stoich', ss.esteq, 't_batch', b.t, 'flow_batch', max(b.flow, 1e-1), ...
           'feed', ss.F, 'm_al', m_al, 'demand', K.DEMANDA_ML_MIN, ...
           'ratio', ss.ratio, 'bo_ss', ss.boiloff);
end

function D = dados_fig5b_sensitivity()
K = constantes();
UAs = [8 10 15 20 25 30 35 40 45 48 50 51 52 55 60 70 85 100 130 170 220]';
ratios = zeros(size(UAs)); tmaxs = ratios;
for j = 1:numel(UAs)
    s = regime_permanente(6.8, UAs(j), 0.5);
    ratios(j) = s.ratio; tmaxs(j) = s.T_max;
end
Q_gen_W = 8.925 * K.DH_J_POR_G_AL / 60;     % calor gerado na alimentacao de 1 kW
D = struct('UAs', UAs, 'ratios', ratios, 'tmaxs', tmaxs, 'UA_crit', Q_gen_W / (K.T_EBUL_C - 55));
end

function D = dados_fig6_energy()
K = constantes();
phi = linspace(0, 1, 200)';
pb = phi_equilibrio(K.KWH_ELETROLISE);
D = struct('phi', phi, 'energy', energia_kg_h2(phi), 'co2', co2_kg_h2(phi), ...
           'phi_star', pb, 'e_elec', K.KWH_ELETROLISE, 'co2_star', co2_kg_h2(pb));
end

function D = dados_fig7_bayerloop()
K = constantes();
r = linspace(0, 1, 400)';
D = struct('r', r, 'phi_star', phi_equilibrio_ciclo(r, K.KWH_ELETROLISE), ...
           'r_crit', K.KWH_ELETROLISE / (K.KWH_KG_AL_RECICLO * K.AL_POR_H2));
end

function D = dados_fig8_cost()
K = constantes();
phi = linspace(0, 1, 200)'; rec = linspace(0, 1, 200)';
[~, c_al] = custo_kg_h2(phi);
D = struct('phi', phi, 'al_only', c_al, 'recovery', rec, 'cost_rec', custo_kg_h2(0.74, rec), ...
           'smr', K.CUSTO_SMR, 'topdown', K.CUSTO_TOPDOWN, 'al0', c_al(1));
end

function D = dados_figS1_designmap()
th = parametros_ajuste();
d50s = logspace(log10(2), log10(500), 22)';
taus = logspace(log10(0.5), log10(120), 22)';
Z = zeros(numel(taus), numel(d50s));
for j = 1:numel(d50s)
    r = simular_ajuste(d50s(j));
    Z(:, j) = interp_lim(taus, r.t + th(5), r.X, 0, r.X(end));
end
r = simular_ajuste(6.8);
D = struct('d50s', d50s, 'taus', taus, 'Z', Z, 't96', interp_lim(0.96, r.X, r.t + th(5)));
end
