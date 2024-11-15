# Prolog de la Costa
## "Un parque donde reina la lógica y el entretenimiento"

El modelo de negocio de Prolog de la Costa es sencillo. Cada visitante debe pagar una entrada, cuyo precio varía entre adultos y chicos (siendo los chicos aquellos que aún no cumplieron 13). Una vez dentro del parque, todas las atracciones son gratuitas, y se contempla que los visitantes utilicen su dinero en los puestos de comida disponibles. La oferta gastronómica es amplia: hay hamburguesas por $2000, panchitos con papas por $1500, lomitos completos por $2500 y también un puesto de caramelos donde se pueden agarrar sin costo.

Sin embargo, el componente principal no es la comida, sino las atracciones, y Prolog de la Costa ofrece una gran variedad de entretenimiento. Por un lado están las atracciones para toda la familia, denominadas atracciones tranquilas, que pueden ser para chicos y adultos o exclusivas para chicos. Para chicos y adultos contamos con atracciones como los icónicos autitos chocadores, la casa embrujada o el laberinto, mientras que los chicos pueden divertirse lanzándose por el tobogán o subiéndose a la calesita.

Otro tipo de atracciones disponibles son las intensas, reservadas para quienes quieran una experiencia un poco más potente. Para cada atracción intensa se tiene registrado un coeficiente de lanzamiento, utilizado para calcular cuántos empleados de limpieza deben mantenerse cerca de los alrededores de la atracción. El barco pirata tiene el coeficiente más alto de todos, en 14, mientras que otras atracciones son menos brutales, como las tazas chinas en 6 y el simulador 3D en 2.

Pero el plato fuerte de Prolog de la Costa está en las clásicas montañas rusas, que le han dado prestigio internacional al parque. La información disponible acerca de estas atracciones es más técnica; por ejemplo, la emblemática Abismo Mortal Recargada tiene 3 giros invertidos y una duración de 2:14, mientras que Paseo por el Bosque presenta una experiencia menos vertiginosa, sin giros invertidos y una duración de tan solo 45 segundos. Estos son sólo dos ejemplos, pero el parque cuenta con una gran cantidad de montañas rusas.

Finalmente, de septiembre a marzo se habilitan las atracciones acuáticas, como El Torpedo Salpicón o Espero Que Hayas Traído Una Muda de Ropa.

Para poder administrar el parque de la forma más eficiente posible, en Prolog de la Costa se conoce al detalle la información de cada visitante. Algunos datos son más superficiales, como su nombre, dinero, edad o a qué grupo familiar pertenecen, mientras que otros son propios del sentimiento de la persona, como su hambre y aburrimiento. Por ejemplo, el grupo familiar Viejitos vino temprano hoy al parque y son dos personas: Eusebio tiene 80 años, $3000, 50 de hambre y 0 de aburrimiento. Su mujer Carmela tiene la misma edad, no trajo plata, y no tiene hambre pero sí 25 de aburrimiento. Hay más grupos, como los López, una familia que vino con sus dos hijas, o Promoción 23, un grupo de egresados que vino al parque, entre otros.

1. Diseñar la base de conocimiento. Incluir los puestos de comida, las atracciones, los visitantes del grupo Viejitos y dos personas que hayan venido solas.

2. Saber el estado de bienestar de un visitante.
   
   a. Si su hambre y aburrimiento son 0, siente felicidad plena.
   
   b. Si suman entre 1 y 50, podría estar mejor.
   
   c. Si suman entre 51 y 99, necesita entretenerse.
   
   d. Si suma 100 o más, se quiere ir a casa.
   Hay una excepción para los visitantes que vienen solos al parque: nunca pueden sentir felicidad plena, sino que podrían estar mejor también cuando su hambre y aburrimiento suman 0.

3. Saber si un grupo familiar puede satisfacer su hambre con cierta comida. Para que esto ocurra, cada integrante del grupo debe tener dinero suficiente como para comprarse esa comida y esa comida, a la vez, debe poder quitarle el hambre a cada persona. La hamburguesa satisface a quienes tienen menos de 50 de hambre; el panchito con papas sólo le quita el hambre a los chicos; y el lomito completo llena siempre a todo el mundo. Los caramelos son un caso particular: sólo satisfacen a las personas que no tienen dinero suficiente para pagar ninguna otra comida.

4. Saber si puede producirse una lluvia de hamburguesas. Esto ocurre para un visitante que puede pagar una hamburguesa al subirse a una atracción que:
   
   a. Es intensa con un coeficiente de lanzamiento mayor a 10, o
   
   b. Es una montaña rusa peligrosa, o
   
   c. Es el tobogán

La peligrosidad de las montañas rusas depende de la edad del visitante. Para los adultos sólo es peligrosa la montaña rusa con mayor cantidad de giros invertidos en todo el parque[^1], a menos que el visitante necesite entretenerse, en cuyo caso nada le parece peligroso. El criterio cambia para los chicos, donde independientemente de la cantidad de giros invertidos, los recorridos de más de un minuto de duración alcanzan para considerarla peligrosa.

5. Saber, para cada mes, las opciones de entretenimiento para un visitante. Esto debe incluir todos los puestos de comida en los cuales tiene dinero para comprar, todas las atracciones tranquilas a las que puede acceder (dependiendo su franja etaria), todas las atracciones intensas, todas las montañas rusas que no le sean peligrosas, y por último todas las atracciones acuáticas, siempre y cuando el mes de visita coincida con los meses de apertura. El resto de las atracciones están abiertas todo el año.
   Finalmente, una atracción tranquila exclusiva para chicos también puede ser opción de entretenimiento para un visitante adulto en el caso en que en el grupo familiar haya un chico a quien acompañar.
---
[^1]: Si hay dos montañas rusas con la misma cantidad de giros invertidos, ambas se consideran peligrosas, con la salvedad del caso mencionado a continuación en el texto.