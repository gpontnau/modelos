{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use section" #-}
module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero



data Material = Material {
  nombre    :: String,
  calidad   :: Number
} deriving (Show, Eq)

data Edificio = Edificio {
  tipoEdificio  :: String,
  materiales    :: [Material]
} deriving (Show, Eq)

data Aldea = Aldea {
  poblacion      :: Number,
  materialesDisp :: [Material],
  edificios      :: [Edificio]
} deriving (Show, Eq)

-------------------------------------- PUNTO 1 --------------------------------------
-- a. recibe un material y retorna true si su calidad es mayor a 20
esValioso :: Material -> Bool
esValioso = (> 20) . calidad

-- b. recibe material y aldea y retorna la cant de materiales disponibles con ese nombre en la aldea
unidadesDisponibles :: String -> Aldea -> Number
unidadesDisponibles nombreBuscado = length . filter ((== nombreBuscado) . nombre) . materialesDisp

-- c. valorTotal recibe una aldea y retorna la suma de la calidad de todos los materiales que hay en la aldea
valorTotal :: Aldea -> Number
valorTotal = sum . map calidad . todosLosMateriales

todosLosMateriales :: Aldea -> [Material]
todosLosMateriales aldea = materialesDisp aldea ++ materialesEnEdificios aldea

materialesEnEdificios :: Aldea -> [Material]
materialesEnEdificios = concatMap materiales . edificios

-------------------------------------- PUNTO 2 --------------------------------------
-- a. tenerGnomito que aumenta la población de la aldea en 1.
type Tarea = Aldea -> Aldea

tenerGnomito :: Tarea
tenerGnomito aldea = aldea { poblacion = (+ 1) . poblacion $ aldea}

-- b. lustrarMaderas que aumenta en 5 la calidad de todos los materiales disponibles cuyo nombre empiece con la palabra "Madera
lustrarMaderas :: Tarea
lustrarMaderas aldea = aldea { materialesDisp = map mejorarMaterial . materialesDisp $ aldea }

mejorarMaterial :: Material -> Material     -- funcion auxiliar
mejorarMaterial material
  | esMadera material = aumentarCalidad material
  | otherwise = material

esMadera :: Material -> Bool                -- funcion auxiliar
esMadera = (== "Madera") . take 6 . nombre

aumentarCalidad :: Material -> Material     -- funcion auxiliar
aumentarCalidad material = material { calidad = (+ 5) . calidad $ material  }

-- c. recolectar: dado material y cantidad se quiere recolectar, incorpore a los materialesDispo ese mismo material tantas veces como se indique.
recolectar :: Material -> Number -> Tarea
recolectar material cantidad aldea = aldea {
    materialesDisp = (++ replicate cantidad material) . materialesDisp $ aldea
  }

-------------------------------------- PUNTO 3 --------------------------------------
-- a. edificiosChetos: algún material valioso.
edificiosChetos :: Aldea -> [Edificio]
edificiosChetos = filter tieneAlgunMaterialValioso . edificios

tieneAlgunMaterialValioso :: Edificio -> Bool
tieneAlgunMaterialValioso = any esValioso . materiales

-- 3.b: lista de materialesComunes - se encuentran en todos los edificios de la aldea.
materialesComunes :: Aldea -> [String]
materialesComunes = materialesComunesEnEdificios . edificios

materialesComunesEnEdificios :: [Edificio] -> [String]
materialesComunesEnEdificios edificios = filter (flip estaEnTodosLosEdificios edificios) . nombresDeTodosMateriales $ edificios

nombresDeTodosMateriales :: [Edificio] -> [String]
nombresDeTodosMateriales = map nombre . concatMap materiales

estaEnTodosLosEdificios :: String -> [Edificio] -> Bool
estaEnTodosLosEdificios nombreMaterial = all (tieneMaterial nombreMaterial)

tieneMaterial :: String -> Edificio -> Bool
tieneMaterial nombreBuscado = any ((== nombreBuscado) . nombre) . materiales

-------------------------------------- PUNTO 4 --------------------------------------
-- a
realizarLasQueCumplan :: [Tarea] -> (Aldea -> Bool) -> Aldea -> Aldea
realizarLasQueCumplan tareas criterio aldeaInicial = 
  foldl (aplicarTareaSiCumple criterio) aldeaInicial tareas

aplicarTareaSiCumple :: (Aldea -> Bool) -> Aldea -> Tarea -> Aldea
aplicarTareaSiCumple criterio aldea tarea
  | criterio (tarea aldea) = tarea aldea 
  | otherwise = aldea


-- b.i