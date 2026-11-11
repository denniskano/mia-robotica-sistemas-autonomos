function r = validar_tabla3(p)
% VALIDAR_TABLA3  Compara la directa con la Tabla 3 de Ramzy et al. (2024).
% La Tabla 3 trae 26 posturas (ángulos en grados), la posición medida con
% cámara ("Experimental") y la calculada por los autores ("Theoretical"),
% ambas en mm. Un guion en el artículo se guarda como NaN.
%
% Dos erratas del artículo, verificadas contra sus propios números:
%  1) En las filas 19 a 26 se imprime q3 = 6.6°. Con +6.6° la fila 26 da
%     z = 84.9 mm; con -6.6° da 29.8 mm, y el artículo reporta 29.92 mm.
%     Se usa q3 = -6.6°. En x e y el signo no cambia nada (coseno).
%  2) En la fila 26 la x teórica se imprime 0. Con q1 = 88.69° la x es
%     unos 12 mm. Esa celda se deja fuera (NaN).
%
% Además se ajustan por mínimos cuadrados l1, l2 y l3 a la columna
% teórica. La posición es lineal en los largos, así que basta "\".

%      q1      q2      q3     xe      ye       ze      xt      yt      zt
T = [88.69, 71.61, -86.82,   NaN, 326.45,  262.15,   NaN, 324.66,  256.96; ...
     88.69, 45.48, -74.17,   NaN, 414.10,  137.76,   NaN, 417.37,  135.11; ...
     88.69, 85.41,  -2.27,   NaN,  51.90,  565.35,   NaN,  52.27,  572.33; ...
     88.69,  5.74, -52.09,   NaN, 456.38, -101.60,   NaN, 459.18, -104.10; ...
     88.69,  6.01,  -6.01,   NaN, 527.89,   70.54,   NaN, 533.37,   70.88; ...
     88.69,  6.17, -85.62,   NaN, 336.84, -160.70,   NaN, 337.23, -164.20; ...
     88.69, 17.48,  -6.90,   NaN, 514.11,  171.89,   NaN, 517.29,  172.67; ...
     88.69, 17.54, -69.10,   NaN, 428.36,  -54.91,   NaN, 430.49,  -59.07; ...
     88.69, 29.90,  -5.93,   NaN, 472.40,  283.21,   NaN, 475.03,  284.55; ...
     88.69, 29.70, -39.05,   NaN, 489.56,  148.71,   NaN, 493.05,  147.16; ...
     88.69, 45.00,  -4.17,   NaN, 388.62,  403.97,   NaN, 390.19,  405.51; ...
     88.69, 45.78, -85.86,   NaN, 386.48,  100.25,   NaN, 389.37,   96.89; ...
     88.69, 58.52,  -4.14,   NaN, 292.44,  484.43,   NaN, 293.82,  486.67; ...
     88.69, 58.35, -43.16,   NaN, 384.95,  353.38,   NaN, 386.40,  354.00; ...
     88.69, 72.04,  -3.98,   NaN, 180.18,  541.90,   NaN, 180.63,  543.24; ...
     88.69, 71.44, -73.11,   NaN, 330.83,  313.12,   NaN, 333.79,  312.66; ...
     88.69, 85.61, -24.80,   NaN, 139.88,  540.29,   NaN, 139.63,  543.65; ...
     88.69, 85.07, -85.07,   NaN, 262.85,  332.92,   NaN, 265.35,  333.90; ...
     88.69,  1.88,   6.60, 12.13, 530.63,     NaN, 12.23, 534.86,     NaN; ...
     75.41,  1.88,   6.60, 134.46, 516.42,    NaN, 134.76, 517.74,    NaN; ...
     60.24,  1.88,   6.60, 263.01, 459.91,    NaN, 265.55, 464.44,    NaN; ...
     43.28,  1.88,   6.60, 385.56, 363.09,    NaN, 389.48, 366.77,    NaN; ...
     26.76,  1.88,   6.60, 474.75, 239.37,    NaN, 477.70, 240.88,    NaN; ...
     10.56,  1.88,   6.60, 519.42, 101.38,    NaN, 525.93,  98.04,    NaN; ...
     -3.09,  1.88,   6.60, 530.18, -28.58,    NaN, 534.22, -28.83,    NaN; ...
     88.69,  1.88,   6.60,   NaN, 532.18,   30.27,   NaN, 533.88,   29.92];

