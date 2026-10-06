function e = energia_com_ciclo(phi, r, primario)
%ENERGIA_COM_CICLO Energia primaria por kg H2 com uma fracao r de reciclagem interna do
%Al(OH)3 gerado pela propria reacao (ciclo Bayer), antes da fracao de sucata externa phi.
%
% Distinto de phi (Al pos-consumo externo, refundido, sem eletrolise): o Al(OH)3 da reacao ja
% e o intermediario do processo Bayer, entao recupera-lo pula a mineracao e a digestao Bayer
% e vai direto a calcinacao e a eletrolise Hall-Heroult. So ha numero citavel para a
% eletrolise (13 kWh/kg Al, Kaur & Verma), nao para a calcinacao, entao KWH_KG_AL_RECICLO e
% um LIMITE INFERIOR da energia real de reprocessamento.
% Uma fracao r do Al vem do proprio ciclo; os (1-r) restantes vem da mistura externa
% (primario vs sucata, dividida por phi). r e phi sao independentes.
if nargin < 3, primario = 'hall_heroult'; end
K = constantes();
e_ext = (1 - phi) * kwh_primario(primario) + phi * (K.KWH_SUCATA_KG_H2 / K.AL_POR_H2);
e = (r * K.KWH_KG_AL_RECICLO + (1 - r) .* e_ext) * K.AL_POR_H2;
end
