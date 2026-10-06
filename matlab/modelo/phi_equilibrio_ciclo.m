function phi = phi_equilibrio_ciclo(r, alvo_kwh, primario)
%PHI_EQUILIBRIO_CICLO Fracao de sucata externa de equilibrio phi* em funcao do fechamento r
%do ciclo Bayer. A energia e linear em phi para r fixo, entao resolve-se direto a partir de
%phi = 0 e phi = 1. Devolve NaN onde o alvo e inatingivel para qualquer phi em [0, 1]
%(em vez de recortar para 0 ou 1), o que ocorre quando r sozinho ja supera o alvo.
if nargin < 3, primario = 'hall_heroult'; end
e0 = energia_com_ciclo(0, r, primario);
e1 = energia_com_ciclo(1, r, primario);
phi = (e0 - alvo_kwh) ./ (e0 - e1);
phi(phi < 0 | phi > 1 | e0 == e1) = NaN;
end
