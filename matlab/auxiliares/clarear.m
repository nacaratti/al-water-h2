function c = clarear(cor, alfa)
%CLAREAR Mistura a cor com branco (equivalente a uma transparencia sobre fundo branco).
c = alfa * cor + (1 - alfa) * [1 1 1];
end
