function r = simular_ajuste(d_um, theta, t_end, npts)
%SIMULAR_AJUSTE Simula uma particula com os parametros ajustados (densificacao por fluxo).
% theta = [log10 D0, log10 k1, log10 k_dens, n, t_ind]; padrao: parametros_ajuste.mat.
if nargin < 2 || isempty(theta), theta = parametros_ajuste(); end
if nargin < 3, t_end = 3000; end
if nargin < 4, npts = 4000; end
r = simular_particula(d_um, 'n', theta(4), 'D0', 10^theta(1), 'k1', 10^theta(2), ...
                      'k_dens', 10^theta(3), 't_end_min', t_end, 'dens', 'flux', 'n_points', npts);
end
