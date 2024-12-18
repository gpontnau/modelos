module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero



type Color = String
type Velocidad = Number 
type Distancia = Number
type Tiempo = Number

data Auto = Auto {
    color           :: Color,
    velocidad       :: Velocidad,
    distancia       :: Distancia
} deriving (Show, Eq)

type Carrera = [Auto]

estaCerca :: Auto -> Auto -> Bool 
estaCerca auto1 auto2 = auto1 /= auto2 && distanciaEntre auto1 auto2 < 10

distanciaEntre :: Auto -> Auto -> Number 
distanciaEntre auto1 = abs . (distanciaRecorrida auto1 -) . distanciaRecorrida

vaTranquilo :: Auto -> Carrera -> Bool 
vaTranquilo auto carrera = (not . tieneAlgunAutoCerca auto) carrera
                            && vaGanando auto carrera

tieneAlgunAutoCerca :: Auto -> Carrera -> Bool 
tieneAlgunAutoCerca auto = any (estaCerca auto) 

vaGanando :: Auto -> Carrera -> Bool
vaGanando auto = all (leVaGanando auto) . filter (/= auto)

leVaGanando :: Auto -> Auto -> Bool
leVaGanando ganador = (< distanciaRecorrida ganador).distanciaRecorrida

puesto :: Auto -> Carrera -> Number 
puesto auto = (1 +) . length . filter (not . leVaGanando auto) 

correr :: Number -> Auto -> Auto
correr tiempo auto = auto { distanciaRecorrida = distanciaRecorrida auto + tiempo * velocidad auto }