function g = gradiente_np(f, x, ordem_borda)
%GRADIENTE_NP Derivada numerica em malha nao uniforme: diferencas centrais de 2a ordem no
%interior e bordas de 1a ou 2a ordem ('ordem_borda'). O GRADIENT do MATLAB usa formula de
%1a ordem no interior quando a malha nao e uniforme, por isso esta versao.
if nargin < 3, ordem_borda = 1; end
f = f(:); x = x(:); n = numel(f);
g = zeros(n, 1);
h = diff(x);
hs = h(1:end-1); hd = h(2:end);                 % passos a esquerda e a direita
g(2:n-1) = (hs.^2 .* f(3:n) - hd.^2 .* f(1:n-2) + (hd.^2 - hs.^2) .* f(2:n-1)) ...
           ./ (hs .* hd .* (hs + hd));
if ordem_borda == 1 || n < 3
    g(1) = (f(2) - f(1)) / h(1);
    g(n) = (f(n) - f(n-1)) / h(end);
else
    a = -(2 * h(1) + h(2)) / (h(1) * (h(1) + h(2)));
    b = (h(1) + h(2)) / (h(1) * h(2));
    c = -h(1) / (h(2) * (h(1) + h(2)));
    g(1) = a * f(1) + b * f(2) + c * f(3);
    a = h(end) / (h(end-1) * (h(end-1) + h(end)));
    b = -(h(end) + h(end-1)) / (h(end-1) * h(end));
    c = (2 * h(end) + h(end-1)) / (h(end) * (h(end-1) + h(end)));
    g(n) = a * f(n-2) + b * f(n-1) + c * f(n);
end
end
