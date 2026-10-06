function y = interp_lim(xq, xp, fp, esq, dir)
%INTERP_LIM Interpolacao linear que aceita abscissas repetidas (patamar X = 1) e devolve
%valores constantes fora do intervalo: 'esq' a esquerda, 'dir' a direita (padrao: extremos).
xp = xp(:); fp = fp(:);
if nargin < 4 || isempty(esq), esq = fp(1); end
if nargin < 5 || isempty(dir), dir = fp(end); end
y = zeros(size(xq));
n = numel(xp);
for k = 1:numel(xq)
    x = xq(k);
    if x < xp(1)
        y(k) = esq;
    elseif x > xp(n)
        y(k) = dir;
    elseif x == xp(n)
        y(k) = fp(n);
    else
        j = find(xp <= x, 1, 'last');
        if xp(j + 1) == xp(j)
            y(k) = fp(j);
        else
            y(k) = fp(j) + (fp(j + 1) - fp(j)) * (x - xp(j)) / (xp(j + 1) - xp(j));
        end
    end
end
end
