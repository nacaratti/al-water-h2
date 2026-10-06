function fig1_scales()
%FIG1_SCALES Figura 1 - esquema das tres escalas do modelo (particula, reator, sistema).
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos();

W = 7.2; GAP = 3.6;
x0s = [0.6, 0.6 + (W + GAP), 0.6 + 2 * (W + GAP)];
xl = [0, x0s(end) + W + 0.6]; yl = [0, 8.6];
fig = nova_figura(7.2, 7.2 * diff(yl) / diff(xl), 'Fig. 1 - escalas');
ax = axes(fig, 'Position', [0 0 1 1]); hold(ax, 'on');
axis(ax, 'equal'); xlim(ax, xl); ylim(ax, yl); axis(ax, 'off');

titulos = {'Particle', 'Reactor', 'System'};
itens = {{'shrinking core', 'series resistances', '{\itD}(\Gamma), induction'}, ...
         {'population balance', 'alkali activity', 'energy balance'}, ...
         {'scrap fraction \phi', 'kWh, CO_2, cost', 'Bayer loop'}};
icon_cy = 6.55;
for k = 1:3
    x0 = x0s(k); col = C.cols{k}; cx = x0 + W / 2;
    rectangle(ax, 'Position', [x0 0.9 W 6.7], 'Curvature', [0.24 / W, 0.24 / 6.7], ...
              'FaceColor', clarear(col, 0.045), 'EdgeColor', col, 'LineWidth', 1.5);
    switch k
        case 1, icone_particula(ax, cx, icon_cy, col);
        case 2, icone_reator(ax, cx, icon_cy, col);
        case 3, icone_sistema(ax, cx, icon_cy, col);
    end
    text(ax, cx, 4.95, titulos{k}, 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'FontWeight', 'bold', 'Color', col);
    plot(ax, [cx - 1.35, cx + 1.35], [4.55 4.55], 'Color', clarear(col, 0.4), 'LineWidth', 0.7);
    for i = 1:3
        text(ax, cx, 3.95 - 0.80 * (i - 1), itens{k}{i}, 'HorizontalAlignment', 'center', ...
             'FontSize', 8.4, 'Color', [0.13 0.13 0.13]);
    end
end

rotulos = {'{\itX}({\itt}), {\itd}_{50}', 'kg Al, kWh'};
for i = 1:2
    xa = x0s(i) + W + 0.45; xb = x0s(i + 1) - 0.45;
    seta(ax, [xa 3.75], [xb 3.75], C.grey, 1.6, 0.35);
    text(ax, (xa + xb) / 2, 4.20, rotulos{i}, 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', 'FontSize', 7.3, 'Color', C.grey);
end
salvar_figura(fig, 'fig1_scales');
end

% ---------------------------------------------------------------- icones
function circulo(ax, cx, cy, r, face, borda, lw)
rectangle(ax, 'Position', [cx - r, cy - r, 2 * r, 2 * r], 'Curvature', [1 1], ...
          'FaceColor', face, 'EdgeColor', borda, 'LineWidth', lw);
end

function icone_particula(ax, cx, cy, col)
r_out = 0.55; r_core = 0.5 * r_out;
circulo(ax, cx, cy, r_out, clarear(col, 0.18), col, 1.3);
circulo(ax, cx, cy, r_core, col, 'none', 0.5);
a = deg2rad(40);
x1 = cx + r_core * cos(a); y1 = cy + r_core * sin(a);
x2 = cx + r_out * cos(a);  y2 = cy + r_out * sin(a);
plot(ax, [x1 x2], [y1 y2], '--', 'Color', [0.2 0.2 0.2], 'LineWidth', 0.9);
text(ax, x2 + 0.10, y2 + 0.06, '{\itr_c}({\itt})', 'VerticalAlignment', 'bottom', ...
     'FontSize', 6.8, 'Color', [0.2 0.2 0.2]);
end

function icone_reator(ax, cx, cy, col)
w = 1.15; h = 1.15; base = cy - h / 2; topo = cy + h / 2;
rectangle(ax, 'Position', [cx - w / 2, base, w, h], 'Curvature', [0.2 / w, 0.2 / h], ...
          'FaceColor', clarear(col, 0.10), 'EdgeColor', col, 'LineWidth', 1.3);
rectangle(ax, 'Position', [cx - 0.46 * w, topo - 0.08, 0.92 * w, 0.16], 'Curvature', [1 1], ...
          'FaceColor', 'w', 'EdgeColor', col, 'LineWidth', 1.0);
plot(ax, [cx cx], [topo - 0.03, base + 0.18], 'Color', [0.2 0.2 0.2], 'LineWidth', 1.0);
plot(ax, [cx - 0.16, cx + 0.16], [base + 0.18, base + 0.18], 'Color', [0.2 0.2 0.2], 'LineWidth', 1.2);
bolhas = [-0.28 0.15 0.045; 0.05 0.42 0.032; 0.30 0.05 0.038];
for i = 1:3
    circulo(ax, cx + bolhas(i, 1), base + 0.35 + bolhas(i, 2), bolhas(i, 3), 'w', col, 0.7);
end
end

function icone_sistema(ax, cx, cy, col)
r = 0.55; th = deg2rad(linspace(20, 340, 120));
plot(ax, cx + r * cos(th), cy + r * sin(th), 'Color', col, 'LineWidth', 2.0);
a = deg2rad(340);
ponta = [cx + r * cos(a), cy + r * sin(a)];
tang = [-sin(a), cos(a)];
seta(ax, ponta, ponta + 0.22 * tang, col, 2.0, 0.22);
end

function seta(ax, p0, p1, cor, lw, tam_cabeca)
% Linha com cabeca triangular (coordenadas de dados; eixo com aspect ratio 1).
v = (p1 - p0) / norm(p1 - p0); n = [-v(2) v(1)];
base = p1 - tam_cabeca * v;
if norm(base - p0) > 0 && dot(base - p0, v) > 0
    plot(ax, [p0(1) base(1)], [p0(2) base(2)], 'Color', cor, 'LineWidth', lw);
end
tri = [p1; base + 0.45 * tam_cabeca * n; base - 0.45 * tam_cabeca * n];
patch(ax, tri(:, 1), tri(:, 2), cor, 'EdgeColor', 'none');
end
