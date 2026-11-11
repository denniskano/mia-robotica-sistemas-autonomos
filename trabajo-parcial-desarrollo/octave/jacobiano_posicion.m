function J = jacobiano_posicion(q, p)
% JACOBIANO_POSICION  3x3, derivadas de [x;y;z] respecto de [q1;q2;q3].
% La posición es la de las ecuaciones (6)-(8) de Ramzy et al. (2024).
% Con esta cadena, det(J) = -A*l2*l3*sin(q3),
% A = l2*cos(q2) + l3*cos(q2+q3).

q1 = q(1);
q2 = q(2);
q3 = q(3);
c1 = cos(q1);
s1 = sin(q1);
c2 = cos(q2);
s2 = sin(q2);
c23 = cos(q2 + q3);
s23 = sin(q2 + q3);
A = p.l2 * c2 + p.l3 * c23;   % alcance horizontal del brazo (m)
B = p.l2 * s2 + p.l3 * s23;   % altura del brazo sobre la base (m)

% derivadas de [x y z] respecto de [q1 q2 q3] (m/rad)
J = [-s1 * A,  -c1 * B,  -c1 * p.l3 * s23; ...
      c1 * A,  -s1 * B,  -s1 * p.l3 * s23; ...
      0,        A,        p.l3 * c23];
end
