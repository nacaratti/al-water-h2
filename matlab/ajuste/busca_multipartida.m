%BUSCA_MULTIPARTIDA Busca global dos parametros do Nivel 1 (a superficie de residuos e
%multimodal): 60 pontos de partida aleatorios, n fixo em 2.68, densificacao por fluxo.
%
% Grava o melhor theta em ../dados/parametros_ajuste.mat (usado por todas as figuras).
% Leva alguns minutos. Os pontos de partida aleatorios nao sao os mesmos da versao original
% do estudo, entao o otimo encontrado pode diferir ligeiramente do que esta salvo.
% Requer Optimization Toolbox.
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
K = constantes();
rng(20260902);
LO = [-9 -7 -8 0]; HI = [-4 -2 2 25];
opts = optimoptions('lsqnonlin', 'Display', 'off', 'FunctionTolerance', 1e-13, ...
                    'StepTolerance', 1e-13, 'MaxFunctionEvaluations', 600);
linhas = zeros(0, 6);           % [chi2, x(1:4), expoente]
for i = 1:60
    x0 = LO + rand(1, 4) .* (HI - LO);
    try
        [x, chi2] = lsqnonlin(@(p) residuos_particula(p, 'flux'), x0, LO, HI, opts);
    catch
        continue
    end
    th = [x(1:3), K.N_FIXO, x(4)];
    kd = prever_particula(th, 'flux');
    if ~all(isfinite(kd)), continue, end
    pf = polyfit(log(K.D_UM), log(kd), 1);
    linhas(end + 1, :) = [chi2, x, pf(1)]; %#ok<AGROW>
    fprintf('  partida %2d: chi2 = %9.3f\n', i, chi2);
end
linhas = sortrows(linhas, 1);
fprintf('\n%d partidas convergiram; as cinco melhores:\n', size(linhas, 1));
for i = 1:min(5, size(linhas, 1))
    x = linhas(i, 2:5);
    fprintf('  chi2=%9.3f  D0=%.3e  k1=%.3e  k_dens=%.3e  t_ind=%5.2f  expoente=%+.3f\n', ...
            linhas(i, 1), 10^x(1), 10^x(2), 10^x(3), x(4), linhas(i, 6));
end
x = linhas(1, 2:5);
theta = [x(1:3), K.N_FIXO, x(4)];
[kd, tr] = prever_particula(theta, 'flux');
r2 = @(o, p) 1 - sum((o - p).^2) / sum((o - mean(o)).^2);
pobs = polyfit(log(K.D_UM), log(K.KD_OBS), 1);
fprintf('\nMELHOR GLOBAL  chi2=%.3f\n', linhas(1, 1));
fprintf('  kd prev %s  obs %s  R2=%.4f\n', mat2str(kd', 4), mat2str(K.KD_OBS', 4), r2(K.KD_OBS, kd));
fprintf('  tr prev %s  obs %s  R2=%.4f\n', mat2str(tr', 4), mat2str(K.TR_OBS', 4), r2(K.TR_OBS, tr));
fprintf('  expoente %+.3f  (obs %+.3f)\n', linhas(1, 6), pobs(1));

arq = fullfile(aqui, '..', 'dados', 'parametros_ajuste.mat');
S = load(arq);
S.theta = theta;
save(arq, '-struct', 'S');
fprintf('theta gravado em %s\n', arq);
