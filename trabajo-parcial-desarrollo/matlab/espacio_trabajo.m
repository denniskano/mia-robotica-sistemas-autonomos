function [P, Pcorte] = espacio_trabajo(p, n)
% ESPACIO_TRABAJO  Nube de puntos alcanzables dentro de los límites.
% Barre q1, q2 y q3 en una grilla de n valores por articulación entre
% p.qmin y p.qmax, y pasa cada postura por la directa (ecuaciones 6-8).
% P es 3 x n^3, en metros.
% Pcorte es el corte x = 0 (plano y-z) de la Figura 5 del artículo:
% q1 = +-pi/2 con la misma grilla en q2 y q3. Es 3 x 2n^2.

if nargin < 2
    n = 25;
end
q1 = linspace(p.qmin(1), p.qmax(1), n);
q2 = linspace(p.qmin(2), p.qmax(2), n);
q3 = linspace(p.qmin(3), p.qmax(3), n);
[Q1, Q2, Q3] = ndgrid(q1, q2, q3);
P = posicion(Q1(:)', Q2(:)', Q3(:)', p);

[Q2c, Q3c] = ndgrid(q2, q3);
q2c = Q2c(:)';
q3c = Q3c(:)';
Pcorte = [posicion( pi / 2 * ones(size(q2c)), q2c, q3c, p), ...
          posicion(-pi / 2 * ones(size(q2c)), q2c, q3c, p)];
end

function xyz = posicion(q1, q2, q3, p)
A = p.l2 * cos(q2) + p.l3 * cos(q2 + q3);
xyz = [cos(q1) .* A; ...
       sin(q1) .* A; ...
       p.l1 + p.l2 * sin(q2) + p.l3 * sin(q2 + q3)];
end
