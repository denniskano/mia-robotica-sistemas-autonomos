function [Q, etiquetas] = cinematica_inversa_todas(xyz, p)
% CINEMATICA_INVERSA_TODAS  Las cuatro soluciones geométricas.
% Combina los dos signos de cintura (q1 o q1 + pi) con los dos signos de
% codo (signo de sin(q3)). Q es 3x4; cada columna es una solución.
% Una columna queda en NaN si ese punto no tiene esa solución.

combinaciones = [ 1,  1; ...
                  1, -1; ...
                 -1,  1; ...
                 -1, -1];
etiquetas = ["cintura +, codo +", "cintura +, codo -", ...
             "cintura -, codo +", "cintura -, codo -"];
Q = nan(3, 4);   % una columna por solución (rad)
% Prueba las cuatro combinaciones de cintura y codo.
for k = 1:4
    cintura = combinaciones(k, 1);
    codo = combinaciones(k, 2);
    try
        q = cinematica_inversa(xyz, p, codo, cintura);
        % Ángulos en (-pi, pi] para compararlos con los límites.
        Q(:, k) = atan2(sin(q), cos(q));
    catch ME
        % Solo estos dos casos significan "no hay solución" y dejan NaN.
        % Cualquier otro error es un defecto y se relanza.
        if ~any(strcmp(ME.identifier, {'robot:fueraAlcance', 'robot:ejeQ1'}))
            rethrow(ME);
        end
    end
end
end
