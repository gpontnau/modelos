module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero


data Mago = Mago {
    nombre          :: String,
    edad            :: Number,
    salud           :: Number,
    hechizos        :: [Hechizo]
} deriving (Show)

type Hechizo = Mago -> Mago

-- a. curar: el mago sobre el que lanzamos el hechizo recupere una cierta cantidad de salud.
curar :: Number -> Hechizo
curar cantidad mago = mago { salud = ((+) cantidad . salud) mago }

-- b. lanzarRayo: si la salud del mago q se le lanza el hechizo es mayor a 10, le hace 10 puntos de daño, de lo contrario le quita la mitad de su vida actual.
lanzarRayo :: Hechizo
lanzarRayo mago
    | ((> 10) . salud) mago = mago { salud = salud mago - 10 }
    | otherwise = mago { salud = salud mago `div` 2 }

-- c. amnesia: El mago objetivo olvida los primeros N hechizos que conozca. 
amnesia :: Number -> Hechizo
amnesia cantidad mago = mago { hechizos = (drop cantidad . hechizos) mago }

-- d. confundir: El mago objetivo se ataca a sí mismo con su primer hechizo.
confundir :: Hechizo
confundir mago = (head . hechizos) mago mago

------------------- PUNTO 2 -------------------
-- a. poder: El poder de un mago es su salud sumada al resultado de multiplicar 
--            su edad por la cantidad de hechizos que conoce.
poder :: Mago -> Number
poder mago = ((+) (salud mago) . (*) (edad mago) . length . hechizos) mago

-- b. daño: Esta función retorna la cantidad de vida que un mago pierde si le lanzan un hechizo.
danio :: Mago -> Hechizo -> Number
danio mago hechizo = (((-) . salud) mago . salud . hechizo) mago

-- c. diferenciaDePoder: valor absoluto de la resta del poder de cada uno.
diferenciaDePoder :: Mago -> Mago -> Number
diferenciaDePoder mago1 = abs . ((-) (poder mago1) . poder)

------------------- PUNTO 3 -------------------

data Academia = Academia {
    magos           :: [Mago],
    examenDeIngreso :: Mago -> Bool
} deriving (Show)

-- a. Saber si hay algún mago sin hechizos cuyo nombre sea "Rincewind".
esRincewindSinHechizos :: Mago -> Bool
esRincewindSinHechizos mago = ((&&) ((== "Rincewind") . nombre $ mago) . null . hechizos) mago

-- b. todos los magos viejos (>50) son ñoños. Ocurre si tienen más hechizos que salud.
esÑoño :: Mago -> Bool
esÑoño mago = ((&&) (magosViejos mago) . ((>) (length . hechizos $ mago) . salud)) mago

magosViejos :: Mago -> Bool
magosViejos = (> 50) . edad

-- c. Conocer la cantidad de magos que no pasarían el examen de ingreso si lo volvieran a rendir.
cantidadDeMagosQueNoPasarian :: Academia -> Number
cantidadDeMagosQueNoPasarian academia = length . filter (not . examenDeIngreso academia) . magos $ academia

-- d. sumatoria de la edad de los magos que saben más de 10 hechizos.
sumatoriaEdadExpertos :: Academia -> Number
sumatoriaEdadExpertos = sum . map edad . filter tieneMasDe10Hechizos . magos

tieneMasDe10Hechizos :: Mago -> Bool
tieneMasDe10Hechizos = (> 10) . length . hechizos

magoEjemplo :: Mago
magoEjemplo = Mago "Rincewind" 60 100 [curar 10, lanzarRayo, amnesia 2, confundir]

-- > esRincewindSinHechizos magoEjemplo
-- False

-- > esÑoño magoEjemplo
-- False

-- > (cantidadDeMagosQueNoPasarian . Academia [magoEjemplo]) esRincewindSinHechizos
-- 1

-- > (sumatoriaEdadExpertos . Academia [magoEjemplo]) esRincewindSinHechizos
-- 0

------------------- PUNTO 4 -------------------
maximoSegun criterio valor = foldl1 (mayorSegun $ criterio valor)

mayorSegun evaluador comparable1 comparable2
    | evaluador comparable1 >= evaluador comparable2 = comparable1
    | otherwise = comparable2

-- i. mejorHechizoContra
-- Dados dos magos, retorna el hechizo del segundo que le haga más daño al primero.
mejorHechizoContra :: Mago -> Mago -> Hechizo
mejorHechizoContra mago objetivo = maximoSegun danio objetivo . hechizos $ mago

-- ii. mejorOponente
-- Dado un mago y una academia, retorna el mago de la academia que tenga la mayor diferencia de poder con el mago recibido.
mejorOponente :: Mago -> Academia -> Mago
mejorOponente mago = maximoSegun diferenciaDePoder mago . magos

------------------- PUNTO 5 -------------------
noPuedeGanarle :: Mago -> Mago -> Bool
noPuedeGanarle objetivo = (==) (salud objetivo) . salud . foldr ($) objetivo . hechizos