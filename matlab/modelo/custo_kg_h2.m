function [total, c_al, c_naoh] = custo_kg_h2(phi, recuperacao_naoh)
%CUSTO_KG_H2 Custo de insumos por kg H2 (US$): aluminio (misturado por phi) + reposicao de NaOH.
%
% recuperacao_naoh = 0 e o padrao de proposito: nenhuma fonte consultada da uma eficiencia
% citavel de recuperacao de NaOH para esta reacao, entao o caso sem recuperacao e reportado
% como limite superior honesto, e nao porque se suponha que nao haja recuperacao na pratica.
% recuperacao = 1: totalmente regenerado (p. ex. pela mesma caustificacao que o processo
% Bayer usa para recuperar sua soda).
if nargin < 2, recuperacao_naoh = 0; end
K = constantes();
c_al = ((1 - phi) * K.AL_PRIM_USD_KG + phi * K.AL_SUCATA_USD_KG) * K.AL_POR_H2;
fresco = 1 - min(max(recuperacao_naoh, 0), 1);
c_naoh = K.NAOH_KG_KG_AL * K.NAOH_USD_KG * K.AL_POR_H2 * fresco;
total = c_al + c_naoh;
end
