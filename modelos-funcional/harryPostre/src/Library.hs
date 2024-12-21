module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero


------------------------- PUNTO 1 -------------------------
-- a.
type Sabor = String
type Porcentaje = Number
type Temperatura = Number
type Peso = Number

data Postre = Postre {
    sabores     :: [Sabor],
    peso        :: Peso,
    temperatura :: Temperatura
} deriving (Show, Eq)

-- b. Modelado de Hechizos

type Hechizo = Postre -> Postre

incendio :: Hechizo
incendio postre = postre { peso = (* 0.95) . peso $ postre,
                           temperatura = (+ 1) . temperatura $ postre  }

immobulus :: Hechizo
immobulus postre = postre { temperatura = 0 }

wingardiumLeviosa :: Hechizo
wingardiumLeviosa postre = postre { sabores = "concentrado" : sabores postre,
                                    peso = (* 0.9) . peso $ postre  }

diffindo :: Number -> Hechizo
diffindo porcentaje postreOriginal = postreOriginal {
    peso = (*(1 - porcentaje/100)) . peso $ postreOriginal
}

riddikulus :: String -> Hechizo
riddikulus saborNuevo postre = postre {
  sabores = (reverse saborNuevo :) . sabores $ postre
}

avadaKedavra :: Hechizo
avadaKedavra postre = (immobulus postre) { sabores = [] }

-- c. Modelado de Postres

estaListo :: Postre -> Bool
estaListo postre = ((>0) . peso $ postre) &&
                   (not . null . sabores $ postre) &&
                   ((>0) . temperatura $ postre)

-- d. postres listos

estanListos :: [Postre] -> Hechizo -> Bool
estanListos postres hechizo = all (estaListo . hechizo) postres

postresListos :: [Postre] -> [Postre]
postresListos = filter estaListo

sumaPesos :: [Postre] -> Number
sumaPesos = sum . map peso

cantidadPostres :: [Postre] -> Number
cantidadPostres = length . filter (/= 0) . map peso

calcularPromedio :: Number -> Number -> Number
calcularPromedio total cantidad
  | cantidad == 0 = 0
  | otherwise = total / cantidad

promedioPostresListos :: [Postre] -> Number
promedioPostresListos postres = calcularPromedio
                                (sumaPesos . postresListos $ postres)
                                (cantidadPostres . postresListos $ postres)

------------------------- PUNTO 2 -------------------------

-- modelado de magos

data Mago = Mago {
    hechizos            :: [Hechizo],
    cantidadHorrocruxes :: Number
} deriving Show

-- Parte A
agregarHechizo :: Mago -> Hechizo -> Mago
agregarHechizo mago hechizo = mago { hechizos = hechizo : hechizos mago }

sumarHorrocrux :: Mago -> Mago
sumarHorrocrux mago = mago { cantidadHorrocruxes = (+1) . cantidadHorrocruxes $ mago }

sonMismosResultados :: Hechizo -> Postre -> Bool
sonMismosResultados hechizo postre =  (== avadaKedavra postre) . hechizo $ postre

practicar :: Mago -> Hechizo -> Postre -> Mago
practicar mago hechizo postre
    | sonMismosResultados hechizo postre = sumarHorrocrux . agregarHechizo mago $ hechizo
    | otherwise                          = agregarHechizo mago hechizo

-- Parte B
cantidadSabores :: Postre -> Number
cantidadSabores = length . sabores

mejorHechizoPara :: Postre -> Hechizo -> Hechizo -> Hechizo
mejorHechizoPara postre hechizo1 hechizo2 
    | (>) (cantidadSabores . hechizo1 $ postre) . cantidadSabores . hechizo2 $ postre = hechizo1
    | otherwise = hechizo2

mejorHechizo :: Postre -> Mago -> Hechizo
mejorHechizo postre = head . hechizos

-- ------------------------- PUNTO 3 -------------------------

-- Parte A
modificarPostre :: String -> Postre -> Postre
modificarPostre nuevoSabor postre = postre {
    peso = (+10) . peso $ postre,
    sabores = nuevoSabor : sabores postre
}

postresInfinitos :: String -> [Postre]
postresInfinitos sabor = iterate (modificarPostre sabor) (Postre ["base"] 100 25)

magoInfinito :: Mago
magoInfinito = Mago (map diffindo [1..]) 0

{-
Parte B) Sobre consultar si un hechizo deja listos los infinitos postres:

- Sí es posible dar una respuesta cuando el hechizo tiene un comportamiento predecible:
  1. Si el hechizo congela (temperatura = 0), sabemos que ningún postre quedará listo
  2. Si el hechizo quita todos los sabores, sabemos que ningún postre quedará listo
  3. Si el hechizo reduce el peso a 0 o menos, sabemos que ningún postre quedará listo

- No es posible dar una respuesta cuando:
  1. El hechizo modifica los postres de forma que no podemos predecir si quedarán listos
  2. Necesitamos evaluar infinitos postres para saberlo

Parte C) Sobre encontrar el mejor hechizo entre infinitos hechizos:

- Sí es posible cuando:
  1. Existe un "techo" máximo de sabores que un hechizo puede dejar
  2. Podemos determinar ese máximo analizando el comportamiento del hechizo

- No es posible cuando:
  1. Los hechizos pueden agregar cantidades arbitrarias de sabores
  2. No hay forma de determinar un máximo
  3. Necesitamos comparar infinitos hechizos entre sí
-}