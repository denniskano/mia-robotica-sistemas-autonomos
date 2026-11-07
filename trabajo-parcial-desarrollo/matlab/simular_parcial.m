% SIMULAR_PARCIAL  Cinemática y control del antropomórfico de Ramzy et al. (2024).
% Sube esta carpeta a MATLAB Online y ejecuta: simular_parcial
% No usa Robotics System Toolbox. El control sigue a la clase 7 (pinv y tanh).
% Los largos son los de la Tabla 2: l1 = 0.04 m, l2 = 0.29 m, l3 = 0.240 m.

clear
close all
clc
figs = gobjects(0, 1);   % solo se exportan las figuras de este script

p = parametros_robot();
fprintf('Robot de Ramzy, Hammad y Maged (2024), Tabla 2.\n');
fprintf('l1 = %.3f m, l2 = %.3f m, l3 = %.3f m.\n\n', p.l1, p.l2, p.l3);

%% Directa contra las ecuaciones (6)-(8), e inversa
q_prueba = [0.4; 0.7; -0.8];
[xyz_m, ~, origenes] = cinematica_directa(q_prueba, p);
xyz_eq = posicion_paper(q_prueba, p);
fprintf('Error directa DHL vs ecuaciones (6)-(8): %.3e m\n', norm(xyz_m - xyz_eq));

q_inv = cinematica_inversa(xyz_m, p, -1, 1);
[xyz_vuelta, ~, ~] = cinematica_directa(q_inv, p);
fprintf('Error inversa luego directa: %.3e m\n', norm(xyz_m - xyz_vuelta));
fprintf('q pedido     = [% .4f % .4f % .4f] rad\n', q_prueba);
fprintf('q recuperado = [% .4f % .4f % .4f] rad\n\n', q_inv);

%% Inversa: las cuatro soluciones del mismo punto
[Q_sol, etiquetas] = cinematica_inversa_todas(xyz_m, p);
if all(isnan(Q_sol(:)))
    error('La punta de q de prueba es alcanzable y la inversa no dio ninguna solución.');
end
fprintf('Cuatro soluciones de la inversa para la punta de q de prueba:\n');
for k = 1:4
    if any(isnan(Q_sol(:, k)))
        fprintf('  %-18s sin solución\n', etiquetas(k));
        continue
    end
    err_k = norm(cinematica_directa(Q_sol(:, k), p) - xyz_m);
    dentro = all(Q_sol(:, k) >= p.qmin - 1e-12 & Q_sol(:, k) <= p.qmax + 1e-12);
    if dentro
        txt_lim = 'dentro de límites';
    else
        txt_lim = 'FUERA de límites';
    end
    fprintf('  %-18s q = [% .4f % .4f % .4f] rad, error directa = %.1e m, %s\n', ...
        etiquetas(k), Q_sol(:, k), err_k, txt_lim);
end
fprintf('\n');

%% La inversa impresa del paper, ecuaciones (9)-(12), no cierra esta directa
x = xyz_eq(1);
y = xyz_eq(2);
z = xyz_eq(3);
arg_paper = (x^2 + y^2 + z^2 - (p.l2^2) * (p.l3^2)) / (2 * p.l2 * p.l3);
fprintf('Argumento del arccos de la ecuación (11) en este punto: %.3f\n', arg_paper);
fprintf('Queda fuera de [-1, 1]. Esa inversa no se usa.\n\n');

%% Singularidades: codo estirado, codo plegado, punta en el eje de q1
q_reg = q_prueba;
q_est = [0.2; 0.4; 0];
q_ple = [0.2; 0.4; pi];
% A = l2*cos(q2)+l3*cos(q2+q3) = 0 con q2 = 2*pi/3, sin dejar q3 en 0 o pi.
q2e = 2 * pi / 3;
c23 = -(p.l2 / p.l3) * cos(q2e);
q3e = acos(c23) - q2e;
q_eje = [0.4; q2e; q3e];
Areg = p.l2 * cos(q_reg(2)) + p.l3 * cos(q_reg(2) + q_reg(3));
det_cerrado = -Areg * p.l2 * p.l3 * sin(q_reg(3));
fprintf('det J regular              = %.6f\n', det(jacobiano_posicion(q_reg, p)));
fprintf('det cerrado - det J        = %.3e\n', det_cerrado - det(jacobiano_posicion(q_reg, p)));
fprintf('det J codo estirado        = %.3e\n', det(jacobiano_posicion(q_est, p)));
fprintf('det J codo plegado         = %.3e\n', det(jacobiano_posicion(q_ple, p)));
punta_eje = cinematica_directa(q_eje, p);
fprintf('det J punta en el eje de q1 = %.3e\n', det(jacobiano_posicion(q_eje, p)));
fprintf('sin(q3) en esa postura     = %.3f\n', sin(q_eje(3)));
fprintf('punta en esa postura (m)   = [% .3e % .3e % .4f]\n\n', punta_eje);

