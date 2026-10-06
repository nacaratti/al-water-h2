function [d, w] = classes_lognormal(d50_um, span, n_bins, lo, hi)
%CLASSES_LOGNORMAL Classes de tamanho (ponderadas em massa) de um po log-normal.
% 'span' e o desvio-padrao de ln d. Usa erf/erfinv, sem exigir toolbox.
if nargin < 2, span = 0.6; end
if nargin < 3, n_bins = 14; end
if nargin < 4, lo = 0.05; end
if nargin < 5, hi = 0.995; end
ppf = @(p) d50_um * exp(span * sqrt(2) * erfinv(2 * p - 1));
cdf = @(x) 0.5 * erfc(-log(x / d50_um) / (span * sqrt(2)));
bordas = ppf(linspace(lo, hi, n_bins + 1));
d = sqrt(bordas(1:end-1) .* bordas(2:end));
w = diff(cdf(bordas));
w = w / sum(w);
d = d(:); w = w(:);
end
