function fig5_design()
%FIG5_DESIGN Figura 5 - (a) controle de carga com alimentacao continua; (b) temperatura
%e penalidade de agua por ebulicao.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig5_design');

fig = nova_figura(5.2, 7.4, 'Fig. 5 - reator');

% (a) vazao de H2: continuo (eixo linear) + batelada (inset log)
axA = axes(fig, 'Position', [0.13 0.585 0.80 0.36]);
hold(axA, 'on'); box(axA, 'on'); grid(axA, 'on');
plot(axA, D.t_cont, D.flow_cont, 'Color', C.fine, 'LineWidth', 1.9, ...
     'DisplayName', sprintf('continuous, %.1f g min^{-1}', D.feed));
yline(axA, D.demand, '-.', 'Color', C.grey, 'LineWidth', 1.3, 'HandleVisibility', 'off');
text(axA, 148, D.demand * 1.06,  '1 kW demand', 'Color', C.grey, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
xlim(axA, [0 150]); ylim(axA, [0 D.demand * 1.6]);
xlabel(axA, 'time (min)'); ylabel(axA, 'H_2 flow (mL min^{-1})');
titulo_esq(axA, '(a) duty control: continuous feed holds demand');
legend(axA, 'Location', 'northwest');

p = axA.Position;
axI = axes(fig, 'Position', [p(1) + 0.42 * p(3), p(2) + 0.17 * p(4), 0.54 * p(3), 0.34 * p(4)]);
hold(axI, 'on'); box(axI, 'on'); grid(axI, 'on');
set(axI, 'YScale', 'log', 'FontSize', 10);
plot(axI, D.t_batch, D.flow_batch, 'Color', C.mid, 'LineWidth', 1.4);
yline(axI, D.demand, '-.', 'Color', C.grey, 'LineWidth', 1.0);
xlim(axI, [0 60]); ylim(axI, [1e0 1e7]);
title(axI, sprintf('batch, %.0f g Al', D.m_al), 'FontSize', 9, 'FontWeight', 'normal');
xlabel(axI, 'time (min)', 'FontSize', 9); ylabel(axI, 'mL min^{-1} (log)', 'FontSize', 9);

% (b) temperatura (esquerda) e balanco de agua (direita)
axB = axes(fig, 'Position', [0.13 0.075 0.72 0.36]);
hold(axB, 'on'); box(axB, 'on'); grid(axB, 'on');
yyaxis(axB, 'left'); hold(axB, 'on');
plot(axB, D.t_cont, D.T_cont, '-', 'Color', C.mid, 'LineWidth', 1.9, 'DisplayName', 'temperature');
yline(axB, 100, '--', 'Color', C.grey, 'LineWidth', 1.0, 'HandleVisibility', 'off');
text(axB, 148, 100.5, 'boiling', 'FontSize', 9, 'Color', C.grey, ...
     'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
ylim(axB, [55 105]);
ylabel(axB, 'temperature (^{\circ}C)');
yyaxis(axB, 'right'); hold(axB, 'on');
plot(axB, D.t_cont, D.stoich, '--', 'Color', C.coarse, 'LineWidth', 1.7, ...
     'DisplayName', 'stoichiometric water');
plot(axB, D.t_cont, D.boiloff, '-', 'Color', C.fine, 'LineWidth', 1.9, 'DisplayName', 'boil-off water');
ylim(axB, [0 max(D.boiloff) * 1.3]);
ylabel(axB, 'water demand (g min^{-1})');
ylr = ylim(axB);
rotulo_seta(axB, [60 D.bo_ss], [45, 0.62 * ylr(2)], ...
            sprintf('boil-off / stoichiometric \\approx %.1f\\times', D.ratio));
axB.YAxis(1).Color = C.mid; axB.YAxis(2).Color = C.fine;
xlim(axB, [0 150]); xlabel(axB, 'time (min)');
titulo_esq(axB, '(b) thermal response sets the water penalty');
legend(axB, 'Location', 'south');

salvar_figura(fig, 'fig5_design');
end
