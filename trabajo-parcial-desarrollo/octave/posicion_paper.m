function xyz = posicion_paper(q, p)
% Ecuaciones (6)-(8) de Ramzy et al. (2024), para contrastar con la cadena DHL.
q1 = q(1);
q2 = q(2);
q3 = q(3);
A = p.l2 * cos(q2) + p.l3 * cos(q2 + q3);
xyz = [cos(q1) * A; ...
       sin(q1) * A; ...
       p.l1 + p.l2 * sin(q2) + p.l3 * sin(q2 + q3)];
end
