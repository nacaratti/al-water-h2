function e = kwh_primario(primario)
%KWH_PRIMARIO Energia por kg de Al primario para a rota indicada (kWh/kg Al).
K = constantes();
switch primario
    case 'hall_heroult', e = K.KWH_KG_AL_HALL;
    case 'hoopes',       e = K.KWH_KG_AL_HOOPES;
    otherwise, error('rota primaria desconhecida: %s', primario);
end
end
