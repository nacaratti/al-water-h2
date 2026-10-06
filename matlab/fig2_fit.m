function fig2_fit()
%FIG2_FIT Figura 2 - ajuste do modelo de particula aos tres cortes granulometricos.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig2_fit');

fig = nova_figura(7.0, 2.9, 'Fig. 2 - ajuste');
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% (a) trajetoria de conversao
ax1 = novo_eixo(tl);
faixa(ax1, [0 D.tind], [0 1.05], C.grey, 0.12);
for i = 1:3
    t = D.(sprintf('t%d', i)); X = D.(sprintf('X%d', i));
    plot(ax1, t + D.tind, X, 'Color', C.cols{i}, 'LineWidth', 1.6, 'DisplayName', C.labels{i});
    xline(ax1, D.tr_obs(i), ':', 'Color', C.cols{i}, 'LineWidth', 1.0, 'HandleVisibility', 'off');
end
text(ax1, D.tind / 2, 0.55, 'induction', 'HorizontalAlignment', 'center', ...
     'Rotation', 90, 'FontSize', 9, 'Color', C.grey);
xlim(ax1, [0 40]); ylim(ax1, [0 1.05]);
xlabel(ax1, 'time (min)'); ylabel(ax1, 'conversion {\itX} (--)');
titulo_esq(ax1, '(a) conversion trajectory');
legend(ax1, 'Location', 'southeast');

% (b) linearizacao F_d(alpha) = k_d t
ax2 = novo_eixo(tl);
for i = 1:3
    plot(ax2, D.(sprintf('t%d', i)), D.(sprintf('Fd%d', i)), 'Color', C.cols{i}, ...
         'LineWidth', 1.6, 'DisplayName', C.labels{i});
    plot(ax2, D.(sprintf('tt%d', i)), D.(sprintf('kdt%d', i)), '--', 'Color', clarear(C.cols{i}, 0.75), ...
         'LineWidth', 0.8, 'HandleVisibility', 'off');
end
xlim(ax2, [0 25]);
xlabel(ax2, 'time after induction (min)'); ylabel(ax2, '{\itF_d}(\alpha)');
titulo_esq(ax2, '(b) linearisation (dashed: fitted {\itk_d t})');
legend(ax2, 'Location', 'southeast');

salvar_figura(fig, 'fig2_fit');
end
