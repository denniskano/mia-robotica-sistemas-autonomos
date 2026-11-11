function q = cinematica_inversa(xyz, p, codo, cintura)
% CINEMATICA_INVERSA  Geométrica, dos signos como en la clase 3.
% codo    = +1 un signo de sin(q3), -1 el otro.
% cintura = +1 q1 = atan2(py, px); -1 la cintura opuesta, q1 + pi.
% Sale de las ecuaciones (6)-(8). Las (9)-(12) del paper no cierran
% esa directa y no se copian.

x = xyz(1);
y = xyz(2);
z = xyz(3);
rho = hypot(x, y);   % distancia horizontal de la punta al eje de q1 (m)

if rho < 1e-9
    error('robot:ejeQ1', 'La punta está en el eje de q1: q1 no queda determinado.');
end

phi = atan2(y, x);   % ángulo de la punta en el plano xy
if cintura > 0
    q1 = phi;
else
    q1 = phi + pi;
end

A = x * cos(q1) + y * sin(q1);   % alcance horizontal desde la base (m)
zp = z - p.l1;   % altura de la punta sobre el hombro (m)
c3 = (A^2 + zp^2 - p.l2^2 - p.l3^2) / (2 * p.l2 * p.l3);   % coseno de q3 por la ley del coseno
if abs(c3) > 1 + 1e-9
    error('robot:fueraAlcance', 'Fuera de alcance: el codo no cierra para ese punto.');
end
c3 = max(-1, min(1, c3));
s3 = codo * sqrt(1 - c3^2);   % seno de q3; el signo lo fija el codo
q3 = atan2(s3, c3);   % ángulo del codo (rad)
q2 = atan2(zp, A) - atan2(p.l3 * s3, p.l2 + p.l3 * c3);   % ángulo del hombro (rad)
q = [q1; q2; q3];
end
