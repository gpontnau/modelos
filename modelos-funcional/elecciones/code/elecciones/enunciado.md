## Ejercicios

Es período de votar, así que nos han pedido que hagamos una simulación de resultados posibles para una elección en un país muy muy lejano.

### Punto 1 (4 puntos)

De una persona nos importa:

*   su nombre,
*   la deuda que tiene,
*   el porcentaje de felicidad,
*   si tiene esperanza y
*   la estrategia para elegir una persona candidata

El criterio que tiene una persona para elegir el candidato puede ser:

*   **conformista:** cualquier estado en el que quede la persona le parece ok
*   **esperanzado:** queremos que quede CON o SIN esperanza (eso se debe poder configurar) o con un % de felicidad > 50 (fijo, no queremos configurar ese porcentaje)
*   **económico:** su deuda debe quedar con un valor menor a TANTOS pesos que debe poder cambiarse
*   **combinado:** debe poder combinar los criterios esperanzado CON esperanza y económico con una deuda menor a 500. En caso de que alguno de los dos se cumpla acepta al candidato.

***Nota:** no repetir la misma idea.*

Modelar un país como un conjunto de personas y definir un conjunto de valores para Paradigma, que tiene como habitantes a Silvia, Lara, Manuel y Víctor: inventar diferentes valores. Cada persona debe tener un criterio de elección diferente.

### Punto 2 (3 puntos)

En este punto queremos que resuelvas ambos puntos únicamente con orden superior.

a. Queremos saber si hay alguna persona que tenga un nombre de más de 2 vocales. **Tip:** existe la función isVowel que les dejamos acá.

```haskell
isVowel :: Char -> Bool
isVowel character = character `elem` "aeiou"
```

b. Queremos sumar el total de deuda de las personas que tienen un valor de deuda par.

### Punto 3 (3 puntos)

Modelar los siguientes candidatos, cada uno promete cosas distintas.

*   **Yrigoyen:** nos promete que le perdona la mitad de la deuda a una persona
*   **Alende:** le devuelve la esperanza a la gente y le da un 10% más de felicidad
*   **Alsogaray:** te saca la esperanza y te agrega 100 \$ de deuda
*   **Martínez Raymonda:** es una combinación de Yrigoyen y Alende (hace ambas cosas)

***Nota:** no repetir la misma idea.*

### Punto 4 (2 puntos)

Resolver este punto aplicando recursividad.

Dada una lista de candidatos, queremos saber a qué candidatos votaría una persona, teniendo en cuenta que debe cortar al primer candidato que no cumpla (no importan los demás). Para votar un candidato, una persona tiene que quedar en un estado aceptado por su criterio de elección.

Por ejemplo, si una persona quiere quedar con deuda < 100, y tiene deuda 150, votaría a Yrigoyen porque quedaría con 75 de deuda...

Supongamos que existe una persona Manuel, que tiene \$ 500 de deuda, 25% de felicidad, no tiene esperanza y vota según el criterio combinado, y dada la lista de Yrigoyen, Alende, Alsogaray, Martínez Raymonda elegiría a Yrigoyen y Alende.

### Punto 5 (2 puntos)

*   Dada una lista de candidatos y una persona, queremos saber cómo quedaría esa persona si los candidatos que él elige en base al punto 4 cumplen sus promesas. **Nota:** si una persona elige los candidatos A, B de una lista de A, B, C, D solo deben cumplir las promesas los candidatos A y B.
*   ¿Qué pasa si le pasamos una lista infinita de candidatos a la función del punto anterior?