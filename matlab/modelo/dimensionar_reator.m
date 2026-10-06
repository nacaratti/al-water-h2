function s = dimensionar_reator(potencia_kW, conversao, horas, efic_celula)
%DIMENSIONAR_REATOR Carga de Al e demanda de H2 para uma PEMFC de 'potencia_kW' por 'horas'.
% PCI do H2 = 33.33 kWh/kg. O white paper cita 0.455 kg Al/kWh.
if nargin < 3, horas = 1; end
if nargin < 4, efic_celula = 0.50; end
K = constantes();
PCI = 33.33;
kwh = potencia_kW * horas;
s.kg_H2 = kwh / (PCI * efic_celula);
s.kg_Al = s.kg_H2 * K.AL_POR_H2 / max(conversao, 1e-9);
s.kg_Al_por_kWh = s.kg_Al / max(kwh, 1e-9);
s.H2_NL = s.kg_H2 * 1000 * 11.2;
end
