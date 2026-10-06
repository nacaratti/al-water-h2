function c = co2_hoopes_recalculado()
%CO2_HOOPES_RECALCULADO CO2 da rota Hoopes escalado pela razao de energias (kg CO2/kg H2).
K = constantes();
c = K.CO2_KG_AL_HALL * (K.KWH_KG_AL_HOOPES / K.KWH_KG_AL_HALL) * K.AL_POR_H2;
end
