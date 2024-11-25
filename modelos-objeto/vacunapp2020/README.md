# TP 4 - Vacunapp
Son tiempos de esperanza y necesitan de nuestros servicios para modelar una aplicación (nunca mejor dicho) para vacunar a toda la población. Se pide que modele e implemente en Wollok lo que se pide a continuación.

## Punto 1: Vacunas
Tenemos las siguientes vacunas a disposición:
- **Paifer - integrante 1:** multiplica por 10 los anticuerpos de la persona a la que se le da la dosis, otorga una inmunidad por 6 meses si la persona es mayor a 40 o 9 meses en caso contrario, siempre contando desde el día de la aplicación.
- **Larussa - integrante 2:** cada compuesto tiene un número que indica el efecto multiplicador de anticuerpos que da a la persona (hasta un máximo de 20x). Otorga una inmunidad hasta el 03/03/2022.
- **AstraLaVistaZeneca - integrante 3:** suma 10.000 anticuerpos a la persona. La inmunidad que otorga es 6 meses si la persona tiene un nombre par o 7 en caso contrario.
- **Combineta - común a todas las personas:** es un compuesto que contiene varias dosis combinadas de alguna de las anteriores (sabemos cuáles son). Considerar que otorga el mínimo de anticuerpos y el máximo de inmunidad de todas las vacunas que conforman el combo.

Dado que la OMS publica nuevos informes diariamente, queremos que sea fácil modelar la aparición de nuevas variantes de vacunas.

## Punto 2: Costo de las vacunas
Incorporar ahora el costo de cada vacuna, que es inicialmente $ 1.000 hasta los 30 años, y a partir de los 30 años se incrementa $ 50 por año (una persona de 35 costaría $ 1.250, una persona de 81 costaría $ 3.550, son ``51 x 50 = 2.550 + 1.000``). Además cada vacuna puede agregar un extra:
- **Paifer - integrante 1:** le agrega un costo de $ 400 si la persona es menor a 18 años, o $ 100 en caso contrario.
- **Larussa - integrante 2:** le incorpora $ 100 por el efecto multiplicador de los anticuerpos (contado en el punto 1)
- **AstraLaVistaZeneca - integrante 3:** le agrega $ 2.000 a las personas especiales, que son las que viven en Tierra del Fuego, Santa Cruz o Neuquén, en caso contrario no tiene costo extra.
- **Combineta:** le aplica la sumatoria de todos los costos (ej: si el costo total de una Paifer fuera $ 1.400 y el costo de una Larussa fuera $ 1.500, el total sería $ 2.900). El costo extra suma 100 pesos por cada vacuna.

## Punto 3: Me quedo contigo...
No todas las personas somos iguales. A la hora de elegir una vacuna, hay diferentes elecciones:
- **cualquierosas - punto en común:** le da lo mismo cualquier vacuna
- **anticuerposas - integrante 1:** eligen la vacuna si las deja con más de 100.000 anticuerpos
- **inmunidosasFijas - integrante 2:** eligen la vacuna si al 05/03/2022 todavía conservan la inmunidad
- **inmunidosasVariables - integrante 3:** eligen la vacuna si después de x meses conservan la inmunidad. La cantidad de meses se quiere parametrizar.

Las personas pueden cambiar de parecer con el tiempo y pueden surgir nuevas variantes, así que queremos que la solución sea lo más flexible posible.

## Punto 4: Costo del plan inicial de vacunación - todos los integrantes
Calcular cuánto saldría el plan inicial de vacunación, que consiste en conocer el total en $ por aplicar la vacuna más barata que elegiría cada una de las personas. Las vacunas actualmente disponibles son: paifer, larussa 5, larussa 2, astraLaVistaZeneca, y una combineta de larussa 2 y paifer.

Aclaración: para saber qué vacuna aplicar a una persona
- si le viene bien más de una vacuna, elegir la más barata
- si no le viene bien ninguna, no considerarla en el plan vacunatorio (son los **outsiders**, por no decir otra cosa)
si le viene bien una sola, obviamente es ésa

## Punto 5: ¡Me llegó el turno! - todos los integrantes
Como vimos anteriormente las personas pueden aceptar o no la vacuna en base a su criterio. Se pide modelar la confirmación del turno para la vacuna:  si el usuario la acepta se le aplica la vacuna y agrega la vacuna a su historial, caso contrario se pide expresar un mensaje adecuado en el sistema como por ejemplo “La vacuna solicitada no es aplicable para la persona”.

### Objetivo
Se pide que implemente la solución a cada uno de los puntos, incluyendo el testeo unitario que cubra las clases de equivalencia que el enunciado propone.

