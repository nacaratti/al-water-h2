function theta = parametros_ajuste()
%PARAMETROS_AJUSTE Otimo global do Nivel 1 (gerado por ajuste/busca_multipartida.m).
% theta = [log10 D0 (cm2/s), log10 k1 (cm/s), log10 k_dens, n (fixo), t_ind (min)]
arq = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'dados', 'parametros_ajuste.mat');
S = load(arq, 'theta');
theta = S.theta(:)';
end
