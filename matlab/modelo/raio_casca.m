function rs = raio_casca(rc, R0, n)
%RAIO_CASCA Raio externo da casca de produto sob a modificacao M1 (volume n vezes o consumido).
rs = nthroot(rc.^3 + n .* (R0.^3 - rc.^3), 3);
end
