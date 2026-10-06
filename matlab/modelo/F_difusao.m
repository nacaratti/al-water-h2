function F = F_difusao(alpha)
%F_DIFUSAO Grupo de Levenspiel para difusao na camada de produto: F = 1 - 3(1-a)^(2/3) + 2(1-a).
% E a Eq. (11) de Martinez-Vargas 2026; F contra t e uma reta de inclinacao kd quando a
% difusao na camada de produto controla.
a = min(max(alpha, 0), 1);
F = 1 - 3 * (1 - a).^(2 / 3) + 2 * (1 - a);
end
