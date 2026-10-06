function ajuste_conjunto()
%AJUSTE_CONJUNTO Ajuste conjunto aos TRES observaveis de Martinez-Vargas et al. 2026:
%constante aparente kd, tempo de reacao tr e vazao de pico Qmax.
%
% Qmax exige a massa de aluminio carregada, que a fonte nao informa. Por isso ajusta-se
% sob as duas leituras mutuamente exclusivas do artigo (ver ../../data/notes.md):
%   A  a conversao e completa (Sec. 2 da fonte) e os volumes acumulados diferentes sao massas
%      diferentes:  m_i = V_i / 1245 g;
%   B  a massa e comum a todas as corridas (Secs. 3-5) e os volumes diferentes sao um limite
%      real de passivacao dependente do tamanho; a massa comum vira parametro livre.
% Cada corte de peneira e integrado sobre sua largura real (180-250, 300-425, 425-500 um),
% pois a vazao de pico de uma carga polidispersa nao e a da sua particula media.
% Grava theta_conjunto_A/B em ../dados/parametros_ajuste.mat. Requer Optimization Toolbox.
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
K = constantes();
r2 = @(o, p) 1 - sum((o - p).^2) / sum((o - mean(o)).^2);
arq = fullfile(aqui, '..', 'dados', 'parametros_ajuste.mat');
S = load(arq);
for interp = {'A', 'B'}
    interp = interp{1}; %#ok<FXSET>
    x0 = [log10(8.4e-7), log10(1.2e-4), log10(5e-4), 9.0, log10(3e-4)];
    lo = [-12 -9 -8 0 -8]; hi = [-3 1 2 25 1];
    if interp == 'B'
        x0 = [x0, log10(0.1)]; lo = [lo, -3]; hi = [hi, 1];
    end
    opts = optimoptions('lsqnonlin', 'Display', 'off', 'FunctionTolerance', 1e-13, ...
                        'StepTolerance', 1e-13, 'MaxFunctionEvaluations', 400);
    [x, chi2, res] = lsqnonlin(@(p) residuos(p, interp, K), x0, lo, hi, opts);
    m_c = []; if interp == 'B', m_c = 10^x(6); end
    [kd, tr, Q, V] = prever(x(1:5), interp, m_c, K);
    nd = numel(res); gl = max(nd - numel(x), 1);
    fprintf('\n########## Interpretacao %s ##########\n', interp);
    fprintf('  D0=%.3e cm2/s  k1=%.3e cm/s  k_dens=%.3e  t_ind=%.2f min  k_m=%.3e cm/s', ...
            10^x(1), 10^x(2), 10^x(3), x(4), 10^x(5));
    if interp == 'B', fprintf('  m_comum=%.4f g', m_c); end
    fprintf('\n  chi2 = %.2f em %d pontos (%d gl) -> reduzido %.2f\n', chi2, nd, gl, chi2 / gl);
    fprintf('  kd   prev %s  obs %s  R2=%.4f\n', mat2str(kd', 4), mat2str(K.KD_OBS'), r2(K.KD_OBS, kd));
    fprintf('  tr   prev %s  obs %s  R2=%.4f\n', mat2str(tr', 4), mat2str(K.TR_OBS'), r2(K.TR_OBS, tr));
    fprintf('  Qmax prev %s  obs %s  R2=%.4f\n', mat2str(Q', 4), mat2str(K.Q_OBS'), r2(K.Q_OBS, Q));
    fprintf('  Vcum prev %s  obs %s  R2=%.4f\n', mat2str(V', 4), mat2str(K.V_OBS'), r2(K.V_OBS, V));
    S.(['theta_conjunto_' interp]) = x;
end
save(arq, '-struct', 'S');
end

function [t, X, rate] = resposta_corte(lo, hi, theta)
% resposta ponderada em massa de um corte de peneira (9 pontos de quadratura)
n_sub = 9; t_end = 3000; npts = 2500;
ds = linspace(lo, hi, n_sub);
w = ds.^3; w = w / sum(w);              % peneiramento uniforme em numero -> massa ~ d^3
runs = cell(1, n_sub);
for i = 1:n_sub
    runs{i} = simular_particula(ds(i), 'n', 2.68, 'D0', 10^theta(1), 'k1', 10^theta(2), ...
        'k_dens', 10^theta(3), 'k_m', 10^theta(5), 't_end_min', t_end, 'dens', 'flux', 'n_points', npts);
end
t = linspace(0, max(cellfun(@(r) r.t(end), runs)), npts)';
X = zeros(size(t));
for i = 1:n_sub
    X = X + w(i) * interp_lim(t, runs{i}.t, runs{i}.X, [], runs{i}.X(end));
end
rate = gradiente_np(X, t, 2);
end

function [kd, tr, Q, V] = prever(theta, interp, m_comum, K)
kd = zeros(3, 1); tr = kd; q = kd; X_fim = kd;
for i = 1:3
    [t, X, rate] = resposta_corte(K.PENEIRA(i, 1), K.PENEIRA(i, 2), theta);
    kd(i) = kd_aparente(t, X);
    tr(i) = tempo_reacao(struct('t', t, 'X', X), theta(4));
    q(i) = max(rate);                   % por grama, 1/min
    X_fim(i) = X(end);
end
if interp == 'A'
    m = K.V_OBS / K.H2_ML_POR_G;        % conversao completa
else
    m = m_comum * ones(3, 1);
end
Q = q .* m * K.H2_ML_POR_G;             % mL/min
V = X_fim .* m * K.H2_ML_POR_G;
end

function res = residuos(p, interp, K)
m_c = []; if interp == 'B', m_c = 10^p(6); end
[kd, tr, Q, V] = prever(p(1:5), interp, m_c, K);
if ~all(isfinite(kd))
    res = 1e3 * ones(9 + 3 * (interp == 'B'), 1); return
end
res = [(kd - K.KD_OBS) ./ K.KD_SEM; (tr - K.TR_OBS) ./ K.TR_SEM; (Q - K.Q_OBS) ./ K.Q_SEM];
if interp == 'B'
    res = [res; (V - K.V_OBS) ./ (0.05 * K.V_OBS)];
end
end
