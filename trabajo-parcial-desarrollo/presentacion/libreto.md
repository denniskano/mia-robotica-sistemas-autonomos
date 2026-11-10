# Libreto de la exposición

Sigue `presentacion.pdf`. Trece láminas. La voz de cada una es una propuesta: el docente puede preguntarle a cualquiera, así que las respuestas del final las tiene que poder decir todo el grupo.

El ritmo de abajo es para ensayar. El docente no fijó una duración en el material que leímos.

## 1. Portada

Voz: Koc. Unos 20 segundos.

Buenas noches. Somos el grupo del trabajo parcial de Robótica y sistemas autónomos. El caso es el manipulador de tres grados de libertad de Ramzy, Hammad y Maged, 2024. Simulamos en MATLAB la cinemática, las singularidades y el control cinemático, y comprobamos el resultado contra lo que el artículo reporta.

## 2. Lo que se pidió, en una pasada

Voz: Meléndez. Unos 40 segundos.

El parcial pide cinco cosas. La directa: dónde está la punta. La inversa: qué ángulos la llevan ahí. La diferencial: cómo se mueve. Las singularidades: dónde se traba. Y el control, en el espacio articular y en el cartesiano. Además mostramos el volumen que alcanza y la comparación con la medición del artículo.

El brazo es un banco real de tres rotativas. Los largos salen de la Tabla 2: 4 centímetros, 29 centímetros y 24 centímetros. La primera articulación gira en la vertical. Las otras dos, en ejes horizontales paralelos. Masas, resortes y amortiguadores están en esa misma tabla y no entran en esta simulación. Quedan para la dinámica.

## 3. La cadena del banco, en la postura de prueba

Voz: Mancilla. Unos 45 segundos. Señalar la base, el codo y la punta roja.

Esta es la cadena en la postura de prueba: 0,4, 0,7 y menos 0,8 radianes. La armamos con el Denavit–Hartenberg de la clase, no con la matriz (2) impresa. Esa matriz deja en cero una fila de la rotación que, con el giro de 90 grados, vale 0, 1, 0.

La posición que sale es la de las ecuaciones (6) a (8) del artículo. En esta postura las dos cuentas difieren en cero. La punta está a unos 42 centímetros en x, 18 en y y 20 en z.

## 4. La misma punta, cuatro posturas

Voz: Paitan. Unos 50 segundos. Señalar primero las dos tarjetas rojas y después las grises.

La inversa es la geométrica de la clase 3. Hay dos cinturas y dos codos, así que el mismo punto tiene hasta cuatro posturas. Las cuatro regresan a la punta con un error del orden de 10 a la menos 16 metros.

Las dos de la izquierda respetan los límites que adoptamos. La de arriba a la izquierda es la postura de la que partimos. Las dos de la derecha quedan fuera.

No usamos la inversa que el artículo imprime en (9) a (12). En este punto le pide a un arco coseno el valor 1,785, que está fuera de rango. La fórmula publicada no cierra con su propia directa.

## 5. El volumen que el brazo alcanza

Voz: Gutierrez. Unos 40 segundos. Señalar la herradura de la derecha.

A la izquierda, la nube de puntos que la directa alcanza. A la derecha, el corte x igual a cero. Tiene la forma de herradura de la Figura 5 del artículo. El alcance máximo es 57 centímetros, la suma de los tres largos.

El artículo no publica los límites articulares. Los que usamos, de menos 180 a 180 en la cintura, de menos 30 a 90 en el hombro y de menos 120 a 120 en el codo, se eligieron para que ese corte se parezca a la figura. Son un supuesto de la simulación, no una medida del banco.

## 6. El jacobiano predice la velocidad de la punta

Voz: Dávila. Unos 40 segundos. Señalar que las curvas de color y las negras van juntas.

El jacobiano de posición es la derivada de (6) a (8). En color está J por q punto. En negro, la derivada numérica de la posición de la punta. Se superponen. La diferencia máxima es del orden de 10 a la menos 5 metros por segundo, y es el truncamiento de esa derivada, no un desacuerdo del modelo.

En la postura de prueba el determinante vale unos 0,023. La fórmula cerrada, menos A por l2 por l3 por seno de q3, da el mismo número.

## 7. Dónde el robot pierde un grado de libertad

Voz: Koc. Unos 45 segundos. Señalar la cruz roja de la izquierda y la curva de la derecha.

El determinante se anula en dos casos. Si el seno de q3 es cero, el codo está estirado o plegado. Eso es la raya horizontal roja. Si A es cero, la punta cae sobre el eje de la cintura, y el brazo sí puede llegar ahí con el codo a medio flexionar. Eso es la raya inclinada.

A la derecha, el valor absoluto del determinante durante la trayectoria quíntica de 3 segundos. Sube y se mantiene lejos de cero: esa trayectoria no pasa por una singularidad. Si en el control el determinante baja de 10 a la menos 4, el lazo se detiene.

## 8. Punto a punto: sale y llega en reposo

Voz: Meléndez. Unos 40 segundos. Señalar que las tres curvas arrancan planas y terminan planas.

