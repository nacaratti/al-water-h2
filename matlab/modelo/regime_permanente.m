function s = regime_permanente(d50_um, UA, span, duracao_min)
%REGIME_PERMANENTE Taxa de alimentacao que atende 1 kW em regime, razao de agua evaporada /
%estequiometrica e temperatura de pico, para uma combinacao (UA, span).
%
% UA nao e identificavel com os dados deste trabalho (nao ha calorimetria em escala de
% reator), entao o valor de referencia (25 W/K) e justificado mostrando que a conclusao
% qualitativa e robusta numa faixa plausivel, nao alegando que o numero e preciso.
if nargin < 4, duracao_min = 150; end
K = constantes();
sonda = simular_continuo(d50_um, 1.0, 'duracao_min', duracao_min, 'UA', UA, 'span', span);
cauda = floor(0.7 * numel(sonda.t)) + 1 : numel(sonda.t);
F = K.DEMANDA_ML_MIN / max(mean(sonda.flow(cauda)), 1e-9);
c = simular_continuo(d50_um, F, 'duracao_min', duracao_min, 'UA', UA, 'span', span);
esteq = c.flow / K.H2_ML_POR_G * (4 * 18.02) / (2 * K.M_AL);
s.F = F;
s.boiloff = mean(c.boiloff_g_min(cauda));
s.stoich = mean(esteq(cauda));
s.ratio = s.boiloff / s.stoich;
s.T_max = max(c.T);
s.cont = c; s.esteq = esteq;
end
