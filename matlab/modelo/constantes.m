function K = constantes()
%CONSTANTES Constantes fisicas e de projeto usadas pelos tres niveis do modelo.
%
% Todas rastreadas em ../../data/constants.csv, energy_system.csv e cost_system.csv.
%
% Martinez-Salazar et al. imprimem C_Ao em mol/cm^2, o que e dimensionalmente impossivel
% para uma concentracao; e um erro tipografico de mol/cm^3. Usamos mol/cm^3 e registramos
% isso no manuscrito em vez de propagar a unidade impressa.

% --- Nivel 1: particula --------------------------------------------------------------
K.RHO_B   = 0.1;       % mol Al / cm^3
K.C_A0    = 0.056;     % mol / cm^3 (agua, 55.5 M)
K.B_STOICH = 0.5;      % mol Al por mol H2O, rota da boehmita 2Al + 4H2O -> 2AlOOH + 3H2
K.M_AL    = 26.98;     % g/mol
K.RHO_AL  = 2.70;      % g/cm^3
K.N_FIXO  = 2.68;      % razao de volume casca/nucleo (ajuste independente, Martinez-Salazar 2025)

% --- Nivel 2: reator -----------------------------------------------------------------
K.H2_ML_POR_G   = 1245.0;   % mL H2 (CNTP) por g Al, conversao completa
K.DH_J_POR_G_AL = 15.5e3;   % J por g Al (15-16 MJ/kg, Kaur & Verma)
K.CP_AGUA       = 4.18;     % J/(g K)
K.NAOH_POR_AL   = 1.0;      % mol NaOH complexado por mol Al (rota NaAl(OH)4)
K.T_EBUL_C      = 100.0;
K.LATENTE_J_G   = 2260.0;   % vaporizacao da agua a 1 atm
K.EA_J          = 60e3;     % energia de ativacao assumida (nao identificavel dos dados)
K.R_GAS         = 8.314;
K.DEMANDA_ML_MIN = 60.0 / 2.016 * 22.4 / 60.0 * 1000.0;   % PEMFC de 1 kW a 50 % de eficiencia

% --- Nivel 3: sistema ----------------------------------------------------------------
K.AL_POR_H2         = 9.0;     % kg Al por kg H2 a 3.7 % em massa (Kaur & Verma)
K.KWH_KG_AL_HALL    = 21.24;   % Hall-Heroult
K.KWH_KG_AL_HOOPES  = 17.04;
K.CO2_KG_AL_HALL    = 12.7;    % kg CO2 por kg Al, Hall-Heroult
K.KWH_SUCATA_KG_H2  = 4.0;     % rota da sucata, sem a etapa de eletrolise
K.CALOR_KWH_KG_AL   = 4.4;     % calor recuperavel da hidrolise
K.CUSTO_TOPDOWN     = 21.0;    % US$/kg H2, estimativa de Kaur & Verma
K.KWH_ELETROLISE    = 53.4;    % kWh/kg H2, eletrolise da agua (Tang et al. 2023)
K.KWH_KG_AL_RECICLO = 13.0;    % so eletrolise; exclui calcinacao -> limite inferior
K.AL_PRIM_USD_KG    = 1.0092 * 2.20462;      % "$1.0092/lb"
K.AL_SUCATA_USD_KG  = K.AL_PRIM_USD_KG / 3;  % "um terco do preco do Al puro"
K.NAOH_USD_KG       = 13.95 / 0.5;           % "$13.95 por 500 g"
K.M_NAOH            = 40.00;
K.NAOH_KG_KG_AL     = 1.0 * K.M_NAOH / K.M_AL;   % sem recuperacao
K.CUSTO_SMR         = 2.90;    % US$/kg H2, reforma a vapor do metano (Tang et al. 2023)

% --- Dados de Martinez-Vargas et al. (2026) -----------------------------------------
K.D_UM   = [215.0; 363.0; 463.0];
K.PENEIRA = [180 250; 300 425; 425 500];
K.KD_OBS = [0.137; 0.064; 0.050];
K.KD_SEM = 0.05 * K.KD_OBS;      % a fonte cita R2 > 0.99; 5 % como sigma conservador
K.TR_OBS = [14.86; 25.12; 29.30];
K.TR_SEM = [0.18; 0.81; 1.64];
K.Q_OBS  = [18.77; 14.68; 13.14];
K.Q_SEM  = [2.00; 0.76; 0.18];
K.V_OBS  = [106.0; 132.0; 102.0];
end