Esta es la opción articular de la clase 6. Un polinomio cúbico de 3 segundos lleva las tres articulaciones de una postura a otra. La velocidad en los extremos es cero: por eso las curvas nacen y mueren horizontales.

Abajo, esa misma q de t pasada por la directa. La punta recorre una curva suave en el espacio. Con esto el parcial ya cubre el control que el docente dejó como opción mínima. La que sigue es la cartesiana.

## 9. El control cartesiano lleva la punta al blanco

Voz: Mancilla. Unos 40 segundos. Señalar la cadena negra, la verde y la estrella.

Partimos de 0,15, 0,55 y menos 0,4 radianes. El blanco es la punta de otra postura: 40,6 por 17,2 por 27,2 centímetros. La cadena negra es el inicio. La verde es el final. La estrella es el objetivo, y la punta llega encima.

La ley es la de la clase 7: q punto igual a la pseudoinversa de J por K por tangente hiperbólica del error, con K igual a 8 veces la identidad. El error final queda en el orden de 10 a la menos 16 metros.

## 10. Y la punta sigue la curva

Voz: Paitan. Unos 35 segundos. Señalar que la línea azul tapa a la punteada.

Aquí la referencia se mueve. Es una curva alrededor de la punta de 0,5, 0,9 y menos 0,8 radianes, con amplitudes de 3, 3 y 2 centímetros. La ley suma la velocidad deseada: q punto igual a la pseudoinversa por h punto deseado más K por el error, y K es la identidad.

La referencia y la punta se ven como una sola línea. El error máximo es 1,4 por 10 a la menos 4 metros.

## 11. El error de posición desaparece

Voz: Gutierrez. Unos 35 segundos. Señalar la escala logarítmica de arriba.

Arriba, el control de posición. El eje es logarítmico. El error baja durante unos 4 segundos y se queda en 10 a la menos 16 metros. Abajo, el seguimiento durante 20 segundos. El error oscila y no pasa de 0,14 milímetros.

Las dos leyes usan la pseudoinversa. Lejos de la singularidad coincide con la inversa. Cerca, el script corta el paso en lugar de dejar crecer q punto.

## 12. El modelo cae sobre la medición del artículo

Voz: Dávila. Unos 55 segundos. Señalar la recta de la izquierda y, a la derecha, que las barras no se disparan.

El artículo midió 26 posturas con cámara. A la izquierda, lo que calcula nuestro modelo contra lo que midió la cámara. Los puntos caen sobre la recta.

El error medio es 1 milímetro en x, 1,73 en y y 3,49 en z. El artículo reporta, para su propio modelo contra esa misma cámara, 2,90, 2,29 y 2,40 milímetros. Estamos en el mismo orden.

Dos celdas de la Tabla 3 no se leen como están impresas. En las filas 19 a 26, q3 figura como más 6,6 grados. Con el signo negativo, la z de la última fila pasa de 85 milímetros a unos 30, que es lo que el artículo reporta. Y la x teórica de esa fila está impresa en cero; con la cintura a 88,69 grados vale unos 12 milímetros, así que esa celda se dejó fuera.

La simulación conserva l2 en 0,29 metros, el valor de la Tabla 2. La columna teórica del artículo se acerca más si l2 vale unos 0,295 metros. No cambiamos el largo para perseguir esa columna.

## 13. Tres resultados para llevar

Voz: Koc. Unos 40 segundos.

Tres números. Cero: la directa contra las ecuaciones (6) a (8). Entre 1 y 3,5 milímetros: el error medio contra la cámara. Menos de 0,2 milímetros: el seguimiento de la trayectoria.

El modelo cinemático del artículo, con los metros que publica, se sostiene. La dinámica, con las masas y los resortes de la Tabla 2, es el paso que sigue. Gracias.

## Si preguntan

Cualquiera del grupo.

**¿Por qué no el robot de la práctica?** El de la práctica es el SCARA del G1, dos rotativas y una prismática. El parcial pide un antropomórfico de tres rotativas, sacado de un paper.

**¿Por qué rígido, si el paper es flexible?** El propio artículo dice que, para la posición, el brazo se puede tratar como rígido. La cámara lo confirma en el orden de milímetros. Para la dinámica esa decisión no alcanza: ahí entran los resortes.

**¿Por qué no copiaron la inversa del paper?** Porque no devuelve la postura. El arco coseno de (11) recibe 1,785.

**¿Esos límites son del banco?** No. El artículo no los imprime. Los pusimos para reproducir la herradura de la Figura 5.

**¿Y los 0,295 metros?** Es el l2 que ajusta la columna teórica de la Tabla 3. La Tabla 2 y las matrices imprimen 0,29. La simulación se quedó con el valor publicado. Los cinco milímetros hay que medirlos en el prototipo antes de la dinámica.

**¿Qué control van a defender?** Los dos están corridos. El articular cubre la opción de la clase 6. El cartesiano es el que usa el jacobiano, y es el que defenderíamos como cierre.

**¿Qué pasa en una singularidad?** El determinante se hace cero, una velocidad de la punta exigiría una velocidad articular infinita, y el lazo se detiene si el determinante baja de 10 a la menos 4. Parar evita el disparo. Si la tarea obliga a pasar cerca del codo estirado, esa parada se queda corta.
