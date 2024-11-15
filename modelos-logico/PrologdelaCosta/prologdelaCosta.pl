% Puestos de comida
comida(hamburguesas, 2000).
comida(panchitos_con_papas, 1500).
comida(lomitos_completos, 2500).
comida(caramelos, 0).

% Atracciones tranquilas para chicos y adultos
atraccion(autitosChocadores, tranquila, chicosYAdultos).
atraccion(casaEmbrujada, tranquila, chicosYAdultos).
atraccion(laberinto, tranquila, chicosYAdultos).
% Atracciones tranquilas exclusivas para chicos
atraccion(tobogan, tranquila, chicos).
atraccion(calesita, tranquila, chicos).

% Atracciones intensas con coeficiente de lanzamiento
atraccion(barcoPirata, intensa, chicosYAdultos, 14).
atraccion(tazasChinas, intensa, chicosYAdultos, 6).
atraccion(simulador3D, intensa, chicosYAdultos, 2).

% Montañas rusas con datos técnicos
montanaRusa(abismoMortalRecargada, 3, 134). % 2:14 minutos -> 134 segundos
montanaRusa(paseoPorElBosque, 0, 45). % 45 segundos

% Atracciones acuáticas (habilitadas de septiembre a marzo)
atraccionAcuatica(torpedoSalpicon).
atraccionAcuatica(esperoQueHayasTraidoUnaMuda).

% Visitantes del grupo Viejitos
visitante(eusebio, viejitos, 80, 3000, 50, 0).
visitante(carmela, viejitos, 80, 0, 0, 25).
% Visitantes que vinieron solos
visitante(maria, solo, 30, 5000, 30, 20).
visitante(juan, solo, 16, 1000, 40, 10).

% Punto 2: Estado de Bienestar
sumaHambreYAburrimiento(Visitante, Suma) :-
    visitante(Visitante, _, _, _, Hambre, Aburrimiento),
    Suma is Hambre + Aburrimiento.
    
estadoDeBienestar(Visitante, Estado) :-
    visitante(Visitante, Grupo, _, _, _, _),
    sumaHambreYAburrimiento(Visitante, Suma),
    determinarEstado(Grupo, Suma, Estado).

determinarEstado(solo, 0, podriaEstarMejor).
determinarEstado(_, Suma, podriaEstarMejor) :- between(1, 50, Suma).
determinarEstado(Grupo, 0, felicidadPlena) :- Grupo \= solo.
determinarEstado(_, Suma, necesitaEntretenerse) :- between(51, 99, Suma).
determinarEstado(_, Suma, seQuiereIrACasa) :- Suma >= 100.

% Punto 3: Precio de la comida
puedeSatisfacerHambre(Grupo, Comida) :-
    comida(Comida, Precio),
    forall(visitante(_, Grupo, _, Dinero, Hambre, _), 
        (Dinero >= Precio, satisfaceComida(Comida, Hambre))
        ).
    
satisfaceComida(hamburguesas, Hambre) :- Hambre < 50.
satisfaceComida(panchitos_con_papas, Hambre) :- Hambre < 50, esChico(Hambre).
satisfaceComida(lomitoscompletos, _).
satisfaceComida(caramelos, Hambre) :- 
    visitante(Nombre, _, _, Dinero, _, _),
    forall(comida(_, Precio), Precio > Dinero).

esChico(Visitante) :-
    visitante(Visitante, _, Edad, _, _, _),
    Edad < 13.

esAdulto(Visitante) :- not(esChico(Visitante)).

% Punto 4
% Lluvia de hamburguesas para un visitante y una atracción
lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedePagarComida(Visitante, hamburguesas),
    atraccionIntensaPeligrosa(Atraccion).
lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedePagarComida(Visitante, hamburguesas),
    montanaRusaPeligrosa(Visitante, Atraccion).
lluviaDeHamburguesas(Visitante, Atraccion) :-
    atraccion(tobogan, _, _).
    
% Verifica si un visitante puede pagar cierta comida
puedePagarComida(Visitante, Comida) :-
    comida(Comida, Precio),
    visitante(Visitante, _, _, Dinero, _, _),
    Dinero >= Precio.

% Verifica si una atracción intensa es peligrosa (coeficiente > 10)
atraccionIntensaPeligrosa(Atraccion) :-
    atraccion(Atraccion, intensa, _, Coeficiente),
    Coeficiente > 10.

% Verifica si una montaña rusa es peligrosa para un visitante
montanaRusaPeligrosa(Visitante, Atraccion) :-
    montanaRusa(Atraccion, Giros, Duracion),
    visitante(Visitante, _, Edad, _, _, _),
    not(estadoDeBienestar(Visitante, necesitaEntretenerse)).
    (esAdulto(Visitante), masPeligrosa(Giros)).

montanaRusaPeligrosa(Visitante, Atraccion) :-
    montanaRusa(Atraccion, _, Duracion),
    visitante(Visitante, _, Edad, _, _, _),
    esChico(Visitante), 
    Duracion > 60.
    
% Determina si la montaña rusa tiene la mayor cantidad de giros
masPeligrosa(Giros) :-
    montanaRusa(_, GirosMax, _),
    Giros = GirosMax.

% Punto 5
% Regla principal: opciones de entretenimiento para un visitante en un mes
opcionesDeEntretenimiento(Visitante, Mes, Opciones) :-
    findall(Opcion, opcionPosible(Visitante, Mes, Opcion), OpcionesPosibles),
    seleccionarOpciones(OpcionesPosibles, Opciones).

% Generación de posibles opciones de entretenimiento
opcionPosible(Visitante, _, comida(Comida)) :-
    puedePagarComida(Visitante, Comida).

opcionPosible(Visitante, _, atraccion(Tranquila)) :-
    atraccion(Tranquila, tranquila, chicos).

opcionPosible(Visitante, _, atraccion(Intensa)) :-
    atraccion(Intensa, intensa, _, _).

opcionPosible(Visitante, _, montanaRusa(Montana)) :-
    montanaRusa(Montana, _, _),
    not(montanaRusaPeligrosa(Visitante, Montana)).

opcionPosible(Visitante, Mes, atraccion(Acuatica)) :-
    atraccionAcuatica(Acuatica),
    mesValido(Mes).

% Combinación de opciones
seleccionarOpciones([], []).
seleccionarOpciones([Opcion|Restantes], [Opcion|Seleccionadas]) :-
    seleccionarOpciones(Restantes, Seleccionadas).
seleccionarOpciones([_|Restantes], Seleccionadas) :-
    seleccionarOpciones(Restantes, Seleccionadas).

mesValido(Mes) :- member(Mes, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]).
