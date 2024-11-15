% Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas Doradas
destino(dodain, pehuenia).
destino(dodain, sanMartin).
destino(dodain, esquel).
destino(dodain, sarmiento).
destino(dodain, camarones).
destino(dodain, playasDoradas).
% Alf, en cambio, se va a Bariloche, San Martín de los Andes y El Bolsón.
destino(alf, bariloche).
destino(alf, sanMartin).
destino(alf, elBolson).
% Nico se va a Mar del Plata
destino(nico, marDelPlata).
% Vale se va para Calafate y El Bolsón.
destino(vale, calafate).
destino(vale, elBolson).
% Martu se va donde vayan Nico y Alf.
destino(martu, Lugar) :- destino(nico, Lugar).
destino(martu, Lugar) :- destino(alf, Lugar).

% Como juan no sabe si va a ir a villaGessel o a federacion, todavia no puedo representarlo con un hecho, ya que esto confirmaria que se va a alguno
% de los dos destinos. Por lo que si no sabemos cual es el hecho todavia, entonces los suponemos falso y no lo agregamos ya que prolog trabaja con el
% principio de universo cerrado y todo lo que no escribamos lo presupone falso. Lo mismo con carlos que no va a tomar vacaciones, simplemente no lo
% escribimos y prolog toma como falso que carlos se va a algun lado.

% Punto 2
atraccion(esquel, parqueNacional(losAlerces)).
atraccion(esquel, excursion(trochita)).
atraccion(esquel, excursion(trevelin)).

atraccion(pehuenia, cerro(bateaMahuida, 2000)).
atraccion(pehuenia, cuerpoDeAgua(moquehue, permitidoPescar, 14)).
atraccion(pehuenia, cuerpoDeAgua(alumine, permitidoPescar, 19)).

% atraccion(marDelPlata, playa(4)).
% atraccion(marDelPlata, cuerpoAgua(lagoMardel, noSePuedePescar, 10)).

% lugarConAtraccionCopada(Lugar):-
%     atraccion(Lugar, Atraccion),
%     esCopada(Atraccion).

tuvoVacacionesCopadas(Persona):-
    destino(Persona, _),
    forall(destino(Persona, Lugar), (atraccion(Lugar, Atraccion), esCopada(Atraccion))). 
       
esCopada(cerro(_, MetrosAltura)) :- MetrosAltura > 2000.
esCopada(cuerpoDeAgua(_, permitidoPescar, _)).
esCopada(cuerpoDeAgua(_, _, Temperatura)) :- Temperatura > 20.
esCopada(playa(DiferenciaDeMarea)):- DiferenciaDeMarea < 5.
esCopada(excursion(Nombre)) :- atom_length(Nombre, CantLetras), CantLetras > 7.
esCopada(parqueNacional(_)).

% Punto 3
% Personas que no se cruzaron en ningún destino (intente con 'distinct' pero no pude)
noSeCruzaron(Persona1, Persona2) :-
    destino(Persona1, _),
    destino(Persona2, _),
    Persona1 \= Persona2,  % primero deben ser dos personas /=
    forall(
        destino(Persona1, Ciudad), 
        not(destino(Persona2, Ciudad))
    ).

% Punto 4
% Costos de vida
costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartin, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

% Vacaciones gasoleras
vacacionesGasoleras(Persona) :-
    distinct(Persona, (destino(Persona, _), 
        forall(destino(Persona, Ciudad), (costoDeVida(Ciudad, Costo), Costo < 160)))
    ).

% Punto 5    
% Itinerarios posibles
destinosPosibles(Persona, DestinosPosibles):-
    findall(Ciudad, destino(Persona, Ciudad), Destinos),
    permutarDestinos(Destinos, DestinosPosibles).

permutarDestinos([], []). % Caso base
permutarDestinos(Destinos, [Primero|Resto]) :- % Caso recursivo
    seleccionar(Primero, Destinos, RestoDestinos),
    permutarDestinos(RestoDestinos, Resto).

seleccionar(Elemento, [Elemento|Resto], Resto).
seleccionar(Elemento, [Otro|Resto], [Otro|RestoSeleccionado]) :-
    seleccionar(Elemento, Resto, RestoSeleccionado).

    % Todo algoritmo recursivo necesita al menos un caso base y al menos un caso recursivo. Esto define
    % entonces que los predicados son no determinísticos: intervendrá el mecanismo de backtracking.
