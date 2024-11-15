atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

atiende(vale, Dia, HorarioEntrada, HorarioSalida) :- 
    atiende(dodain, Dia, HorarioEntrada, HorarioSalida).
atiende(vale, Dia, HorarioEntrada, HorarioSalida) :- 
    atiende(juanC, Dia, HorarioEntrada, HorarioSalida).

% Como maiu esta pensando si hace el horario de 0 a 8, todavia no puedo representarlo con un hecho, ya que esto confirmaria que se va a alguno
% de los dos destinos. Por lo que si no sabemos cual es el hecho todavia, entonces los suponemos falso y no lo agregamos ya que prolog trabaja con el
% principio de universo cerrado y todo lo que no escribamos lo presupone falso. Lo mismo con que nadie hace el mismo horario que leoC, 
% simplemente no lo escribimos y prolog toma como falso que carlos se va a algun lado


% Punto 2
quienAtiende(Persona, Dia, HorarioPuntual) :-
    atiende(Persona, Dia, HorarioEntrada, HorarioSalida),
    between(HorarioEntrada, HorarioSalida, HorarioPuntual).

% Punto 3
foreverAlone(Persona, Dia, HorarioPuntual) :-
    quienAtiende(Persona, Dia, HorarioPuntual),
    not((quienAtiende(OtraPersona, Dia, HorarioPuntual), Persona \= OtraPersona)).
    
% Punto 4
posibilidadesAtencion(Dia, Personas):-
  findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PersonasPosibles),
  combinar(PersonasPosibles, Personas).

combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]):-
  combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas):-
  combinar(PersonasPosibles, Personas).

  
% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

% Punto 5
venta(dodain, fecha(10, 8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).
venta(dodain, fecha(12, 8), [bebidas(true, 8), bebidas(false, 1), golosinas(10)]).
venta(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, fecha(11, 8), [golosinas(600)]).
venta(lucas, fecha(18, 8), [bebidas(false, 2), cigarrillos([derby])]).

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió,
% la primera venta que hizo fue importante. Una venta es importante:
% - en el caso de las golosinas, si supera los $ 100.
% - en el caso de los cigarrillos, si tiene más de dos marcas.
% - en el caso de las bebidas, si son alcohólicas o son más de 5.
personaSuertuda(Persona):-
  vendedora(Persona),
  forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).

vendedora(Persona) :- venta(Persona, _, _).

ventaImportante(golosinas(Precio)) :- Precio > 100.
ventaImportante(cigarrillos(Marcas)) :- length(Marcas, Cantidad), Cantidad > 2.
ventaImportante(bebidas(true, _)).
ventaImportante(bebidas(_, Cantidad)) :- Cantidad > 5.