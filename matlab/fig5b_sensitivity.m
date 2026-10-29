function fig5b_sensitivity()
%FIG5B_SENSITIVITY Penalidade de agua vs coeficiente de perda termica UA (limiar UA_crit).
% Figura 6 do artigo. Eixo esquerdo: agua evaporada / agua estequiometrica; eixo direito:
% temperatura de pico. As duas regioes (reator ferve / nao ferve) sao sombreadas.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig5b_sensitivity');

xl  = [7 250];                 % UA (W/K), escala log
ylL = [-0.3 6.0];             % razao de evaporacao (margem para ver os pontos em zero)
ylR = [60 105];                % temperatura de pico (100 C fica abaixo da borda)
grau = char(176);

fig = nova_figura(4.8, 3.5, 'Fig. 6 - sensibilidade UA');
ax = axes(fig, 'Position', [0.125 0.155 0.73 0.74]);
hold(ax, 'on'); box(ax, 'on');
set(ax, 'XScale', 'log', 'XLim', xl, 'XTick', [10 20 50 100 200], ...
        'XTickLabel', {'10', '20', '50', '100', '200'}, 'XMinorTick', 'on');

% ----- eixo esquerdo: penalidade de agua
yyaxis(ax, 'left'); hold(ax, 'on');
ylim(ax, ylL);
faixa(ax, [xl(1) D.UA_crit], ylL, C.mid, 0.06);
faixa(ax, [D.UA_crit xl(2)], ylL, C.coarse, 0.06);
text(ax, 8, 5.85, 'reactor boils', 'FontSize', 9, 'Color', C.mid, 'VerticalAlignment', 'top');
text(ax, 235, 5.85, 'no boiling', 'FontSize', 9, 'Color', C.coarse, ...
     'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

xline(ax, 25, '--', 'Color', C.fine, 'LineWidth', 1.1, 'HandleVisibility', 'off');
text(ax, 25 * 0.94, 0.25, 'reference case', 'Rotation', 90, 'FontSize', 9, ...
     'Color', C.fine, 'VerticalAlignment', 'bottom');
xline(ax, D.UA_crit, ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.3, 'HandleVisibility', 'off');
text(ax, D.UA_crit * 0.94, 0.95, sprintf('{\\itUA}_{crit} = %.0f W K^{-1}', D.UA_crit), ...
     'Rotation', 90, 'FontSize', 9, 'Color', [0.25 0.25 0.25], 'VerticalAlignment', 'bottom');

plot(ax, D.UAs, D.ratios, 'o-', 'Color', C.mid, 'MarkerFaceColor', C.mid, 'LineWidth', 1.8, ...
     'MarkerSize', 4.5, 'DisplayName', 'boil-off / stoichiometric water');
ylabel(ax, 'boil-off / stoichiometric water (--)');

% ----- eixo direito: temperatura de pico
yyaxis(ax, 'right'); hold(ax, 'on');
ylim(ax, ylR);
yline(ax, 100, '-', 'Color', [C.coarse 0.35], 'LineWidth', 0.8, 'HandleVisibility', 'off');
plot(ax, D.UAs, D.tmaxs, 's--', 'Color', C.coarse, 'MarkerFaceColor', C.coarse, ...
     'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'peak temperature');
ylabel(ax, ['peak temperature (' grau 'C)']);

ax.YAxis(1).Color = C.mid; ax.YAxis(2).Color = C.coarse;
ax.XGrid = 'on'; ax.YGrid = 'on';
ax.GridColor = [0.15 0.15 0.15]; ax.GridAlpha = 0.12;   % grade neutra (nao herda a cor do eixo)
ax.MinorGridColor = [0.15 0.15 0.15]; ax.MinorGridAlpha = 0.06; ax.XMinorGrid = 'on';
xlabel(ax, 'heat-loss coefficient {\itUA} (W K^{-1})');
titulo_esq(ax, 'Water penalty is a threshold in {\itUA}');
salvar_figura(fig, 'fig5b_sensitivity');
end
