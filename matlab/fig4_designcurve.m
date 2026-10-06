function fig4_designcurve()
%FIG4_DESIGNCURVE Figura 4 - tempo para atingir X = 0,90 e 0,96 vs diametro mediano.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig4_designcurve');

fig = nova_figura(4.6, 3.6, 'Fig. 4 - curva de projeto');
ax = novo_eixo(fig); set(ax, 'XScale', 'log');
yl = [0, ceil(max([D.t90; D.t96]) * 1.1)];
faixa(ax, [0.5 500], [0 D.tind], C.grey, 0.15);
text(ax, 0.7, D.tind * 0.45, sprintf('induction period (%.1f min)', D.tind), ...
     'FontSize', 9, 'Color', C.grey);
plot(ax, D.d50s, D.t96, '-', 'Color', C.acc, 'LineWidth', 1.9, 'DisplayName', '{\itX} = 0.96');
plot(ax, D.d50s, D.t90, '--', 'Color', C.fine, 'LineWidth', 1.9, 'DisplayName', '{\itX} = 0.90');
plot(ax, 6.8, D.t68_96, 'p', 'MarkerSize', 15, 'MarkerFaceColor', C.mid, ...
     'MarkerEdgeColor', 'k', 'LineWidth', 0.6, 'HandleVisibility', 'off');
rotulo_seta(ax, [6.8 D.t68_96], [6.8 * 2.2, D.t68_96 + 0.12 * diff(yl)], ...
            {'ball-milled {\itD}_{50} = 6.8 \mum', sprintf('{\\itt}_{0.96} = %.1f min', D.t68_96)}, ...
            'VerticalAlignment', 'bottom');
xlim(ax, [0.5 500]); ylim(ax, yl);
xlabel(ax, 'median diameter {\itd}_{50} (\mum)');
ylabel(ax, 'time to reach conversion (min)');
titulo_esq(ax, 'Residence time required vs particle size');
legend(ax, 'Location', 'northwest');
salvar_figura(fig, 'fig4_designcurve');
end
