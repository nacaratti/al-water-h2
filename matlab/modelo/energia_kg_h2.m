function e = energia_kg_h2(phi, primario, credito_calor)
%ENERGIA_KG_H2 Nivel 3 - energia primaria (kWh por kg H2) com fracao de sucata externa phi.
% phi = 1: alimentacao toda de sucata; phi = 0: toda de metal primario.
% 'primario' = 'hall_heroult' (padrao) ou 'hoopes'; credito_calor subtrai o calor
% recuperavel da hidrolise (4.4 kWh por kg Al).
if nargin < 2, primario = 'hall_heroult'; end
if nargin < 3, credito_calor = false; end
K = constantes();
e = (1 - phi) * kwh_primario(primario) * K.AL_POR_H2 + phi * K.KWH_SUCATA_KG_H2;
if credito_calor
    e = e - K.CALOR_KWH_KG_AL * K.AL_POR_H2;
end
end