r.q_impreso = T(:, 1:3);
q = deg2rad(T(:, 1:3));
q(19:26, 3) = -q(19:26, 3);          % errata 1
r.q = q;
r.experimental = T(:, 4:6);
r.teorica = T(:, 7:9);
n = size(T, 1);

% Directa con los largos de la Tabla 2, en mm.
r.modelo = zeros(n, 3);
% Directa de las 26 posturas con los largos de la Tabla 2 (mm).
for k = 1:n
    r.modelo(k, :) = 1000 * cinematica_directa(q(k, :)', p)';
end
r.err_exp = r.modelo - r.experimental;
r.err_teo = r.modelo - r.teorica;

% Ajuste de largos a la columna teórica: posición = M(q) * [l1; l2; l3].
[M, b] = sistema_lineal(q, r.teorica);
r.largos_ajuste = (M \ b) / 1000;     % en m
pa = p;
pa.l1 = r.largos_ajuste(1);
pa.l2 = r.largos_ajuste(2);
pa.l3 = r.largos_ajuste(3);
pa.d1 = pa.l1;
pa.a2 = pa.l2;
pa.a3 = pa.l3;
r.modelo_ajuste = zeros(n, 3);
% Directa de las mismas posturas con los largos ajustados (mm).
for k = 1:n
    r.modelo_ajuste(k, :) = 1000 * cinematica_directa(q(k, :)', pa)';
end
r.err_teo_ajuste = r.modelo_ajuste - r.teorica;
r.err_exp_ajuste = r.modelo_ajuste - r.experimental;

fprintf('Validación contra la Tabla 3 (26 posturas, errores en mm):\n');
fprintf('%-38s %8s %8s %8s %8s\n', '', 'med|x|', 'med|y|', 'med|z|', 'máx');
imprimir('Tabla 2 vs experimental', r.err_exp);
imprimir('Tabla 2 vs teórica del artículo', r.err_teo);
imprimir('Ajuste vs teórica del artículo', r.err_teo_ajuste);
imprimir('Ajuste vs experimental', r.err_exp_ajuste);
fprintf('Errores medios que reporta el artículo (teórica vs exp.): 2.90  2.29  2.40\n');
fprintf('Largos ajustados a la teórica: l1 = %.4f m, l2 = %.4f m, l3 = %.4f m\n\n', ...
    r.largos_ajuste);
end

function [M, b] = sistema_lineal(q, ref)
M = [];
b = [];
% Arma filas de M y b con las posiciones teóricas de cada postura.
for k = 1:size(q, 1)
    c1 = cos(q(k, 1));
    s1 = sin(q(k, 1));
    c2 = cos(q(k, 2));
    s2 = sin(q(k, 2));
    c23 = cos(q(k, 2) + q(k, 3));
    s23 = sin(q(k, 2) + q(k, 3));
    filas = [0, c1 * c2, c1 * c23; ...
             0, s1 * c2, s1 * c23; ...
             1, s2,      s23];
    % Descarta las coordenadas que el artículo no reporta (NaN).
    for i = 1:3
        if ~isnan(ref(k, i))
            M = [M; filas(i, :)]; %#ok<AGROW>
            b = [b; ref(k, i)]; %#ok<AGROW>
        end
    end
end
end

function imprimir(nombre, E)
fprintf('%-38s %8.2f %8.2f %8.2f %8.2f\n', nombre, ...
    mean(abs(sin_nan(E(:, 1)))), mean(abs(sin_nan(E(:, 2)))), ...
    mean(abs(sin_nan(E(:, 3)))), max(abs(sin_nan(E(:)))));
end

function v = sin_nan(v)
v = v(~isnan(v));
end
