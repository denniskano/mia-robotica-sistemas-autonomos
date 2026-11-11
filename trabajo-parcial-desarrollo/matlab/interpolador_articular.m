function [q, qp, qpp] = interpolador_articular(qi, qf, t, tipo)
% INTERPOLADOR_ARTICULAR  Polinomio de la clase 6, reposo a reposo.
% tipo = "cubica" o "quintica". Coeficientes iguales a los mlx del curso.
% qi y qf son 3x1. t es un vector fila. q es 3 x numel(t).

qi = qi(:);
qf = qf(:);
Delta = qf - qi;   % desplazamiento total de cada articulación (rad)
tf = t(end) - t(1);   % duración del movimiento (s)
if tf <= 0
    error('El tiempo final tiene que ser mayor que el inicial.');
end
tau = t - t(1);   % tiempo desde el inicio (s)

if tipo == "cubica"
    a0 = qi;
    a1 = zeros(3, 1);
    a2 = 3 * Delta / tf^2;   % coeficientes del cúbico, reposo a reposo
    a3 = -2 * Delta / tf^3;
    q = a0 + a1 .* tau + a2 .* tau.^2 + a3 .* tau.^3;
    qp = a1 + 2 * a2 .* tau + 3 * a3 .* tau.^2;
    qpp = 2 * a2 + 6 * a3 .* tau;
elseif tipo == "quintica"
    a0 = qi;
    a1 = zeros(3, 1);
    a2 = zeros(3, 1);
    a3 = 10 * Delta / tf^3;   % coeficientes del quíntico, reposo a reposo
    a4 = -15 * Delta / tf^4;
    a5 = 6 * Delta / tf^5;
    q = a0 + a1 .* tau + a2 .* tau.^2 + a3 .* tau.^3 + a4 .* tau.^4 + a5 .* tau.^5;
    qp = a1 + 2 * a2 .* tau + 3 * a3 .* tau.^2 + 4 * a4 .* tau.^3 + 5 * a5 .* tau.^4;
    qpp = 2 * a2 + 6 * a3 .* tau + 12 * a4 .* tau.^2 + 20 * a5 .* tau.^3;
else
    error('tipo debe ser cubica o quintica.');
end
end
