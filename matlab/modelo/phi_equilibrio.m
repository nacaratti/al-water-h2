function phi = phi_equilibrio(alvo_kwh, primario, credito_calor)
%PHI_EQUILIBRIO Fracao de sucata em que a rota do Al iguala 'alvo_kwh' por kg H2.
if nargin < 2, primario = 'hall_heroult'; end
if nargin < 3, credito_calor = false; end
e0 = energia_kg_h2(0, primario, credito_calor);
e1 = energia_kg_h2(1, primario, credito_calor);
phi = NaN;
if e0 == e1, return, end
p = (e0 - alvo_kwh) / (e0 - e1);
if p >= 0 && p <= 1, phi = p; end
end
