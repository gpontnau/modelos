# Mi sueño es...
Cada persona tiene una serie de sueños que quiere cumplir. Todas las personas tienen edad, carreras que quieren estudiar, saben la plata que quieren ganar y los lugares a los que quieren viajar. Algunos tienen hijos y otros no.
Las personas tienen una serie de sueños que quieren cumplir, por ejemplo:
1. Recibirse de una carrera: por ejemplo de “Ingeniero en Sistemas de Información”, “Odontólogo” o “Licenciado en Psicología”.
   
2. Tener un hijo.
   
3. Adoptar una cantidad x de hijos.
   
4. Viajar a un lugar, como “Chapadmalal” o “Tahití”. 
   
5. Conseguir un laburo donde se gane una cantidad x de plata.
   
Nos interesa poder modelar nuevos sueños a futuro. Cada sueño brinda a la persona que lo cumple un nivel de felicidad o “felicidonios”.

## Punto 1 | 4 puntos
Hacer que una persona cumpla un sueño, lo que implica pasar algunas validaciones previas:
- tratar de recibirse de una carrera que no quiere estudiar una persona no es correcto
- tampoco es válido recibirse de una carrera en la que ya se recibió dicha persona
- conseguir un trabajo donde la plata que se gana es menos de lo que quiere ganar no es correcto
- si uno tiene un hijo no se puede adoptar otro (así lo pidió el usuario)

En el caso en que no se pueda cumplir un sueño, utilizar la técnica que considere adecuada para implementarlo. Una vez cumplido el sueño, debe quedar en claro la lista de sueños cumplidos vs. la de pendientes. Diseñarlo de la forma que crea más conveniente.

## Punto 2 | 2 puntos
Modelar un sueño múltiple, que permite unir varios sueños:
- viajar a Cataratas
- tener 1 hijo
- conseguir un trabajo de $ 10,000

Esto hace que se cumplan los 3 sueños. Si alguno de los 3 no se pueden cumplir debería tirar error y no cumplir ninguno, ej:
- viajar a Cataratas
- tener 1 hijo
- conseguir un trabajo de $ 200 (la persona quiere ganar $ 7.000)
Esto produce un error. No hace falta considerar el estado en el que queda la persona al ir cumpliendo sueños (ej: tener 1 hijo, adoptar 1 hijo podría tirar error por separado pero no si participan de un sueño múltiple)

## Punto 3 | 4 puntos
Hemos clasificado diferentes tipos de personas. Los *realistas* cumplen la meta más importante para ellos, los alocados quieren cumplir un sueño cualquiera al azar, los *obsesivos* cumplen el primer sueño de la lista. Pueden aparecer a futuro nuevos tipos de persona. Resolver el requerimiento que pide que una persona cumpla su sueño más preciado, teniendo en cuenta que queremos que una persona realista pueda pasar de alocado a realista o de realista a obsesivo.

## Punto 4 | 2 puntos
Queremos saber si una persona es feliz, esto se da si el nivel de felicidad que tiene es mayor a los felicidonios que suman los sueños pendientes.

## Punto 5 | 2 puntos
Queremos saber si una persona es ambiciosa, esto se da si tiene más de 3 sueños (pendientes o cumplidos) con más de 100 felicidonios.

Para todo el parcial. Se pide
- uno o varios diagramas de clase, según crea conveniente
- diagrama de objetos si le parece que explica mejor su solución
- código relevante de la solución: no escribir getters, setters ni constructores que no tengan comportamiento específico. Recomendamos escribir en una o varias páginas cada punto para facilitar el seguimiento posterior por el estudiante o el profesor. 

