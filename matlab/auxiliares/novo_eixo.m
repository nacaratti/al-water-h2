function ax = novo_eixo(pai)
%NOVO_EIXO Cria eixos (em um tiledlayout ou figura) ja com hold on.
if isa(pai, 'matlab.graphics.layout.TiledChartLayout')
    ax = nexttile(pai);
else
    ax = axes(pai);
end
hold(ax, 'on');
box(ax, 'on'); grid(ax, 'on');
end