% Mapa de singularidades. det J no depende de q1, así que basta el plano
% (q2, q3). Las curvas de nivel cero son sin(q3) = 0 y A = 0.
[Q2m, Q3m] = meshgrid(linspace(p.qmin(2), p.qmax(2), 121), ...
                      linspace(p.qmin(3), p.qmax(3), 121));
Am = p.l2 * cos(Q2m) + p.l3 * cos(Q2m + Q3m);
detJm = -Am * p.l2 * p.l3 .* sin(Q3m);

%% Cinemática diferencial: v = J(q) qp
% 1) Jacobiano analítico contra diferencias centrales de la directa.
dq = 1e-6;
J_num = zeros(3);
for i = 1:3
    e_i = zeros(3, 1);
    e_i(i) = dq;
    J_num(:, i) = (cinematica_directa(q_prueba + e_i, p) - ...
                   cinematica_directa(q_prueba - e_i, p)) / (2 * dq);
end
fprintf('Jacobiano analítico vs numérico: max |dif| = %.3e\n', ...
    max(abs(jacobiano_posicion(q_prueba, p) - J_num), [], 'all'));

% 2) Velocidad de la punta sobre una trayectoria articular quíntica:
%    v = J(q) qp contra la derivada numérica de la posición.
t_dif = 0:0.01:3;
[q_dif, qp_dif, ~] = interpolador_articular([0.2; 0.3; -0.4], [1.0; 0.9; -1.2], ...
                                            t_dif, "quintica");
v_jac = zeros(3, numel(t_dif));
pos_dif = zeros(3, numel(t_dif));
manip_dif = zeros(1, numel(t_dif));
for k = 1:numel(t_dif)
    Jk = jacobiano_posicion(q_dif(:, k), p);
    v_jac(:, k) = Jk * qp_dif(:, k);
    pos_dif(:, k) = cinematica_directa(q_dif(:, k), p);
    manip_dif(k) = abs(det(Jk));
end
v_num = zeros(3, numel(t_dif));
for i = 1:3
    v_num(i, :) = gradient(pos_dif(i, :), t_dif);
end
fprintf('Velocidad J*qp vs derivada numérica: max |dif| = %.3e m/s (vel. máx %.3f m/s)\n\n', ...
    max(abs(v_jac(:, 2:end-1) - v_num(:, 2:end-1)), [], 'all'), max(vecnorm(v_jac)));

%% Control de posición. Ley de la clase 7: qp = pinv(J) * K * tanh(e), K = 8 I
q_meta = [0.4; 0.8; -0.7];
objetivo = cinematica_directa(q_meta, p);
q = [0.15; 0.55; -0.4];
tf = 8;
ts = 0.05;
Kpos = 8 * eye(3);
N = floor(tf / ts);
historia = zeros(3, N + 1);
qs = zeros(3, N + 1);
historia(:, 1) = cinematica_directa(q, p);
qs(:, 1) = q;
nfin = 1;
singular = false;
for k = 1:N
    e = objetivo - historia(:, nfin);
    J = jacobiano_posicion(q, p);
    if abs(det(J)) < 1e-4
        singular = true;
        break
    end
    qp = pinv(J) * (Kpos * tanh(e));
    q = q + ts * qp;
    nfin = k + 1;
    qs(:, nfin) = q;
    historia(:, nfin) = cinematica_directa(q, p);
end
fprintf('Control de posición. Error final = %.3e m. Pasos = %d.\n', ...
    norm(objetivo - historia(:, nfin)), nfin - 1);
if singular
    fprintf('Se detuvo: |det J| < 1e-4.\n');
end

%% Seguimiento cartesiano. Ley de la clase 7: qp = pinv(J) * (hd_punto + K e)
tf2 = 20;
ts2 = 0.05;
t2 = 0:ts2:tf2;
N2 = numel(t2);
centro = cinematica_directa([0.5; 0.9; -0.8], p);
hd = zeros(3, N2);
hdp = zeros(3, N2);
for k = 1:N2
    tk = t2(k);
    hd(:, k) = centro + [0.03 * cos(0.3 * tk); ...
                         0.03 * sin(0.3 * tk); ...
                         0.02 * sin(0.5 * tk)];
    hdp(:, k) = [-0.03 * 0.3 * sin(0.3 * tk); ...
                  0.03 * 0.3 * cos(0.3 * tk); ...
                  0.02 * 0.5 * cos(0.5 * tk)];
