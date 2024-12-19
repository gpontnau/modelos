{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use section" #-}
module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero


-- Modelado de tipos
type Color = String
type Velocidad = Number
type Distancia = Number

data Auto = Auto {
  color         :: Color,
  velocidad     :: Velocidad,
  distancia     :: Distancia
} deriving (Show, Eq)

type Carrera = [Auto]

------------------ PUNTO 1 ------------------

-- a) Saber si un auto está cerca de otro auto
estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = (auto1 /= auto2) && (distanciaEntre auto1 auto2 < 10)

-- Funcion auxiliar
distanciaEntre :: Auto -> Auto -> Number
distanciaEntre auto1 auto2 = abs . (distancia auto1 -) $ distancia auto2

-- b) Saber si un auto va tranquilo en una carrera
autoVaTranquilo :: Auto -> Carrera -> Bool
autoVaTranquilo auto carrera = (not . hayAutosCerca auto) carrera
                                && leVaGanandoATodos auto carrera

hayAutosCerca :: Auto -> Carrera -> Bool
hayAutosCerca auto = any (estaCerca auto)

leVaGanandoATodos :: Auto -> Carrera -> Bool
leVaGanandoATodos auto = all (leVaGanando auto) . filter (/= auto)

tieneMasDistancia :: Auto -> Auto -> Bool
tieneMasDistancia auto1 auto2 = distancia auto1 > distancia auto2

-- c) Conocer en qué puesto está un auto en una carrera
puesto :: Auto -> Carrera -> Number
puesto auto = (+1) . length . filter (tieneMasDistancia auto)

leVaGanando :: Auto -> Auto -> Bool
leVaGanando ganador = (>) (distancia ganador) . distancia

------------------ PUNTO 2 ------------------
-- a) Hacer que un auto corra durante un determinado tiempo
correr :: Number -> Auto -> Auto
correr tiempo auto = auto { distancia = distancia auto + tiempo * velocidad auto }

-- b) Alterar la velocidad de un auto
type ModificadorVelocidad = Number -> Number

alterarVelocidad :: ModificadorVelocidad -> Auto -> Auto
alterarVelocidad modificador auto = auto { velocidad = modificador (velocidad auto) }

-- Aplicación parcial para bajar la velocidad
bajarVelocidad :: Number -> Auto -> Auto
bajarVelocidad velocidadBajar = alterarVelocidad (max 0 . subtract velocidadBajar)

------------------ PUNTO 3 ------------------
-- Función afectarALosQueCumplen (proporcionada)
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista =
  (map efecto . filter criterio) lista ++ filter (not . criterio) lista

-- Tipo para representar los power ups
type PowerUp = Auto -> Carrera -> Carrera

-- Terremoto
terremoto :: PowerUp
terremoto auto = (afectarALosQueCumplen (estaCerca auto) . bajarVelocidad) 50

-- Miguelitos
miguelitos :: Number -> PowerUp
miguelitos cantidad auto = afectarALosQueCumplen (leVaGanando auto) (bajarVelocidad cantidad)

-- Jet Pack
-- JetPack: duplica la velocidad, corre por un tiempo y restaura la velocidad
jetPack :: Number -> PowerUp
jetPack tiempo auto = modificarAutoEnCarrera (color auto) (aplicarJetPack tiempo (velocidad auto))

-- Funciones auxiliares para JetPack
aplicarJetPack :: Number -> Number -> Auto -> Auto
aplicarJetPack tiempo velocidadOriginal = restaurarVelocidad velocidadOriginal . correr tiempo . duplicarVelocidad

duplicarVelocidad :: Auto -> Auto
duplicarVelocidad = alterarVelocidad (*2)

restaurarVelocidad :: Number -> Auto -> Auto
restaurarVelocidad velocidadOriginal auto = auto { velocidad = velocidadOriginal }

modificarAutoEnCarrera :: Color -> (Auto -> Auto) -> Carrera -> Carrera
modificarAutoEnCarrera colorAuto modificacion = map (modificarSiEsAuto colorAuto modificacion)

modificarSiEsAuto :: Color -> (Auto -> Auto) -> Auto -> Auto
modificarSiEsAuto colorAuto modificacion auto 
    | ((== colorAuto) . color) auto = modificacion auto
    | otherwise = auto


------------------ PUNTO 4 ------------------
type Evento = Carrera -> Carrera
simularCarrera :: Carrera -> [Evento] -> [(Number, Color)]
simularCarrera carrera = tablaDePosiciones . foldr ($) carrera

tablaDePosiciones :: Carrera -> [(Number, Color)]
tablaDePosiciones carrera = map (entradaDeTabla carrera) carrera

entradaDeTabla :: Carrera -> Auto -> (Number, String)
entradaDeTabla carrera auto = (puesto auto carrera, color auto)

tablaDePosiciones' :: Carrera -> [(Number, String)]
tablaDePosiciones' carrera = 
    zip (map (flip puesto carrera) carrera) (map color carrera)

procesarEventos :: [Evento] -> Carrera -> Carrera
procesarEventos eventos carreraInicial =
    foldl (\carreraActual evento -> evento carreraActual) 
      carreraInicial eventos

correnTodos :: Number -> Evento
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorBuscado carrera =
    powerUp autoQueGatillaElPoder carrera
    where autoQueGatillaElPoder = find ((== colorBuscado).color) carrera

find :: (c -> Bool) -> [c] -> c
find cond = head . filter cond

ejemploDeUsoSimularCarrera =
    simularCarrera autosDeEjemplo [
        correnTodos 30,
        usaPowerUp (jetPack 3) "azul",
        usaPowerUp terremoto "blanco",
        correnTodos 40,
        usaPowerUp (miguelitos 20) "blanco",
        usaPowerUp (jetPack 6) "negro",
        correnTodos 10
    ]

autosDeEjemplo :: [Auto]
autosDeEjemplo = map (\color -> Auto color 120 0) ["rojo", "blanco", "azul", "negro"]

---- Punto 5
{-

5a

Se puede agregar sin problemas como una función más misilTeledirigido :: Color -> PowerUp, y usarlo como:
usaPowerUp (misilTeledirigido "rojo") "azul" :: Evento


5b

- vaTranquilo puede terminar sólo si el auto indicado no va tranquilo
(en este caso por tener a alguien cerca, si las condiciones estuvieran al revés, 
terminaría si se encuentra alguno al que no le gana).
Esto es gracias a la evaluación perezosa, any es capaz de retornar True si se encuentra alguno que cumpla 
la condición indicada, y all es capaz de retornar False si alguno no cumple la condición correspondiente. 
Sin embargo, no podría terminar si se tratara de un auto que va tranquilo.

- puesto no puede terminar nunca porque hace falta saber cuántos le van ganando, entonces por más 
que se pueda tratar de filtrar el conjunto de autos, nunca se llegaría al final para calcular la longitud.

-}