function salvar_figura(fig, nome)
%SALVAR_FIGURA Salva <nome>.fig (editavel) e tambem .pdf/.png em ../fig.
pasta = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'fig');
if ~exist(pasta, 'dir'), mkdir(pasta); end
savefig(fig, fullfile(pasta, [nome '.fig']));
try
    exportgraphics(fig, fullfile(pasta, [nome '.pdf']), 'ContentType', 'vector');
    exportgraphics(fig, fullfile(pasta, [nome '.png']), 'Resolution', 300);
catch   % versoes anteriores a R2020a
    print(fig, fullfile(pasta, [nome '.pdf']), '-dpdf', '-painters');
    print(fig, fullfile(pasta, [nome '.png']), '-dpng', '-r300');
end
fprintf('  %s.fig salvo\n', nome);
end