end
q = cinematica_inversa(hd(:, 1), p, -1, 1);
h = zeros(3, N2);
h(:, 1) = cinematica_directa(q, p);
singular_seg = false;
for k = 1:N2 - 1
    e = hd(:, k) - h(:, k);
    J = jacobiano_posicion(q, p);
    if abs(det(J)) < 1e-4
        singular_seg = true;
        h = h(:, 1:k);
        hd = hd(:, 1:k);
        break
    end
    qp = pinv(J) * (hdp(:, k) + e);
    q = q + ts2 * qp;
    h(:, k + 1) = cinematica_directa(q, p);
end
err_seg = vecnorm(hd - h);
fprintf('Seguimiento. Error máximo = %.4e m. Error final = %.4e m.\n', ...
    max(err_seg), err_seg(end));
if singular_seg
    fprintf('El seguimiento se detuvo: |det J| < 1e-4.\n');
end
fprintf('\n');

%% Punto a punto articular. Polinomios de la clase 6
t_pol = 0:0.1:3;
qi = cinematica_inversa(cinematica_directa([0.3; 0.6; -0.5], p), p, -1, 1);
qf = cinematica_inversa(cinematica_directa([0.7; 1.0; -0.9], p), p, -1, 1);
[q_cub, qp_cub, ~] = interpolador_articular(qi, qf, t_pol, "cubica");
[~, ~, qpp_qui] = interpolador_articular(qi, qf, t_pol, "quintica");
fprintf('Cúbica: velocidad inicial = %.3e, final = %.3e rad/s\n', ...
    norm(qp_cub(:, 1)), norm(qp_cub(:, end)));
fprintf('Quíntica: aceleración inicial = %.3e, final = %.3e rad/s^2\n', ...
    norm(qpp_qui(:, 1)), norm(qpp_qui(:, end)));

punta_cub = zeros(3, numel(t_pol));
for k = 1:numel(t_pol)
    punta_cub(:, k) = cinematica_directa(q_cub(:, k), p);
end

%% Espacio de trabajo (Figuras 4 y 5 del artículo)
[P_ws, P_corte] = espacio_trabajo(p, 25);
fprintf('Espacio de trabajo con los límites supuestos (m):\n');
fprintf('  x en [% .3f, % .3f], y en [% .3f, % .3f], z en [% .3f, % .3f]\n', ...
    min(P_ws(1, :)), max(P_ws(1, :)), min(P_ws(2, :)), max(P_ws(2, :)), ...
    min(P_ws(3, :)), max(P_ws(3, :)));
fprintf('  alcance máximo desde la base = %.3f m (l1 + l2 + l3 = %.3f m)\n\n', ...
    max(vecnorm(P_ws)), p.l1 + p.l2 + p.l3);

%% Validación contra la Tabla 3 del artículo
val = validar_tabla3(p);

%% Esquemas
figs(end + 1) = figure('Name', 'Cadena en la postura de prueba');
plot3(origenes(1, :), origenes(2, :), origenes(3, :), 'k-o', 'LineWidth', 2)
hold on
plot3(xyz_m(1), xyz_m(2), xyz_m(3), 'r*')
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Cadena en q de prueba')

figs(end + 1) = figure('Name', 'Espacio de trabajo');
subplot(1, 2, 1)
plot3(P_ws(1, :), P_ws(2, :), P_ws(3, :), 'b.', 'MarkerSize', 2)
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Espacio de trabajo 3D')
subplot(1, 2, 2)
plot(P_corte(2, :), P_corte(3, :), 'b+', 'MarkerSize', 3)
grid on
axis equal
xlabel('y (m)')
ylabel('z (m)')
title('Corte x = 0')

figs(end + 1) = figure('Name', 'Singularidades');
subplot(1, 2, 1)
contourf(rad2deg(Q2m), rad2deg(Q3m), detJm, 20, 'LineStyle', 'none')
hold on
contour(rad2deg(Q2m), rad2deg(Q3m), detJm, [0 0], 'r', 'LineWidth', 2)
colorbar
xlabel('q_2 (°)')
ylabel('q_3 (°)')
title('det J (rojo: det J = 0)')
subplot(1, 2, 2)
plot(t_dif, manip_dif)
grid on
xlabel('t (s)')
ylabel('|det J|')
title('Manipulabilidad')

