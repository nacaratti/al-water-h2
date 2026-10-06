function [kd, r2] = kd_aparente(t_min, X, x_lo, x_hi)
%KD_APARENTE Inclinacao de F(alpha) vs t numa janela de conversao: o kd que a fonte reporta.
% A fonte normaliza alpha pelo volume final EXPERIMENTAL, de modo que alpha sempre chega a 1.
% Reproduzimos essa convencao reescalando X pelo seu proprio maximo; caso contrario o kd
% ajustado nao e comparavel ao valor publicado.
if nargin < 3, x_lo = 0.05; end
if nargin < 4, x_hi = 0.85; end
kd = NaN; r2 = NaN;
Xmax = max(X);
if Xmax <= 0, return, end
alpha = X / Xmax;
m = alpha >= x_lo & alpha <= x_hi;
if nnz(m) < 5, return, end
F = F_difusao(alpha(m)); t = t_min(m);
A = [t(:), ones(nnz(m), 1)];
coef = A \ F(:);
pred = A * coef;
ss_res = sum((F(:) - pred).^2); ss_tot = sum((F(:) - mean(F)).^2);
kd = coef(1);
if ss_tot > 0, r2 = 1 - ss_res / ss_tot; end
end
