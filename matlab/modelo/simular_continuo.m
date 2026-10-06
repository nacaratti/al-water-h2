function r = simular_continuo(d50_um, alim_g_min, varargin)
%SIMULAR_CONTINUO Alimentacao continua de po a taxa constante num reator agitado.
%
% Cada parcela carregada no instante s produz o volume acumulado V(t-s) ate o instante t;
% a producao acumulada do reator e a convolucao da taxa de alimentacao com V (nao com a
% vazao -- ver rendimento_especifico). A vazao e obtida derivando essa curva suave, de modo
% que em regime ela converge exatamente para alimentacao * V(infinito).
%
% E o modo de operacao que torna a carga controlavel: uma batelada grande o bastante para
% servir 1 kW por uma hora libera seu hidrogenio num unico pico incontrolavel.
% O balanco de energia e integrado junto, com ebulicao explicita: acima de 100 C o calor
% excedente vira vaporizacao, o que define a necessidade de agua de reposicao.
%
% Opcoes: 'duracao_min' (120), 'span' (0.5), 'theta', 'V_liq_mL' (4000), 'T0_C' (55),
% 'UA' (25 W/K), 'n_points' (1500).
p = inputParser;
p.addParameter('duracao_min', 120); p.addParameter('span', 0.5); p.addParameter('theta', []);
p.addParameter('V_liq_mL', 4000); p.addParameter('T0_C', 55); p.addParameter('UA', 25);
p.addParameter('n_points', 1500);
p.parse(varargin{:}); o = p.Results;
K = constantes();
theta = o.theta; if isempty(theta), theta = parametros_ajuste(); end
t_ind = theta(5);

[tau, V] = rendimento_especifico(d50_um, o.span, theta);
t = linspace(0, o.duracao_min, o.n_points)';
dt = t(2) - t(1);
V_t = interp_lim(t, tau, V, 0, V(end));
nucleo = alim_g_min * dt * ones(numel(t), 1);     % gramas carregados por intervalo
V_bruto = conv(nucleo, V_t);
V_bruto = V_bruto(1:numel(t));
% cada parcela so produz depois do periodo de inducao comum
V_cum = interp_lim(t, t + t_ind, V_bruto, 0, []);
flow = gradiente_np(V_cum, t, 2);

% balanco de energia
m_liq = o.V_liq_mL;
T = zeros(size(t)); T(1) = o.T0_C;
ferv = zeros(size(t));
taxa_al = flow / K.H2_ML_POR_G;                   % g Al reagido por min
for i = 2:numel(t)
    q_gen = taxa_al(i - 1) * K.DH_J_POR_G_AL / 60;     % W
    q_perda = o.UA * (T(i - 1) - o.T0_C);
    liq = q_gen - q_perda;
    if T(i - 1) >= K.T_EBUL_C && liq > 0
        T(i) = K.T_EBUL_C;
        ferv(i) = liq / K.LATENTE_J_G * 60;        % g/min
    else
        T(i) = min(T(i - 1) + liq / (m_liq * K.CP_AGUA) * dt * 60, K.T_EBUL_C);
    end
end
r = struct('t', t, 'flow', flow, 'T', T, 'boiloff_g_min', ferv, ...
           'fed_g', alim_g_min * t, 'V_cum', V_cum);
end
