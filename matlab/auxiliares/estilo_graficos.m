function C = estilo_graficos()
%ESTILO_GRAFICOS Paleta de cores usada em todas as figuras do artigo.
C.fine   = [27 108 168] / 255;   % #1b6ca8 (azul)
C.mid    = [200 16 46]  / 255;   % #c8102e (vermelho)
C.coarse = [46 125 50]  / 255;   % #2e7d32 (verde)
C.acc    = [224 123 0]  / 255;   % #e07b00 (laranja)
C.grey   = [102 102 102] / 255;  % #666666
C.cols   = {C.fine, C.mid, C.coarse};
C.labels = {'215 \mum', '363 \mum', '463 \mum'};
C.mv     = ['Mart' char(237) 'nez-Vargas 2026'];
end
