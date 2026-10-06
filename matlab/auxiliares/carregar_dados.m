function D = carregar_dados(nome)
%CARREGAR_DADOS Le ../dados/<nome>.mat (gerado por exportar_dados.m a partir do modelo).
pasta = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'dados');
D = load(fullfile(pasta, [nome '.mat']));
end
