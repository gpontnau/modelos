// Value Object para presupuesto
class Presupuesto {
    const monto
    
    method alcanzaPara(valor) = monto >= valor
}

// Criterios de diversión usando objetos
object criterioCiudad {
    method esDivertido(ciudad) = 
        ciudad.tieneAtraccionesSuficientes() and ciudad.esGrande()
}

object criterioPueblo {
    method esDivertido(pueblo) = 
        pueblo.esAntiguo() or pueblo.esDelLitoral()
}

object criterioBalneario {
    method esDivertido(balneario) = 
        balneario.tienePlayaGrande() and balneario.esMarPeligroso()
}

// Clase base para lugares
class Lugar {
    const property nombre
    const criterioDiversion
    
    method esDivertido() = 
        self.tieneCantidadParDeLetras() and criterioDiversion.esDivertido(self)
    
    method tieneCantidadParDeLetras() = nombre.size() % 2 == 0
    
    method esTranquilo()
}

class Ciudad inherits Lugar {
    const property habitantes
    const property atracciones
    const property decibeles
    
    override method esTranquilo() = decibeles < 20
    
    method tieneAtraccionesSuficientes() = atracciones.size() > 3
    
    method esGrande() = habitantes > 100000
}

class Pueblo inherits Lugar {
    const property extension
    const property anioFundacion
    const property provincia
    
    override method esTranquilo() = provincia == "La Pampa"
    
    method esAntiguo() = anioFundacion < 1800
    
    method esDelLitoral() = 
        ["Entre Ríos", "Corrientes", "Misiones"].includes(provincia)
}

class Balneario inherits Lugar {
    const property metrosPlayaPromedio
    const property marPeligroso
    const property tienePeatonal
    
    override method esTranquilo() = not tienePeatonal
    
    method tienePlayaGrande() = metrosPlayaPromedio > 300
    
    method esMarPeligroso() = marPeligroso
}

// Preferencias usando objetos
object preferenciaTranquilidad {
    method acepta(lugar) = lugar.esTranquilo()
}

object preferenciaDiversion {
    method acepta(lugar) = lugar.esDivertido()
}

object preferenciaLugaresRaros {
    method acepta(lugar) = self.nombreLugar(lugar).size() > 10

    method nombreLugar(lugar) = lugar.nombre()
}

class PreferenciaCompuesta {
    const preferencias
    
    method acepta(lugar) = 
        preferencias.any { preferencia => preferencia.acepta(lugar) }
}

class Persona {
    var property preferencia
    const property presupuesto
    
    method seIriaDeVacacionesA(lugar) = preferencia.acepta(lugar)
}

class Tour {
    const property fechaSalida
    const property cantidadPersonasRequerida
    const property lugaresARecorrer
    const property montoPorPersona
    const personasAnotadas = []
    
    method agregarPersona(persona) {
        if(self.estaConfirmado()) {
            throw new Exception(message = "El tour ya está confirmado")
        }
        if(not self.tienePresupuestoSuficiente(persona)) {
            throw new Exception(message = "Presupuesto insuficiente")
        }
        if(not self.lugaresApropiadosParaPersona(persona)) {
            throw new Exception(message = "Los lugares no son adecuados para la persona")
        }
        personasAnotadas.add(persona)
    }
    
    method tienePresupuestoSuficiente(persona) =
        persona.presupuesto().alcanzaPara(montoPorPersona)
    
    method lugaresApropiadosParaPersona(persona) =
        lugaresARecorrer.all { lugar => persona.seIriaDeVacacionesA(lugar) }
    
    method estaConfirmado() = 
        personasAnotadas.size() >= cantidadPersonasRequerida
    
    method bajarPersona(persona) {
        personasAnotadas.remove(persona)
    }
    
    method cantidadPersonas() = personasAnotadas.size()
}

// Gestor de Tours como objeto único
object gestorDeTours {
    const tours = []
    
    method agregarTour(tour) {
        tours.add(tour)
    }
    
    method toursPendientesDeConfirmacion() = 
        tours.filter { tour => not tour.estaConfirmado() }
    
    method totalDeToursQueSalenEsteAnio(anioActual) =
        tours.filter { tour => tour.fechaSalida().year() == anioActual }
             .sum { tour => tour.montoPorPersona() * tour.cantidadPersonas() }
}