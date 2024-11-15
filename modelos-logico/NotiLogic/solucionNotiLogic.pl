% noticia(Autor, Visitas, Articulo, Personaje)
noticia(artVandelay, articulo("Nuevo titulo para lloyd braun", deportista(lloydBraun, 5)), 25).
noticia(elaineBenes, articulo("Primicia", farandula(jerrySeinfeld, kennyBania)), 16).
noticia(elaineBenes, articulo("El dolar bajo! … de un arbolito", farandula(jerrySeinfeld, newman)), 150).
noticia(bobSacamano, articulo("No consigue ganar ni una carrera", deportista(davidPurry, 0)), 10).
noticia(bobSacamano, articulo("Cosmo kramer encabeza las elecciones", politico(cosmoKramer, "amigos del poder")), 155).

% George roba noticias de farándula y las transforma en política
noticia(georgeCostanza, articulo(Titulo, PersonaOriginal), Visitas) :-
    robaArticulo(georgeCostanza, Persona),
    noticia(Persona, articulo(Titulo, PersonaOriginal), VisitasOriginal),
    personajeRobado(PersonaOriginal, Personaje),
    visitasDeArticuloRobado(VisitasOriginal, PersonaOriginal, Visitas). 

robaArticulo(georgeCostanza, bobSacamano).
robaArticulo(georgeCostanza, elaineBenes).

personajeRobado(farandula(Persona, _), politico(Persona, "amigos del poder")).
personajeRobado(Persona, Personaje) :- Personaje \= farandula(_, _).

visitasDeArticuloRobado(VisitasOriginal, farandula(_, _), Visitas) :- 
    Visitas is VisitasOriginal / 2.
visitasDeArticuloRobado(VisitasOriginal, Personaje, Visitas) :- 
    Personaje \= farandula(_, _).

% Punto 1
% Justificación teórica:
% El concepto técnico de "universo cerrado" en Prolog se refiere a la suposición de que todo lo que no está definido como verdadero se considera falso
% no hay ninguna regla o hecho que afirme explícitamente que Elaine Benes no roba las noticias de Art Vandelay. Por lo tanto, en el contexto de este código, se asume que Elaine Benes roba las noticias de Art Vandelay, ya que no hay ninguna información que indique lo contrario.

% Punto 2
% nos interesa saber si un artículo es amarillista. Esto ocurre si el título es "Primicia" o si la persona 
% involucrada en dicha noticia está complicada. Los deportistas con menos de tres títulos, 
% los personajes de farándula que tienen problemas contra Jerry Seinfeld y todos los políticos están complicados.
articuloAmarillista(Articulo):-
    articulo(Articulo),
    esAmarillista(Articulo).
    
articulo(Articulo) :- noticia(_, Articulos, _).
    
esAmarillista(articulo("Primicia", _, _)).

estaComplicado(deportista(_, Titulos)) :- Titulos < 3. 
estaComplicado(farandula(_, jerrySeinfield)).
estaComplicado(politico(_, _)).

% Punto 3
% Si a un autor no le importa nada. (NO USAR FINDALL)
% Esto ocurre cuando todas sus noticias que fueron muy visitadas son amarillistas. 
% Que una noticia sea muy visitada implica que tenga más de 15 visitas.
autorNoLeImportaNada(Autor) :-
    autor(Autor),
    forall(muyVisitada(Autor, Articulo), articuloAmarillista(Articulo)).

autor(Autor) :- distinct(Autor, noticia(Autor, _, _)).

muyVisitada(Autor, Articulo) :- 
    noticia(Autor, Articulo, Visitas), 
    Visitas > 15.

% Si un autor es muy original, 
% qué ocurre cuando no hay otra noticia que tenga el mismo título.
autorMuyOriginal(Autor) :-
    autor(Autor),
    not((
        noticia(Autor, articulo(Titulo, _) , _),
        noticia(OtroAutor, articulo(Titulo, _), _),
        Autor \= OtroAutor
    )).

% Si un autor tuvo un traspié, 
% es decir si tiene al menos una noticia poco visitada.
autorTuvoTraspie(Autor) :-
    distinct(Autor, noticia(Autor, Articulo, _)),
    not(muyVisitada(Autor, Articulo)).

% Punto 4
% Edición loca: queremos armar un resumen de la semana con una combinación posible de artículos amarillistas 
% que no superen las 50 visitas en total. El predicado debe ser inversible.
edicionLoca(Articulos, Visitas):-
    findall(Articulo, articuloAmarillista(Articulo), ArticulosPosibles),
    combinar(ArticulosPosibles, Articulos, Visitas),
    Visitas =< 50.
  
  combinar([], [], 0).
  combinar([Articulo|ArticulosPosibles], [Articulo|Articulos], TotalVisitas):-
    combinar(ArticulosPosibles, Articulos, TotalRestoVisitas),
    noticia(_, Articulo, CantidadVisitas),
    TotalVisitas is CantidadVisitas + TotalRestoVisitas.
  combinar([_|ArticulosPosibles], Articulos, TotalVisitas):-
    combinar(ArticulosPosibles, Articulos, TotalVisitas).