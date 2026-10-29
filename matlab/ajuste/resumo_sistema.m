%RESUMO_SISTEMA Nivel 3 - imprime os numeros de energia, CO2, dimensionamento e custo usados
%no artigo (todos os insumos rastreados em ../../data/energy_system.csv e cost_system.csv).
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
K = constantes();
fprintf('CO2 Hoopes recalculado: %.1f kg/kg H2 (a fonte imprime 11.0 -- inconsistente com seus\n', ...
        co2_hoopes_recalculado());
fprintf('  proprios 12.7 kg CO2/kg Al)\n');
for phi = [0 0.25 0.5 0.75 1]
    fprintf('  phi=%4.2f  E=%7.1f kWh/kg H2   CO2=%6.1f kg/kg H2\n', phi, energia_kg_h2(phi), co2_kg_h2(phi));
end
fprintf('  equilibrio vs eletrolise da agua (Tang 2023) a %.1f kWh/kg: phi = %.3f\n', ...
        K.KWH_ELETROLISE, phi_equilibrio(K.KWH_ELETROLISE));
fprintf('  equilibrio vs PCI do H2 a 33.33 kWh/kg: phi = %.3f\n', phi_equilibrio(33.33));
fprintf('  r_crit (fechamento do ciclo Bayer) = %.2f\n', K.KWH_ELETROLISE / (K.KWH_KG_AL_RECICLO * K.AL_POR_H2));
s = dimensionar_reator(1.0, 0.96, 1.0);
fprintf('  PEMFC de 1 kW por 1 h: %.1f g H2, %.0f g Al, %.3f kg Al/kWh (white paper: 0.455)\n', ...
        s.kg_H2 * 1000, s.kg_Al * 1000, s.kg_Al_por_kWh);

[~, c_al0, c_naoh0] = custo_kg_h2(0, 0);
fprintf('\nPrecos do Al: primario $%.3f/kg, sucata $%.3f/kg; NaOH $%.2f/kg\n', ...
        K.AL_PRIM_USD_KG, K.AL_SUCATA_USD_KG, K.NAOH_USD_KG);
fprintf('So Al em phi=0: $%.2f/kg H2 (estimativa top-down da fonte: $%.1f/kg H2 -- diferem %.0f%%)\n', ...
        c_al0, K.CUSTO_TOPDOWN, abs(c_al0 - K.CUSTO_TOPDOWN) / K.CUSTO_TOPDOWN * 100);
fprintf('So NaOH, sem recuperacao: $%.2f/kg H2 (%.1f kg NaOH/kg H2 a $%.0f/t, Baral et al. 2025)\n', ...
        c_naoh0, K.NAOH_KG_KG_AL * K.AL_POR_H2, K.NAOH_USD_KG * 1000);
for phi = [0 0.5 0.74 1]
    [tot, c_al, c_naoh] = custo_kg_h2(phi, 0);
    fprintf('  phi=%4.2f  so Al=$%6.2f   +NaOH novo=$%6.2f/kg H2 (NaOH = %3.0f%% do Al; %.1fx o SMR de $%.2f)\n', ...
            phi, c_al, tot, 100 * c_naoh / c_al, tot / K.CUSTO_SMR, K.CUSTO_SMR);
end
fprintf('Em phi=0.74, recuperacao total de NaOH: gratuita -> $%.2f/kg H2; a $%.0f/t (regenerado) -> $%.2f/kg H2\n', ...
        custo_kg_h2(0.74, 1, 0), K.NAOH_REGEN_USD_KG * 1000, custo_kg_h2(0.74, 1, K.NAOH_REGEN_USD_KG));
