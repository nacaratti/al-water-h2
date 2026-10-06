function c = co2_kg_h2(phi, primario)
%CO2_KG_H2 kg CO2 por kg H2 em funcao da fracao de sucata externa phi.
%
% O CO2 impresso para Hoopes (11 kg/kg H2) nao e conciliavel com o fator de 12.7 kg CO2/kg Al
% usado para Hall-Heroult (12.7 x 9 = 114.3); usa-se um valor de Hoopes escalado pela razao
% de energias, e a inconsistencia e registrada (ver co2_hoopes_recalculado).
if nargin < 2, primario = 'hall_heroult'; end
K = constantes();
if strcmp(primario, 'hall_heroult')
    c0 = K.CO2_KG_AL_HALL * K.AL_POR_H2;
else
    c0 = co2_hoopes_recalculado();
end
c = (1 - phi) * c0;
end
