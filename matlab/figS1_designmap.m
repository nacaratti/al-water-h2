function figS1_designmap()
%FIGS1_DESIGNMAP Figura suplementar - mapa de conversao (d50 x tempo de residencia).
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
D = carregar_dados('figS1_designmap');

fig = nova_figura(4.2, 3.1, 'Fig. S1 - mapa de projeto');
ax = novo_eixo(fig); set(ax, 'XScale', 'log', 'YScale', 'log', 'Layer', 'top');
contourf(ax, D.d50s, D.taus, D.Z, linspace(0, 1, 21), 'LineStyle', 'none');
[cc, hc] = contour(ax, D.d50s, D.taus, D.Z, [0.5 0.8 0.9 0.96], 'LineColor', 'w', 'LineWidth', 0.9);
niveis = [0.5 0.8 0.9 0.96]; k = 1;
while k < size(cc, 2)   % rotula cada nivel uma vez, na borda direita (clabel sobrepunha os rotulos)
    nv = cc(1, k); n = cc(2, k); xy = cc(:, k+1:k+n);
    [xmax, j] = max(xy(1, :));
    if any(abs(niveis - nv) < 1e-9) && xmax > 0.9 * max(D.d50s)
        text(ax, xmax * 0.97, xy(2, j), sprintf('%g', nv), 'Color', 'w', 'FontSize', 9, ...
             'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        niveis(abs(niveis - nv) < 1e-9) = NaN;
    end
    k = k + n + 1;
end
colormap(ax, parula); caxis(ax, [0 1]);
cb = colorbar(ax); cb.Label.String = 'conversion {\itX} (--)';
plot(ax, 6.8, D.t96, 'p', 'MarkerSize', 13, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'k', 'LineWidth', 0.6);
text(ax, 6.8, D.t96 * 1.45, 'ball-milled {\itD}_{50}', 'Color', 'w', 'FontSize', 9, ...
     'HorizontalAlignment', 'center');
xlim(ax, [min(D.d50s) max(D.d50s)]); ylim(ax, [min(D.taus) max(D.taus)]);
xlabel(ax, 'median diameter {\itd}_{50} (\mum)'); ylabel(ax, 'residence time (min)');
titulo_esq(ax, 'conversion design map (supplementary)');
salvar_figura(fig, 'figS1_designmap');
end
