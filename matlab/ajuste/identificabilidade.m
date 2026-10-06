%IDENTIFICABILIDADE Quais parametros sao de fato identificaveis com seis pontos de dados?
%
% Ordena as direcoes rigidas/frouxas do modelo ajustado pela decomposicao em autovalores de
% J'J e, em seguida, faz o perfil do parametro mais frouxo (log10 D0) para confirmar.
% Requer Optimization Toolbox.
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
nomes = {'log10_D0', 'log10_k1', 'log10_k_dens', 'n', 't_ind'};
opts = optimoptions('lsqnonlin', 'Display', 'off', 'MaxFunctionEvaluations', 1200);
for dens = {'time', 'flux'}
    dens = dens{1}; %#ok<FXSET>
    [theta, ~, info] = ajustar_particula(dens, false);
    [V, L] = eig(info.J' * info.J);
    [w, ord] = sort(diag(L), 'descend'); V = V(:, ord);
    fprintf('\n=== ''%s'': autovalores de J''J (rigido -> frouxo) ===\n', dens);
    for i = 1:numel(w)
        [~, dom] = sort(-abs(V(:, i)));
        txt = strjoin(arrayfun(@(j) sprintf('%+.2f*%s', V(j, i), nomes{j}), dom(1:3)', ...
                               'UniformOutput', false), ' + ');
        fprintf('  lambda=%12.4g   %s\n', w(i), txt);
    end
    fprintf('  numero de condicao = %.3g\n', w(1) / max(w(end), 1e-30));

    fprintf('  perfil em log10_D0:\n');
    for dv = [-1 -0.5 0 0.5 1]
        D0f = theta(1) + dv;
        f = @(sub) residuos_particula([D0f, sub], dens);
        [~, chi2] = lsqnonlin(f, theta(2:5), [-9 -8 1.05 0], [1 2 6 25], opts);
        fprintf('    log10_D0 = %+.2f  ->  chi2 = %8.3f\n', D0f, chi2);
    end
end
