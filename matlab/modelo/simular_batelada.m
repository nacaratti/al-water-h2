function r = simular_batelada(d50_um, m_al_g, V_liq_mL, C_naoh_M, varargin)
%SIMULAR_BATELADA Nivel 2 - reator em batelada acoplado ao modelo de particula.
%
% Acopla o Nivel 1 a uma carga agitada pelos dois acoplamentos que o modelo de particula
% nao enxerga, e que o Nivel 1 apontou como a fisica ausente:
%   * balanco populacional sobre uma distribuicao log-normal de tamanhos (D50, span);
%   * consumo de NaOH -- o alcali e complexado como NaAl(OH)4 (Martinez-Vargas 2026, Eq. 5),
%     entao sua atividade cai com a conversao;
%   * balanco de energia com a exotermia (15-16 MJ por kg Al, Kaur & Verma) contra a
%     capacidade termica da carga e um coeficiente global de perdas UA, com ebulicao.
%
% A especie A do Nivel 1 e a AGUA (C_A0 = 55.5 M), nao o alcali. O NaOH e um promotor: entra
% como fator de atividade nas constantes de transporte e de superficie e e acompanhado pelo
% esgotamento, mas nao e o reagente limitante.
%
% Opcoes (nome/valor): 'T0_C' (55), 'theta', 'span' (0.6), 'n_bins' (14), 't_end_min' (120),
% 'UA' (0, W/K), 'adiabatico' (false), 'n_points' (1200), 'esgotar' (true), 'termico' (true).
% Saida: r.t [min], r.X, r.flow [mL/min], r.T [C], r.C_naoh [M], r.V_cum [mL], r.d_bins, r.w.
p = inputParser;
p.addParameter('T0_C', 55); p.addParameter('theta', []); p.addParameter('span', 0.6);
p.addParameter('n_bins', 14); p.addParameter('t_end_min', 120); p.addParameter('UA', 0);
p.addParameter('adiabatico', false); p.addParameter('n_points', 1200);
p.addParameter('esgotar', true); p.addParameter('termico', true);
p.parse(varargin{:}); o = p.Results;
K = constantes();
theta = o.theta; if isempty(theta), theta = parametros_ajuste(); end
D0 = 10^theta(1); k1 = 10^theta(2); k_dens = 10^theta(3); n_sh = theta(4); t_ind = theta(5);

[d, w] = classes_lognormal(d50_um, o.span, o.n_bins);
nb = o.n_bins;
R0 = (d * 1e-4) / 2;                      % cm
n_al = m_al_g / K.M_AL;                   % mol
C_naoh0 = C_naoh_M * 1e-3;                % mol/cm^3
V_liq = V_liq_mL; m_liq = V_liq;          % g, solucao aquosa diluida
T0_K = o.T0_C + 273.15;

    function dy = rhs(~, y)
        u = min(max(y(1:nb), 1e-9), 1);
        if o.termico, T = y(nb + 1); else, T = o.T0_C; end
        TK = T + 273.15;
        X_bulk = sum(w .* (1 - u.^3));
        if o.esgotar
            C_oh = max(C_naoh0 - K.NAOH_POR_AL * n_al * X_bulk / V_liq, 1e-12);
        else
            C_oh = C_naoh0;
        end
        f_oh = C_oh / C_naoh0;            % fator de atividade do alcali
        % Arrhenius na constante de superficie; Ea nao e identificavel de dados a uma so
        % temperatura, entao usamos o valor tipico da hidrolise alcalina do Al (premissa).
        f_T = exp(-K.EA_J / K.R_GAS * (1 / TK - 1 / T0_K));
        rc = u .* R0;
        rs = raio_casca(rc, R0, n_sh);
        gamma = (K.RHO_B * R0 / 3) .* (1 - u.^3) ./ u.^2;
        D_eff = D0 * f_T * f_oh ./ (1 + k_dens * gamma);
        R_dif = (1 ./ rc - 1 ./ rs) ./ (4 * pi * D_eff);
        R_rxn = 1 ./ (4 * pi * rc.^2 * k1 * f_T * f_oh);
        N_A = K.C_A0 ./ (R_dif + R_rxn);
        du = (-K.B_STOICH * N_A ./ (K.RHO_B * 4 * pi * rc.^2)) ./ R0;
        dX = sum(w .* (-3 * u.^2 .* du));                     % 1/s
        if o.termico
            q_gen = dX * m_al_g * K.DH_J_POR_G_AL;            % W
            if o.adiabatico, q_perda = 0; else, q_perda = o.UA * (T - o.T0_C); end
            % acima da ebulicao o excedente vira vaporizacao, nao calor sensivel
            if T >= K.T_EBUL_C && q_gen > q_perda
                dT = 0;
            else
                dT = (q_gen - q_perda) / (m_liq * K.CP_AGUA);
            end
        else
            dT = 0;
        end
        dy = [du; dT];
    end

y0 = [ones(nb, 1); o.T0_C];
sol = ode15s(@rhs, [0 o.t_end_min * 60], y0, odeset('RelTol', 1e-6, 'AbsTol', 1e-10));
grade = linspace(0, sol.x(end), o.n_points);
Y = deval(sol, grade);
u = min(max(Y(1:nb, :), 0), 1);
X = sum(w .* (1 - u.^3), 1)';
T = Y(nb + 1, :)';
t_min = grade(:) / 60 + t_ind;            % desloca pelo periodo de inducao
flow = gradiente_np(X, t_min, 2) * m_al_g * K.H2_ML_POR_G;
C_naoh = max(C_naoh_M - K.NAOH_POR_AL * n_al * X / (V_liq * 1e-3), 0);
r = struct('t', t_min, 'X', X, 'flow', flow, 'T', T, 'C_naoh', C_naoh, ...
           'V_cum', X * m_al_g * K.H2_ML_POR_G, 'd_bins', d, 'w', w);
end
