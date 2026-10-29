function [total, c_al, c_naoh] = custo_kg_h2(phi, recuperacao_naoh, preco_recuperado)
%CUSTO_KG_H2 Custo de insumos por kg H2 (US$): aluminio (misturado por phi) + reposicao de NaOH.
%
%   [total, c_al, c_naoh] = custo_kg_h2(phi, recuperacao_naoh, preco_recuperado)
%
% recuperacao_naoh: fracao do NaOH consumido que e recuperada (0 = todo NaOH e reposto com
% alcali novo a preco de commodity). preco_recuperado (US$/kg): custo do NaOH recuperado;
% 0 (padrao) trata a recuperacao como gratuita, o limite mais favoravel. Para um limite com
% custo, use K.NAOH_REGEN_USD_KG (US$363/t, NaOH regenerado a partir de Na2CO3 segundo
% Baral et al. 2025 -- rota quimicamente relacionada, usada aqui como referencia).
%
% Nenhuma fonte consultada da uma eficiencia nem um custo de recuperacao de NaOH para esta
% reacao especifica, por isso o resultado e reportado como funcao da fracao recuperada.
if nargin < 2, recuperacao_naoh = 0; end
if nargin < 3, preco_recuperado = 0; end
K = constantes();
c_al = ((1 - phi) * K.AL_PRIM_USD_KG + phi * K.AL_SUCATA_USD_KG) * K.AL_POR_H2;
rec = min(max(recuperacao_naoh, 0), 1);
c_naoh = K.NAOH_KG_KG_AL * K.AL_POR_H2 * ((1 - rec) * K.NAOH_USD_KG + rec * preco_recuperado);
total = c_al + c_naoh;
end
