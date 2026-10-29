function fig8_cost()
%FIG8_COST Figura 9 - custo de insumos por kg H2: aluminio e NaOH (preco de commodity,
%Baral et al. 2025) vs SMR, e efeito da recuperacao de NaOH em phi* = 0.74.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig8_cost');

fig = nova_figura(7.0, 3.0, 'Fig. 9 - custo');
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% (a) custo vs fracao de sucata
ax = novo_eixo(tl);
plot(ax, D.phi, D.al_naoh, 'Color', C.mid, 'LineWidth', 2.0, 'DisplayName', 'aluminium + fresh NaOH');
plot(ax, D.phi, D.al_only, 'Color', C.fine, 'LineWidth', 2.0, 'DisplayName', 'aluminium only');
yline(ax, D.topdown, ':', 'Color', C.coarse, 'LineWidth', 1.3, ...
      'DisplayName', sprintf('Kaur & Verma top-down ($%.0f)', D.topdown));
yline(ax, D.smr, '--', 'Color', C.grey, 'LineWidth', 1.3, ...
      'DisplayName', sprintf('steam methane reforming ($%.2f)', D.smr));
plot(ax, 0, D.al0, 'o', 'Color', C.fine, 'MarkerFaceColor', C.fine, 'MarkerSize', 6, ...
     'HandleVisibility', 'off', 'Clipping', 'off');
ylim(ax, [0 32]);
xlabel(ax, 'external scrap fraction \phi (--)'); ylabel(ax, 'feedstock cost (US$ per kg H_2)');
titulo_esq(ax, {'(a) aluminium sets the', 'feedstock floor'});
legend(ax, 'Location', 'northeast', 'FontSize', 8.5);

% (b) custo em phi* vs fracao de NaOH recuperada
ax = novo_eixo(tl);
plot(ax, D.recovery, D.cost_rec_regen, '-', 'Color', C.mid, 'LineWidth', 2.0, ...
     'DisplayName', 'recovered NaOH at $363 t^{-1}');
plot(ax, D.recovery, D.cost_rec_free, '-', 'Color', C.fine, 'LineWidth', 2.0, ...
     'DisplayName', 'recovered NaOH free');
yline(ax, D.al_star, ':', 'Color', C.fine, 'LineWidth', 1.2, 'HandleVisibility', 'off');
text(ax, 0.98, D.al_star - 0.25, 'aluminium-only floor', 'FontSize', 9, 'Color', C.fine, ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right');
yline(ax, D.smr, '--', 'Color', C.grey, 'LineWidth', 1.3, 'HandleVisibility', 'off');
text(ax, 0.02, D.smr + 0.25, 'SMR benchmark', 'FontSize', 9, 'Color', C.grey, ...
     'VerticalAlignment', 'bottom');
ylim(ax, [0 17]);
xlabel(ax, 'NaOH recovery fraction (--)');
ylabel(ax, 'cost at \phi = 0.74 (US$ per kg H_2)');
titulo_esq(ax, {'(b) NaOH recovery is worth at most', sprintf('US$%.1f per kg H_2', D.naoh_star)});
lg = legend(ax, 'FontSize', 8.5);
drawnow;                                   % legenda na faixa livre entre o piso do Al e o SMR
p = ax.Position;
lg.Position(1:2) = [p(1) + p(3) - lg.Position(3) - 0.01, p(2) + 0.25 * p(4)];

salvar_figura(fig, 'fig8_cost');
end
