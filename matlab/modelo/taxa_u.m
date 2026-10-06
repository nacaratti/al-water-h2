function du = taxa_u(t, y, R0, n, D0, k_dens, k1, dens, k_m)
%TAXA_U du/dt para u = rc/R0 (adimensional), evitando a rigidez de seguir rc diretamente.
if nargin < 9, k_m = Inf; end
K = constantes();
u = y(1);
if u <= 1e-9
    du = 0; return
end
rc = u * R0;
rs = raio_casca(rc, R0, n);
switch dens
    case 'time'
        D_eff = D0 / (1 + k_dens * t);
    case 'flux'
        % Gamma = mol Al reagido por area ATUAL de nucleo = (rho_B R0 / 3)(1 - u^3)/u^2
        gamma = (K.RHO_B * R0 / 3) * (1 - u^3) / u^2;
        D_eff = D0 / (1 + k_dens * gamma);
    otherwise
        error('lei de densificacao desconhecida: %s', dens);
end
R_dif = (1 / rc - 1 / rs) / (4 * pi * D_eff);
R_rxn = 1 / (4 * pi * rc^2 * k1);
% Resistencia de filme liquido externo. Martinez-Salazar et al. a descartam; e seguro para
% uma placa de 0.15 mm, mas nao para um po fino, cuja area especifica e ordens de grandeza
% maior: e o filme que limita a explosao inicial.
if isfinite(k_m)
    R_filme = 1 / (4 * pi * rs^2 * k_m);
else
    R_filme = 0;
end
N_A = K.C_A0 / (R_dif + R_rxn + R_filme);          % mol A / s
drc = -K.B_STOICH * N_A / (K.RHO_B * 4 * pi * rc^2);
du = drc / R0;
end
