function tr = tempo_reacao(r, t_ind)
%TEMPO_REACAO Tempo ate 99 % da conversao final (normalizada), somado ao periodo de inducao.
Xn = r.X / max(max(r.X), 1e-12);
j = find(Xn >= 0.99, 1);
if Xn(end) >= 0.99
    tr = r.t(j) + t_ind;
else
    tr = r.t(end) + t_ind;
end
end
