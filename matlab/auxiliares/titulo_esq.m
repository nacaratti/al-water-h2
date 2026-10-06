function titulo_esq(ax, txt)
%TITULO_ESQ Titulo do painel alinhado a esquerda (estilo do artigo).
title(ax, txt, 'FontWeight', 'normal');
try
    ax.TitleHorizontalAlignment = 'left';   % R2020b ou mais novo
catch
end
end
