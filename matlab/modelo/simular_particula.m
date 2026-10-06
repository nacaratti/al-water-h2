function r = simular_particula(d_um, varargin)
%SIMULAR_PARTICULA Nivel 1 - integra uma particula esferica (nucleo nao reagido).
%
% Extensao esferica do modelo de nucleo nao reagido modificado de Martinez-Salazar et al.
% (Processes 2025, 13, 798), deduzido para placa plana. Mantem duas modificacoes:
%   M1  a casca de produto NAO conserva volume: vale n vezes o volume de nucleo consumido;
%   M2  a difusividade efetiva na casca cai a medida que a camada densifica.
% E acrescenta duas novidades:
%   N1  geometria esferica, para pos;
%   N2  resistencias difusional e quimica EM SERIE o tempo todo (regime misto), em vez da
%       troca curto/longo prazo da fonte. O regime misto e o que a escala k ~ d^-1.4 de
%       Martinez-Vargas et al. (Hydrogen 2026, 7, 55) implica.
%
% Densificacao (M2), escolhida por 'dens':
%   'time'  D = D0 / (1 + k_dens t)        -- como publicado, governada pelo relogio
%   'flux'  D = D0 / (1 + k_dens Gamma)    -- governada pelo produto depositado por area de
%                                            nucleo, Gamma = mol Al reagido / (4 pi rc^2)
%
% Uso:  r = simular_particula(d_um, 'n', 2.68, 'D0', ..., 'k1', ..., 'k_dens', ..., ...
%                             'dens', 'flux', 't_end_min', 3000, 'n_points', 4000)
% Saida: r.t [min], r.X [-], r.rate [1/min], r.R0 [cm], r.stalled (logico).
% A integracao para quando o nucleo se esgota ou quando a taxa cai abaixo de 'rate_floor'
% por minuto (o que acontece sob densificacao por fluxo quando a casca "estrangula" a reacao).
p = inputParser;
p.addParameter('n', 2.68); p.addParameter('D0', 1.37e-7); p.addParameter('k_dens', 2.49e-4);
p.addParameter('k1', 1e-4); p.addParameter('t_end_min', 120); p.addParameter('dens', 'time');
p.addParameter('n_points', 600); p.addParameter('rate_floor', 1e-7); p.addParameter('k_m', Inf);
p.parse(varargin{:}); o = p.Results;

R0 = (d_um * 1e-4) / 2;                 % diametro em um -> raio em cm
t_end = o.t_end_min * 60;
f = @(t, y) taxa_u(t, y, R0, o.n, o.D0, o.k_dens, o.k1, o.dens, o.k_m);
opts = odeset('RelTol', 1e-7, 'AbsTol', 1e-11, 'Events', @(t, y) eventos(t, y, f, o.rate_floor));
sol = ode15s(f, [0 t_end], 1.0, opts);

t_stop = sol.x(end);
if t_stop <= 0
    r = struct('t', 0, 'X', 0, 'rate', 0, 'R0', R0, 'stalled', false); return
end
% Reamostra numa malha que cobre o intervalo realmente integrado. Uma malha fixa sobre
% t_end perderia as particulas submicrometricas, que terminam em fracoes de segundo.
lg = logspace(log10(max(t_stop * 1e-6, 1e-9)), log10(t_stop), o.n_points);
lg(end) = t_stop;                       % evita que o arredondamento passe de t_stop
grade = unique([0, lg]);
u = min(max(deval(sol, grade), 0), 1);
X = 1 - u.^3;
t_min = grade / 60;
if numel(t_min) > 2
    rate = gradiente_np(X, t_min, 2);
else
    rate = zeros(size(X));
end
r.t = t_min(:); r.X = X(:); r.rate = rate(:); r.R0 = R0;
r.stalled = isfield(sol, 'ie') && any(sol.ie == 2);
end

function [val, term, dir] = eventos(t, y, f, rate_floor)
% 1) nucleo esgotado; 2) reacao estagnada: |dX/dt| (1/min) abaixo do piso
du = f(t, y);
val  = [y(1) - 1e-6; abs(3 * y(1)^2 * du) * 60 - rate_floor];
term = [1; 1];
dir  = [-1; -1];
end
