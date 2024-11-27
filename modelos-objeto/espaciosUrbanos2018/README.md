# Espacios urbanos
### Contenido a evaluar
- Composición / Correcta delegación
- Polimorfismo
- Herencia / Redefinición
- Template method o correcto uso de super 
- Composite / Strategy
- Diferenciar clases e instancias
- Manejo de errores

La secretaría de Infraestructura y Mantenimiento de Espacios Verdes de un municipio nos solicita que generemos un modelo para representar su dominio, que consiste en hacer un seguimiento a los trabajos de mejora de cada uno de los diferentes espacios urbanos:
- **plazas**: tienen un espacio específico dedicado al esparcimiento, además sabemos cuántas canchas tienen
- **plazoletas**: delimitan un pequeño espacio medido en metros cuadrados donde no hay césped y rinden homenaje a algún prócer
- **anfiteatros**: tienen una capacidad (ej: 1.000 personas), un escenario con un tamaño medido en metros cuadrados
- **multiespacio**: está conformado por una serie de plazas, plazoletas, anfiteatros o multiespacios.
Todos los espacios urbanos son activos del municipio, por lo tanto tienen una valuación en pesos, tienen una superficie medida en metros cuadrados, llevan un nombre: “Plaza Ciudad de Banff”, “Anfiteatro Parque Centenario”, y sabemos si tienen vallado que se cierra de noche. Periódicamente hay personas que hacen diferentes trabajos a cualquiera de estos espacios urbanos, como veremos más adelante. 

## 1- Espacios urbanos grandes (3 puntos)
Queremos saber si un espacio urbano es grande, esto se da 
1. para todos los espacios urbanos si la superficie total supera los 50 metros cuadrados y además
2. para las plazas, si tienen más de 2 canchas
3. para las plazoletas, si el prócer es “San Martín” y de noche se cierra con llave
4. para los anfiteatros, si la capacidad supera las 500 personas
5. para los multiespacios, si cumplen todas las condiciones de los espacios urbanos que contienen (ej, si tienen una plaza y una plazoleta, deben satisfacer ambas restricciones a la vez)
No debe repetir código ni ideas de diseño. 

## 2- Trabajadores (5 puntos)
Todas las personas tienen una profesión en algún momento. Queremos que esa profesión pueda cambiar a lo largo del tiempo. Las profesiones determinan varias cosas:
1. Los **cerrajeros** pueden trabajar con cualquier espacio urbano que no tenga vallado. Una vez cumplido el trabajo el espacio urbano queda con un vallado que se cierra de noche. La duración del trabajo de cerrajero es de 5 horas si el espacio es grande o 3 en caso contrario. 
2. Los **jardineros** trabajan con espacios urbanos verdes, que son únicamente las plazas que no tienen canchas o los multiespacios que contienen más de 3 espacios urbanos. Una vez cumplido su trabajo el césped se ve “más lindo”, lo que aumenta la valuación del espacio urbano un 10%. La duración de su trabajo es 1 hora cada 10 metros cuadrados. Si tenemos 85 metros cuadrados, está bien considerar 8,5 (no es importante la exactitud en el parcial, estamos evaluando conocimientos del paradigma). 
3. Los **encargados** de limpieza traen una hidrolavadora gigante, trabajan con espacios urbanos “limpiables”, que son los anfiteatros grandes y las plazas (no con plazoletas ni con multiespacios). Una vez cumplido su trabajo el espacio urbano se valúa en $ 5.000 más. La duración de su trabajo es 8 horas fijo (un día de trabajo).
4. El costo de cada trabajador se estima en $ 100 la hora para todos los trabajadores, menos para los jardineros que siempre cobran $ 2.500 por trabajo realizado. El valor hora del trabajador puede cambiar.
Muestre cómo haría en la consola REPL para que una persona llamada Tito comience siendo cerrajero y luego pase a ser jardinero.

## 3- Registro de trabajo realizado (4 puntos)
Queremos registrar un trabajo, para lo cual 
- queremos validar que la persona pueda hacer dicho trabajo (según lo definido en el punto 2), en caso de no pasar dicha validación debe informar de la manera que cree más conveniente al usuario
- a partir de aquí asumimos que pasó la validación para lo cual, debe producir efecto en el espacio urbano (el efecto que causa el trabajo de dicha persona)
- por último debemos registrar la fecha y asociar la persona que realizó el trabajo con el espacio urbano involucrado, además de la duración y el costo a ese momento.

## 4- Espacios urbanos de “uso intensivo” (3 puntos)
Queremos detectar los espacios urbanos “de uso intensivo”, que son aquellos en los que en el último mes se le hicieron más de 5 trabajos “heavies”. Un trabajo heavy depende de la profesión:
- para los cerrajeros si tardó más de 5 horas o costó más de $ 10.000
- para los encargados de limpieza si costó más de $ 10.000
- para los jardineros si costó más de $ 10.000
No debe repetir código ni ideas de diseño.
