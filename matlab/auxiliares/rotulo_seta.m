function [ht, hl] = rotulo_seta(ax, xy_ponto, xy_texto, txt, varargin)
%ROTULO_SETA Texto com uma linha-guia ate o ponto anotado (coordenadas de dados).
hl = plot(ax, [xy_texto(1) xy_ponto(1)], [xy_texto(2) xy_ponto(2)], '-', ...
          'Color', [0 0 0], 'LineWidth', 0.6, 'HandleVisibility', 'off');
ht = text(ax, xy_texto(1), xy_texto(2), txt, varargin{:});
end
