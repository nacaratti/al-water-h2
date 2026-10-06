function fig7_bayerloop()
%FIG7_BAYERLOOP Figura 7 - fracao de sucata de equilibrio vs fechamento do ciclo Bayer r.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig7_bayerloop');

fig = nova_figura(4.6, 3.5, 'Fig. 7 - ciclo Bayer');
ax = novo_eixo(fig);
faixa(ax, [D.r_crit 1], [0 1.05], C.mid, 0.08);
plot(ax, D.r, D.phi_star, 'Color', C.fine, 'LineWidth', 2.0);
xline(ax, D.r_crit, '--', 'Color', C.mid, 'LineWidth', 1.3);
text(ax, (D.r_crit + 1) / 2, 0.5, {'unreachable', 'at any \phi'}, ...
     'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', C.mid);
rotulo_seta(ax, [D.r_crit 0.08], [D.r_crit + 0.05, 0.16], ...
            sprintf('{\\itr}_{crit} = %.2f', D.r_crit), 'FontSize', 10, 'VerticalAlignment', 'bottom');
xlim(ax, [0 1]); ylim(ax, [0 1.05]);
xlabel(ax, 'Bayer-loop closure {\itr} (--)');
ylabel(ax, 'break-even external scrap fraction \phi^{*}');
titulo_esq(ax, {'Closing the reaction''s own loop is not a', 'substitute for external scrap'});
salvar_figura(fig, 'fig7_bayerloop');
end
