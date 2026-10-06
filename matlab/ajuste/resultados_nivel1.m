%RESULTADOS_NIVEL1 Conjunto consolidado de resultados do Nivel 1 (escala de particula),
%gravado em ../dados/resultados_nivel1.json.
%
% O ajuste de referencia usa SO os observaveis independentes da massa (kd e tr), porque a
% massa de aluminio carregada nao e informada pela fonte (../../data/notes.md). Qmax e V_cum
% ficam de fora como testes cegos do modelo de particula -- e ambos falham, o que motiva os
% Niveis 2 e 3. Requer Optimization Toolbox (para a estimativa de erro).
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
K = constantes();
r2 = @(o, p) 1 - sum((o - p).^2) / sum((o - mean(o)).^2);

theta = parametros_ajuste();                   % otimo global de busca_multipartida.m
[~, perr] = ajustar_particula('flux', true);   % reajuste local, so para a estimativa de erro
[kd_p, tr_p] = prever_particula(theta, 'flux');
pp = polyfit(log(K.D_UM), log(kd_p), 1); po = polyfit(log(K.D_UM), log(K.KD_OBS), 1);

% --- testes cegos: nem Qmax nem V_cum entraram no ajuste -----------------------------
q_g = zeros(3, 1); X_fim = q_g;
for i = 1:3
    r = simular_ajuste(K.D_UM(i), theta, 3000, 4000);
    q_g(i) = max(r.rate); X_fim(i) = r.X(end);
end
m_impl = K.V_OBS / K.H2_ML_POR_G;              % g, na leitura de conversao completa
Q_p = q_g .* m_impl * K.H2_ML_POR_G;

out.fit = struct('D0_cm2_s', 10^theta(1), 'k1_cm_s', 10^theta(2), 'k_dens', 10^theta(3), ...
    'n_shell_fixed', theta(4), 't_ind_min', theta(5), 'log10_D0_err', perr(1), ...
    't_ind_err_min', perr(4), 'chi2', sum(residuos_particula(theta, 'flux').^2));
out.kd = struct('pred', kd_p, 'obs', K.KD_OBS, 'R2', r2(K.KD_OBS, kd_p));
out.tr = struct('pred', tr_p, 'obs', K.TR_OBS, 'R2', r2(K.TR_OBS, tr_p));
out.size_exponent = struct('pred', pp(1), 'obs', po(1), 'paper_quotes', -1.4);
out.blind_Qmax = struct('pred', Q_p, 'obs', K.Q_OBS, 'R2', r2(K.Q_OBS, Q_p), ...
                        'ratio_pred_over_obs', Q_p ./ K.Q_OBS);
out.blind_final_conversion = struct('pred', X_fim, 'note', 'complete for every size -> no V_cum optimum');
out.implied_mass_g = m_impl;
fid = fopen(fullfile(aqui, '..', 'dados', 'resultados_nivel1.json'), 'w');
fprintf(fid, '%s', jsonencode(out, 'PrettyPrint', true)); fclose(fid);

fprintf('D0     = %.3e cm2/s  (log10 +/- %.2f)\n', 10^theta(1), perr(1));
fprintf('k_dens = %.3g\n', 10^theta(3));
fprintf('k1     = %.3e cm/s\n', 10^theta(2));
fprintf('t_ind  = %.2f +/- %.2f min\n', theta(5), perr(4));
fprintf('kd  R2 = %.4f   prev %s\n', out.kd.R2, mat2str(kd_p', 4));
fprintf('tr  R2 = %.4f   prev %s\n', out.tr.R2, mat2str(tr_p', 4));
fprintf('expoente prev %.3f vs obs %.3f\n', pp(1), po(1));
fprintf('CEGO Qmax  R2 = %.3f  fator de superestimativa %s\n', out.blind_Qmax.R2, mat2str((Q_p ./ K.Q_OBS)', 3));
fprintf('CEGO X_fim = %s  -> sem otimo de rendimento acumulado\n', mat2str(X_fim', 5));
fprintf('gravado dados/resultados_nivel1.json\n');
