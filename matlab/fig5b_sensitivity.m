function fig5b_sensitivity()
%FIG5B_SENSITIVITY Penalidade de agua vs coeficiente de perda termica UA (limiar UA_crit).
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig5b_sensitivity');

fig = nova_figura(4.6, 3.4, 'Fig. 5b - sensibilidade UA');
ax = novo_eixo(fig); set(ax, 'XScale', 'log');
yyaxis(ax, 'left'); hold(ax, 'on');
plot(ax, D.UAs, D.ratios, 'o-', 'Color', C.mid, 'MarkerFaceColor', C.mid, 'LineWidth', 1.8, ...
     'MarkerSize', 5);
xline(ax, D.UA_crit, ':', 'Color', C.grey, 'LineWidth', 1.3);
xline(ax, 25, '--', 'Color', C.fine, 'LineWidth', 1.2);
text(ax, 25 * 0.86, max(D.ratios) * 0.55, {'reference', 'case'}, 'FontSize', 9, ...
     'Color', C.fine, 'HorizontalAlignment', 'right');
rotulo_seta(ax, [D.UA_crit 0.3], [D.UA_crit * 1.15, 0.3 + 0.25 * max(D.ratios)], ...
            sprintf('{\\itUA}_{crit} = %.0f W K^{-1}', D.UA_crit));
xlabel(ax, 'heat-loss coefficient {\itUA} (W K^{-1})');
ylabel(ax, 'boil-off / stoichiometric water');
yyaxis(ax, 'right'); hold(ax, 'on');
plot(ax, D.UAs, D.tmaxs, 's--', 'Color', C.coarse, 'MarkerFaceColor', C.coarse, ...
     'LineWidth', 1.5, 'MarkerSize', 4.5);
yline(ax, 100, ':', 'Color', C.grey, 'LineWidth', 1.0);
ylabel(ax, 'peak temperature (^{\circ}C)');
ax.YAxis(1).Color = C.mid; ax.YAxis(2).Color = C.coarse;
titulo_esq(ax, 'Water penalty is a threshold, not a gradient');
salvar_figura(fig, 'fig5b_sensitivity');
end