figs(end + 1) = figure('Name', 'Cinemática diferencial');
plot(t_dif, v_jac', 'LineWidth', 1.5)
hold on
plot(t_dif, v_num', 'k--')
grid on
xlabel('t (s)')
ylabel('v (m/s)')
title('Velocidad: J·qp y derivada numérica')
legend('v_x', 'v_y', 'v_z', 'Location', 'best')

figs(end + 1) = figure('Name', 'Validación Tabla 3');
subplot(1, 2, 1)
plot(val.experimental(:, 2), val.modelo(:, 2), 'bo', ...
     val.experimental(:, 3), val.modelo(:, 3), 'rs', ...
     val.experimental(:, 1), val.modelo(:, 1), 'g^')
hold on
lims = [min([val.experimental(:); val.modelo(:)]), max([val.experimental(:); val.modelo(:)])];
plot(lims, lims, 'k--')
grid on
axis equal
xlabel('Experimental, Tabla 3 (mm)')
ylabel('Modelo con Tabla 2 (mm)')
title('Modelo vs medición')
legend('y', 'z', 'x', 'ideal', 'Location', 'best')
subplot(1, 2, 2)
bar([sqrt(sum(val.err_exp .^ 2, 2, 'omitnan')), sqrt(sum(val.err_teo .^ 2, 2, 'omitnan'))])
grid on
xlabel('Postura de la Tabla 3')
ylabel('Error (mm)')
legend('vs experimental', 'vs teórica del artículo', 'Location', 'best')
title('Error por postura')

figs(end + 1) = figure('Name', 'Error de control');
subplot(2, 1, 1)
t_pos = (0:nfin - 1) * ts;
semilogy(t_pos, vecnorm(objetivo - historia(:, 1:nfin)))
grid on
xlabel('t (s)')
ylabel('||e|| (m)')
title('Control de posición: norma del error')
subplot(2, 1, 2)
plot(t2(1:numel(err_seg)), err_seg)
grid on
xlabel('t (s)')
ylabel('||e|| (m)')
title('Seguimiento: norma del error')

figs(end + 1) = figure('Name', 'Control de posición');
plot3(historia(1, 1:nfin), historia(2, 1:nfin), historia(3, 1:nfin), 'b')
hold on
[~, ~, cad0] = cinematica_directa(qs(:, 1), p);
[~, ~, cadf] = cinematica_directa(qs(:, nfin), p);
plot3(cad0(1, :), cad0(2, :), cad0(3, :), 'k-o')
plot3(cadf(1, :), cadf(2, :), cadf(3, :), 'g-o')
plot3(objetivo(1), objetivo(2), objetivo(3), 'r*')
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Control de posición')
legend('punta', 'inicio', 'final', 'objetivo', 'Location', 'best')

figs(end + 1) = figure('Name', 'Seguimiento');
plot3(hd(1, :), hd(2, :), hd(3, :), 'k--')
hold on
plot3(h(1, :), h(2, :), h(3, :), 'b')
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Seguimiento cartesiano')
legend('referencia', 'punta', 'Location', 'best')

figs(end + 1) = figure('Name', 'Interpolador cúbico');
subplot(2, 1, 1)
plot(t_pol, q_cub')
grid on
ylabel('q (rad)')
title('Polinomio cúbico q(t)')
legend('q1', 'q2', 'q3')
subplot(2, 1, 2)
plot3(punta_cub(1, :), punta_cub(2, :), punta_cub(3, :), 'b')
grid on
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Trayectoria de la punta')

fprintf('\nOrígenes de la cadena en q de prueba (columnas: base, 1, 2, punta):\n')
disp(origenes)

%% Guardar las figuras para los anexos del informe
carpeta = 'figuras';
if ~exist(carpeta, 'dir')
    mkdir(carpeta);
end
for k = 1:numel(figs)
    nombre = lower(strrep(figs(k).Name, ' ', '_'));
    nombre = char(replace(nombre, ["á", "é", "í", "ó", "ú", "ñ"], ["a", "e", "i", "o", "u", "n"]));
    nombre = regexprep(nombre, '[^a-z0-9_]', '');
    % El prefijo numérico ordena los anexos y evita choques de nombres.
    archivo = fullfile(carpeta, sprintf('%02d_%s.png', k, nombre));
    if exist('exportgraphics', 'file')
        exportgraphics(figs(k), archivo, 'Resolution', 200);
    else
        saveas(figs(k), archivo);
    end
end
fprintf('Figuras guardadas en %s\n', carpeta);

function xyz = posicion_paper(q, p)
q1 = q(1);
q2 = q(2);
q3 = q(3);
A = p.l2 * cos(q2) + p.l3 * cos(q2 + q3);
xyz = [cos(q1) * A; ...
       sin(q1) * A; ...
       p.l1 + p.l2 * sin(q2) + p.l3 * sin(q2 + q3)];
end
