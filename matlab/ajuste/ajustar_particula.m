function [theta, perr, info] = ajustar_particula(dens, n_fixo, x0)
%AJUSTAR_PARTICULA Ajuste local (lsqnonlin, regiao de confianca reflexiva) do modelo de
%particula a kd e tr de Martinez-Vargas et al. (2026).
%
%   [theta, perr, info] = ajustar_particula('flux', true)   % n fixo em 2.68 (4 parametros)
%   [theta, perr, info] = ajustar_particula('time', false)  % 5 parametros, n livre
%
% theta devolvido sempre com 5 elementos [log10 D0, log10 k1, log10 k_dens, n, t_ind];
% perr = desvios-padrao dos parametros livres a partir do jacobiano (s^2 (J'J)^-1).
% info.chi2, info.J (jacobiano), info.res.
% Requer Optimization Toolbox (lsqnonlin).
if nargin < 1, dens = 'time'; end
if nargin < 2, n_fixo = false; end
K = constantes();
if n_fixo
    if nargin < 3, x0 = [log10(7e-7), log10(1.2e-4), log10(5e-4), 9.0]; end
    lb = [-12 -9 -8 0]; ub = [-3 1 2 25]; tol = 1e-15; maxf = 4000;
else
    if nargin < 3, x0 = [log10(1.37e-7), log10(1e-4), log10(2.49e-4), 2.68, 8.0]; end
    lb = [-12 -9 -8 1.05 0]; ub = [-3 1 2 6 25]; tol = 1e-14; maxf = 3000;
end
opts = optimoptions('lsqnonlin', 'Display', 'off', 'FunctionTolerance', tol, ...
                    'StepTolerance', tol, 'MaxFunctionEvaluations', maxf);
[x, chi2, res, ~, ~, ~, J] = lsqnonlin(@(p) residuos_particula(p, dens), x0, lb, ub, opts);
J = full(J);
gl = max(numel(res) - numel(x), 1);
s2 = chi2 / gl;
perr = sqrt(abs(diag(inv(J' * J) * s2)))';
if n_fixo
    theta = [x(1), x(2), x(3), K.N_FIXO, x(4)];
else
    theta = x;
end
info = struct('chi2', chi2, 'J', J, 'res', res, 'x', x);
end
