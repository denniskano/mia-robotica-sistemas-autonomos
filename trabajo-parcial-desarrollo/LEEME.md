# Trabajo parcial — desarrollo

Simulación del antropomórfico de 3 grados de libertad de Ramzy, Hammad y Maged (2024): cinemática directa, inversa, diferencial, singularidades y control cinemático. El PDF está en `fuentes/applsci-14-05285-v2.pdf`.

Esta carpeta no reemplaza el enunciado. El informe para entregar es `informe/informe.pdf`. Faltan el nombre en la carátula, el logotipo de la UNI, el nombre oficial de la maestría y la opinión personal con tus palabras.

## Cómo correrlo

En MATLAB Online, sube la carpeta `matlab/` y, desde esa carpeta, ejecuta:

```matlab
simular_parcial
```

No hace falta Robotics System Toolbox. El archivo imprime los errores, abre las figuras y las guarda en PNG dentro de `matlab/figuras/`, para pegarlas en los anexos del informe.

Los largos son los de la Tabla 2: \(l_1 = 0{,}04\) m, \(l_2 = 0{,}29\) m, \(l_3 = 0{,}240\) m. Masas, centros de masa, momentos, resortes y amortiguadores de esa tabla no entran en este script.

## Qué calcula

| Sección | Archivo | Resultado |
| --- | --- | --- |
| Directa | `cinematica_directa.m` | DHL contra las ecuaciones (6)–(8) del artículo |
| Inversa | `cinematica_inversa.m`, `cinematica_inversa_todas.m` | Las cuatro soluciones (cintura ± y codo ±), con su error al volver por la directa y si respetan los límites |
| Diferencial | `jacobiano_posicion.m` | \(J\) analítico contra diferencias centrales, y \(v = J\dot q\) contra la derivada numérica de la posición sobre una quíntica |
| Singularidades | `jacobiano_posicion.m` | Tres posturas singulares y el mapa de \(\det J(q_2,q_3)\) |
| Espacio de trabajo | `espacio_trabajo.m` | Nube 3D y corte \(x = 0\), para comparar con las Figuras 4 y 5 |
| Validación | `validar_tabla3.m` | Error del modelo contra las 26 posturas de la Tabla 3 y ajuste de largos |
| Control | `simular_parcial.m` | Posición (tanh), seguimiento y punto a punto (cúbica y quíntica), con la norma del error en el tiempo |

### Supuestos y erratas del artículo

- El artículo no publica límites articulares. En `parametros_robot.m` se usan \(q_1 \in [-180^\circ, 180^\circ]\), \(q_2 \in [-30^\circ, 90^\circ]\) y \(q_3 \in [-120^\circ, 120^\circ]\). Se eligieron porque el corte \(x = 0\) que dan tiene la forma de herradura de la Figura 5.
- Tabla 3, filas 19 a 26: se imprime \(q_3 = 6{,}6^\circ\). Con ese signo, la \(z\) de la fila 26 da 84,9 mm; con \(-6{,}6^\circ\) da 29,8 mm, y el artículo reporta 29,92 mm. Se usa \(-6{,}6^\circ\).
- Tabla 3, fila 26: la \(x\) teórica se imprime 0. Con \(q_1 = 88{,}69^\circ\) es de unos 12 mm, así que esa celda no se usa.
- La columna teórica de la Tabla 3 no sale con \(l_2 = 0{,}29\) m. Ajustando los largos por mínimos cuadrados queda \(l_2 \approx 0{,}295\) m, y con eso el error contra esa columna baja a menos de 0,6 mm. Con los largos de la Tabla 2, el error medio contra la medición es de unos 2–3 mm, del orden del que reporta el artículo.
- Matriz (2): la tercera fila de la rotación se imprime en ceros y debería ser \([0, 1, 0]\). Matriz (3): el elemento (3,3) se imprime 0 y debería ser 1. Matriz (5): la última fila se imprime \([0, 0, 0, 0]\) y debería ser \([0, 0, 0, 1]\).
- Ecuación (11): se imprime \(l_2^2\, l_3^2\) (un producto). Aun corrigiéndola a \(-l_2^2 - l_3^2\), no recupera la directa (6)–(8), porque no resta \(l_1\) a \(z\) y le asigna a \(\theta_2\) el ángulo que corresponde a \(\theta_3\).

## Qué hay

| Carpeta | Contenido |
| --- | --- |
| `investigacion/` | Enunciado, clases, modelo y lo que el docente pide |
| `matlab/` | Simulación |
| `informe/` | Borrador y PDF |
| `fuentes/` | El artículo y `resumen-ramzy-2024.md` |

No se usó `videos/`. Las transcripciones de las clases 1 a 6 y `tips-trabajo-parcial-final.txt` están resumidas, en lo que toca al encargo, en `investigacion/05-como-pide-el-profesor.md`.
