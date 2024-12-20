module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero


-------------------------------------- PUNTO 1 --------------------------------------
type Nombre = String
type Deuda = Number
type PorcentajeFelicidad = Number

data Persona = Persona {
  nombre     :: Nombre,
  deuda      :: Deuda,
  felicidad  :: PorcentajeFelicidad,
  esperanza  :: Bool,
  estrategia :: Estrategia
} deriving (Show, Eq)

type Estrategia = Persona -> Persona -> Bool

-- cualquier estado
conformista :: Estrategia
conformista _ _ = True

-- CON o SIN esperanza (eso se debe poder configurar) o con un % de felicidad > 50 (fijo)
esperanzado :: Bool -> Estrategia
esperanzado valorEsperanza _ personaModificada =
    ((== valorEsperanza) . esperanza $ personaModificada)
    || ((> 50) . felicidad $ personaModificada)

-- deuda con un valor menor a TANTOS pesos que debe poder cambiarse
economico :: Number -> Estrategia
economico limiteDuda _ = (< limiteDuda) . deuda

-- CON esperanza y económico con una deuda menor a 500. 
-- En caso de que alguno de los dos se cumpla acepta al candidato.
combinaEstrategias :: Estrategia -> Estrategia -> Estrategia
combinaEstrategias estratA estratB persona personaFutura =
   estratA persona personaFutura || estratB persona personaFutura

combinado :: Estrategia
combinado = combinaEstrategias (esperanzado True) (economico 500)

-- Modelado del país
paradigma :: [Persona]
paradigma = [
    Persona "Juan" 100 50 True conformista,
    Persona "Ana" 600 60 False (esperanzado False),
    Persona "Pedro" 500 70 True (economico 100),
    Persona "Laura" 200 80 False combinado
  ]

-------------------------------------- PUNTO 2 --------------------------------------
-- nombre de más de 2 vocales
tieneNombreConMasDeDosVocales :: [Persona] -> Bool
tieneNombreConMasDeDosVocales = any ((> 2) . length . filter isVowel . nombre)

isVowel :: Char -> Bool
isVowel letra = letra `elem` "aeiouAEIOU"

-- total de deuda de las personas que tienen un valor de deuda par
sumaDeudasPares :: [Persona] -> Number
sumaDeudasPares = sum . filter even . map deuda

-------------------------------------- PUNTO 3 --------------------------------------
-- Candidatos
type Candidato = Persona -> Persona

-- nos promete que le perdona la mitad de la deuda a una persona
yrigoyen :: Candidato
yrigoyen persona = persona { deuda = ((/ 2) . deuda) persona }

-- le devuelve la esperanza a la gente y le da un 10% más de felicidad
alende :: Candidato
alende persona = persona { esperanza = True,
                           felicidad = (min 100 . (+ 10) . felicidad) persona }

-- te saca la esperanza y te agrega 100 $ de deuda
alsogaray :: Candidato
alsogaray persona = persona { esperanza = False, 
                              deuda = ((+ 100) . deuda) persona }

-- es una combinación de Yrigoyen y Alende 
martinezRaymonda :: Candidato
martinezRaymonda = alende . yrigoyen

-------------------------------------- PUNTO 4 --------------------------------------
-- recursividad
votarCandidatos :: Persona -> [Candidato] -> [Candidato]
votarCandidatos _ [] = []
votarCandidatos persona (candidato:candidatos) 
    | (estrategia persona persona . candidato) persona = candidato : votarCandidatos persona candidatos
    | otherwise                                        = []

-------------------------------------- PUNTO 5 --------------------------------------
aplicarVotosCandidatos :: Persona -> [Candidato] -> Persona
aplicarVotosCandidatos persona candidatos = 
    foldr ($) persona (votarCandidatos persona candidatos)

manuel :: Persona
manuel = Persona "Manuel" 100 50 True conformista

candidatos :: [Candidato]
candidatos = [yrigoyen, alende, alsogaray, martinezRaymonda]

-- > aplicarVotosCandidatos manuel candidatos