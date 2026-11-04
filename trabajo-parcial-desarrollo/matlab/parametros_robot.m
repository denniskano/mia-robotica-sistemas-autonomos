function p = parametros_robot()
% PARAMETROS_ROBOT  Antropomórfico de Ramzy, Hammad y Maged (2024).
% Tabla 1 de Denavit-Hartenberg y largos de la Tabla 2.
%   l1 = 0.04 m, l2 = 0.29 m, l3 = 0.240 m.
% alpha = [pi/2; 0; 0], a = [0; l2; l3], d = [l1; 0; 0].
% Masas, centros de masa y momentos de la misma Tabla 2 no entran
% en esta simulación: el parcial es cinemático.

p.l1 = 0.04;
p.l2 = 0.29;
p.l3 = 0.240;
p.a1 = 0;
p.a2 = p.l2;
p.a3 = p.l3;
p.d1 = p.l1;
p.d2 = 0;
p.d3 = 0;
p.alpha = [pi / 2; 0; 0];

% Límites articulares. El artículo no los publica. Se eligieron para que
% el corte x = 0 del espacio de trabajo tenga la forma de herradura de la
% Figura 5 del artículo (alcance máximo l1 + l2 + l3 = 0.57 m arriba,
% hueco interior simétrico y base cortada cerca de z = -0.2 m).
% Son supuestos de esta simulación, no datos del banco.
p.qmin = deg2rad([-180; -30; -120]);
p.qmax = deg2rad([ 180;  90;  120]);
end
