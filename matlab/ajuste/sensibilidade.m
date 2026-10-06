%SENSIBILIDADE Nivel 2 - quanto as conclusoes de operacao do reator (razao de agua evaporada,
%temperatura de pico) dependem dos dois parametros assumidos, e nao ajustados: o coeficiente
%global de perdas UA e o span da distribuicao log-normal do po.
aqui = fileparts(mfilename('fullpath'));
addpath(fullfile(aqui, '..', 'modelo'));
UAs = [10 25 50 100]; spans = [0.3 0.5 0.8];
fprintf('%9s %6s %10s %9s %7s %7s %7s\n', 'UA (W/K)', 'span', 'F (g/min)', 'evaporada', ...
        'esteq', 'razao', 'T_max');
razoes = [];
for UA = UAs
    for sp = spans
        s = regime_permanente(6.8, UA, sp);
        razoes(end + 1) = s.ratio; %#ok<SAGROW>
        fprintf('%9.0f %6.2f %10.3f %9.2f %7.2f %7.2f %7.1f\n', UA, sp, s.F, s.boiloff, ...
                s.stoich, s.ratio, s.T_max);
    end
end
fprintf('\nfaixa da razao em toda a varredura: %.2f-%.2fx\n', min(razoes), max(razoes));
s = regime_permanente(6.8, 25, 0.5);
fprintf('(caso de referencia UA=25, span=0.5 da %.2fx)\n', s.ratio);
