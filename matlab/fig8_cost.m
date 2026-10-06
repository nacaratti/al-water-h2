function fig8_cost()
%FIG8_COST Figura 8 - custo por kg H2: aluminio vs SMR, e efeito da recuperacao de NaOH.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig8_cost');

fig = nova_figura(7.0, 3.0, 'Fig. 8 - custo');
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax = novo_eixo(tl);
plot(ax, D.phi, D.al_only, 'Color', C.fine, 'LineWidth', 2.0, 'DisplayName', 'aluminium feedstock only');
yline(ax, D.smr, '--', 'Color', C.mid, 'LineWidth', 1.3, ...
      'DisplayName', sprintf('steam methane reforming ($%.2f)', D.smr));
yline(ax, D.topdown, ':', 'Color', C.coarse, 'LineWidth', 1.3, ...
      'DisplayName', sprintf('Kaur & Verma top-down ($%.0f)', D.topdown));
plot(ax, 0, D.al0, 'o', 'Color', C.fine, 'MarkerFaceColor', C.fine, 'MarkerSize', 6, ...
     'HandleVisibility', 'off', 'Clipping', 'off');
ylim(ax, [0 30]);
xlabel(ax, 'external scrap fraction \phi (--)'); ylabel(ax, 'cost (US$ per kg H_2)');
titulo_esq(ax, {'(a) aluminium cost alone is', 'literature-consistent'});
legend(ax, 'Location', 'northeast', 'FontSize', 9);

ax = novo_eixo(tl); set(ax, 'YScale', 'log');
plot(ax, D.recovery, D.cost_rec, 'Color', C.mid, 'LineWidth', 2.0);
yline(ax, D.smr, '--', 'Color', C.grey, 'LineWidth', 1.1);
text(ax, 0.02, D.smr * 1.3, 'SMR benchmark', 'FontSize', 9, 'Color', C.grey, ...
     'VerticalAlignment', 'bottom');
xlabel(ax, 'NaOH recovery fraction (--)');
ylabel(ax, 'cost at \phi = 0.74 (US$ per kg H_2, log)');
titulo_esq(ax, {'(b) unrecovered NaOH dominates', 'by over an order of magnitude'});

salvar_figura(fig, 'fig8_cost');
end
