% Sangre de los personajes
sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

% Características de los personajes
caracteristica(harry, corajudo).
caracteristica(harry, amistoso).
caracteristica(harry, orgulloso).
caracteristica(harry, inteligente).
caracteristica(draco, orgulloso).
caracteristica(draco, inteligente).
caracteristica(hermione, inteligente).
caracteristica(hermione, orgullosa).
caracteristica(hermione, responsable).

% Casas que odian
odia(harry, slytherin).
odia(draco, hufflepuff).
odia(hermione, ninguna).

% Casas de Hogwarts
casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
% casa(hufflepuff). UC

% Características requeridas por cada casa
caracteristicaBuscada(gryffindor, corajudo).
caracteristicaBuscada(slytherin, orgulloso).
caracteristicaBuscada(slytherin, inteligente).
caracteristicaBuscada(ravenclaw, inteligente).
caracteristicaBuscada(ravenclaw, responsable).
caracteristicaBuscada(hufflepuff, amistoso).

mago(Mago) :- sangre(Mago, _).

permiteEntrar(Casa, _) :-
    casa(Casa),
    Casa \= slytherin.
permiteEntrar(slytherin, Mago) :- 
    sangre(Mago, Sangre), 
    Sangre \= impura.

tieneCaracterPara(Mago, Casa) :-
    caracteristicaBuscada(Casa, Caracteristica),
    caracteristica(Mago, Caracteristica),
    forall(
        caracteristicaBuscada(Casa, OtraCaracteristica), 
        caracteristica(Mago, OtraCaracteristica)
    ).
    
puedeQuedarEn(Mago, Casa) :-
    tieneCaracterPara(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odia(Mago, Casa)).
puedeQuedarEn(hermione, gryffindor).  % Regla especial para Hermione
    
cadenaDeAmistades(Magos) :-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).

todosAmistosos(Magos) :-
    forall(member(Mago, Magos), amistoso(Mago)).

amistoso(Mago) :-
    caracteristica(Mago, amistoso).

cadenaDeCasas([Mago1, Mago2 | MagosSiguientes]) :-
    puedeQuedarEn(Mago1, Casa),
    puedeQuedarEn(Mago2, Casa),
    cadenaDeCasas([Mago2 | MagosSiguientes]).
cadenaDeCasas([_]).
cadenaDeCasas([]).

% Acciones
accion(harry, fueraDeCama).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(seccionRestringida)).
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).
accion(draco, irA(mazmorras)).
accion(ron, ganar(ajedrezMagico, 50)).
accion(hermione, salvarAmigos, 50).
accion(harry, vencerVoldemort, 60).

% Lugares prohibidos y sus penalizaciones
lugarProhibido(bosque, 50).
lugarProhibido(seccionRestringida, 10).
lugarProhibido(tercerPiso, 75).

% Casas de los magos
esDe(harry, gryffindor).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

esBuenAlumno(Mago) :-
    accion(Mago, _),
    not(accionMala(Mago)).

accionMala(Mago) :-
    accion(Mago, fueraDeCama).
accionMala(Mago) :-
    accion(Mago, irA(Lugar)),
    lugarProhibido(Lugar, _).

accionRecurrente(Accion) :-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.

puntajeTotalCasa(Casa, PuntajeTotal) :-
    findall(
        Puntos, 
        (esDe(Mago, Casa), puntosPorAccion(Mago, Puntos)), 
        ListaPuntos
    ),
    sum_list(ListaPuntos, PuntajeTotal).

puntosPorAccion(Mago, Puntos) :-
    accion(Mago, ganar(_, Puntos)).
puntosPorAccion(Mago, Puntos) :-
    accion(Mago, vencerVoldemort, Puntos).
puntosPorAccion(Mago, Puntos) :-
    accion(Mago, salvarAmigos, Puntos).
puntosPorAccion(Mago, Puntos) :-
    accion(Mago, irA(Lugar)),
    lugarProhibido(Lugar, Penalizacion),
    Puntos is -Penalizacion.
puntosPorAccion(Mago, Puntos) :-
    accion(Mago, fueraDeCama),
    Puntos is -50.
    

casaGanadora(Casa) :-
    puntajeTotalCasa(Casa, Puntaje),
    forall(
        (puntajeTotalCasa(OtraCasa, OtroPuntaje), OtraCasa \= Casa), 
        Puntaje > OtroPuntaje
    ).

% Hechos adicionales para preguntas respondidas
respuesta(hermione, dondeEstaUnBezoar, 20, snape).
respuesta(hermione, comoLevitarPluma, 25, flitwick).

puntosPorAccion(Mago, Puntos) :-
    respuesta(Mago, _, Dificultad, snape),
    Puntos is Dificultad / 2.
puntosPorAccion(Mago, Puntos) :-
    respuesta(Mago, _, Dificultad, Profesor),
    Profesor \= snape,
    Puntos is Dificultad.

    