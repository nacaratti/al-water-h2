%GERAR_TODAS Gera todas as figuras do artigo e salva .fig (editavel), .pdf e .png em ./fig
%
% Uso: abra esta pasta no MATLAB e rode  >> gerar_todas
% Os dados ja estao em ./dados; para recalcula-los a partir do modelo, rode antes
% >> exportar_dados. Requer MATLAB R2019b ou mais novo (tiledlayout, xline).
% Para editar uma figura depois:  >> openfig('fig/fig3_size.fig')
aqui = fileparts(mfilename('fullpath'));
addpath(aqui, fullfile(aqui, 'auxiliares'));
figs = {@fig1_scales, @fig2_fit, @fig3_size, @fig4_designcurve, @fig5_design, ...
        @fig5b_sensitivity, @fig6_energy, @fig7_bayerloop, @fig8_cost, @figS1_designmap};
for k = 1:numel(figs)
    try
        figs{k}();
    catch err
        fprintf(2, '  ERRO em %s: %s\n', func2str(figs{k}), err.message);
    end
end
fprintf('Pronto: figuras em %s\n', fullfile(aqui, 'fig'));
