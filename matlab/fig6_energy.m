function fig6_energy()
%FIG6_ENERGY Figura 6 - energia primaria e CO2 por kg H2 vs fracao de sucata.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig6_energy');

fig = nova_figura(7.0, 2.9, 'Fig. 6 - energia');
tl = tiledlayout(fig, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax = novo_eixo(tl);
plot(ax, D.phi, D.energy, 'Color', C.fine, 'LineWidth', 1.8, 'DisplayName', 'Al-water route');
yline(ax, D.e_elec, '--', 'Color', C.mid, 'LineWidth', 1.3, ...
      'DisplayName', sprintf('water electrolysis (%.1f)', D.e_elec));
xline(ax, D.phi_star, ':', 'Color', C.grey, 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot(ax, D.phi_star, D.e_elec, 'o', 'Color', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 5, ...
     'HandleVisibility', 'off');
yl = ylim(ax);
rotulo_seta(ax, [D.phi_star D.e_elec], [D.phi_star - 0.14, 0.15 * diff(yl)], ...
            sprintf('\\phi^{*} = %.2f', D.phi_star), 'HorizontalAlignment', 'right');
xlabel(ax, 'scrap fraction \phi (--)'); ylabel(ax, 'primary energy (kWh per kg H_2)');
titulo_esq(ax, '(a) energy break-even');
legend(ax, 'Location', 'northeast');

ax = novo_eixo(tl);
plot(ax, D.phi, D.co2, 'Color', C.coarse, 'LineWidth', 1.8);
xline(ax, D.phi_star, ':', 'Color', C.grey, 'LineWidth', 1.2);
yl = ylim(ax);
rotulo_seta(ax, [D.phi_star D.co2_star], [D.phi_star - 0.14, D.co2_star - 0.1 * diff(yl)], ...
            sprintf('at \\phi^{*}: %.0f kg CO_2', D.co2_star), 'HorizontalAlignment', 'right');
xlabel(ax, 'scrap fraction \phi (--)'); ylabel(ax, 'CO_2 (kg per kg H_2)');
titulo_esq(ax, '(b) carbon intensity');

salvar_figura(fig, 'fig6_energy');
end
