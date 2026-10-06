function fig3_size()
%FIG3_SIZE Figura 3 - escala com o tamanho de particula e o otimo de rendimento ausente.
addpath(fullfile(fileparts(mfilename('fullpath')), 'auxiliares'));
C = estilo_graficos(); D = carregar_dados('fig3_size');

fig = nova_figura(6.5, 6.0, 'Fig. 3 - tamanho');
tl = tiledlayout(fig, 2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% (a) k_d vs d em 5 decadas
ax = novo_eixo(tl); set(ax, 'XScale', 'log', 'YScale', 'log');
yl = 10 .^ [floor(log10(min(D.kds_ok))), ceil(log10(max(D.kds_ok)))];
faixa(ax, [180 500], yl, C.grey, 0.12);
plot(ax, D.ds_ok, D.kds_ok, 'Color', C.acc, 'LineWidth', 1.8, 'DisplayName', 'model');
plot(ax, D.d_um, D.kd_obs, 'o', 'Color', C.mid, 'MarkerFaceColor', C.mid, 'MarkerSize', 6.5, ...
     'DisplayName', C.mv);
xlim(ax, [0.05 1000]); ylim(ax, yl);
xlabel(ax, 'diameter {\itd} (\mum)'); ylabel(ax, '{\itk_d} (min^{-1})');
titulo_esq(ax, '(a) size scaling, 5 decades');
legend(ax, 'Location', 'southwest');

% (b) expoente local: transicao de regime
ax = novo_eixo(tl); set(ax, 'XScale', 'log');
faixa(ax, [180 500], [0.8 2.2], C.grey, 0.12);
plot(ax, D.ds_ok, D.local_exp, 'Color', C.acc, 'LineWidth', 1.8);
yline(ax, 1.0, '--', 'Color', C.grey, 'LineWidth', 1.0);
yline(ax, 2.0, '--', 'Color', C.grey, 'LineWidth', 1.0);
plot(ax, sqrt(180 * 500), D.e_obs, 'o', 'Color', C.mid, 'MarkerFaceColor', C.mid, 'MarkerSize', 6.5);
text(ax, 0.09, 1.08, 'chemical control', 'Color', C.grey);
text(ax, 0.09, 1.85, 'diffusion control', 'Color', C.grey);
xlim(ax, [0.05 1000]); ylim(ax, [0.8 2.2]);
xlabel(ax, 'diameter {\itd} (\mum)');
ylabel(ax, 'local exponent  -d ln {\itk_d} / d ln {\itd}');
titulo_esq(ax, '(b) regime crossover');

% (c) tempo de reacao, 150-600 um, com SEM
ax = novo_eixo(tl);
z = D.ds >= 150 & D.ds <= 600;
plot(ax, D.ds(z), D.tr_pred(z), 'Color', C.acc, 'LineWidth', 1.8, 'DisplayName', 'model');
errorbar(ax, D.d_um, D.tr_obs, D.tr_sem, 'o', 'Color', C.mid, 'MarkerFaceColor', C.mid, ...
         'MarkerSize', 6.5, 'CapSize', 3, 'LineWidth', 1.3, 'DisplayName', [C.mv ' (SEM)']);
xlabel(ax, 'diameter {\itd} (\mum)'); ylabel(ax, 'reaction time {\itt_r} (min)');
titulo_esq(ax, '(c) zoom: 150-600 \mum, with SEM');
legend(ax, 'Location', 'northwest');

% (d) otimo de rendimento nao reproduzido (dois eixos y)
ax = novo_eixo(tl);
yyaxis(ax, 'left'); hold(ax, 'on');
plot(ax, D.ds(z), D.xend(z), '-', 'Color', C.acc, 'LineWidth', 1.8, 'DisplayName', 'model conversion');
ylim(ax, [0 1.15]); ylabel(ax, 'final conversion (--)');
yyaxis(ax, 'right'); hold(ax, 'on');
plot(ax, D.d_um, D.v_obs, 's--', 'Color', C.mid, 'MarkerFaceColor', C.mid, 'MarkerSize', 6.5, ...
     'LineWidth', 1.2, 'DisplayName', 'measured {\itV}_{cum}');
ylim(ax, [90 145]); ylabel(ax, '{\itV}_{cum} (mL)');
ax.YAxis(1).Color = [0 0 0]; ax.YAxis(2).Color = C.mid;
xlabel(ax, 'diameter {\itd} (\mum)');
titulo_esq(ax, '(d) yield optimum not reproduced');
legend(ax, 'Location', 'south');

salvar_figura(fig, 'fig3_size');
end
