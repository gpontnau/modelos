/************** PUNTO 1 ***************/
class Lugar {
    const property nombre
    
    method esDivertido() = self.tieneCantidadParDeLetras() && self.cumpleCriterioDiversion()
    
    method tieneCantidadParDeLetras() = nombre.size() % 2 == 0
    
    method cumpleCriterioDiversion()    
    method esTranquilo()
}

class Ciudad inherits Lugar {
    const property habitantes
    const property atracciones 
    const property decibeles
    
    override method cumpleCriterioDiversion() = 
        self.tieneAtraccionesSuficientes() and 
        self.esGrande()
    
    override method esTranquilo() = decibeles < 20
    
    method tieneAtraccionesSuficientes() = atracciones.size() > 3
    
    method esGrande() = habitantes > 100000
}

class Pueblo inherits Lugar {
    const property extension
    const property anioFundacion
    const property provincia
    
    override method cumpleCriterioDiversion() = self.esAntiguo() || self.esDelLitoral()
    
    override method esTranquilo() = provincia == "La Pampa"
    
    method esAntiguo() = anioFundacion < 1800
    
    method esDelLitoral() = ["Entre Ríos", "Corrientes", "Misiones"].includes(provincia)
}

class Balneario inherits Lugar {
    const property metrosPlayaPromedio
    const property marPeligroso
    const property tienePeatonal
    
    override method cumpleCriterioDiversion() = 
        self.tienePlayaGrande() and self.esMarPeligroso()
    
    override method esTranquilo() = not tienePeatonal // ! > not
    
    method tienePlayaGrande() = metrosPlayaPromedio > 300
    
    method esMarPeligroso() = marPeligroso
}

/**************** PUNRO 2 ****************/
class Persona {
    var property preferencia
    const property presupuesto
    
    method seIriaDeVacacionesA(lugar) = preferencia.acepta(lugar)
}

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
    const preferencias // falta la lista
    
    method acepta(lugar) = 
        preferencias.any { preferencia => preferencia.acepta(lugar) }
}


/************** PUNTO 3 ***************/
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

    method alcanzaPara(valor) = montoPorPersona >= valor
    
    method lugaresApropiadosParaPersona(persona) =
        lugaresARecorrer.all { lugar => persona.seIriaDeVacacionesA(lugar) }
    
    method estaConfirmado() = 
        personasAnotadas.size() >= cantidadPersonasRequerida
    
    method cantidadPersonas() = personasAnotadas.size()
}

/************** PUNTO 4 ***************/
object gestorDeTours {
    const tours = []
    
    method toursPendientesDeConfirmacion() = 
        tours.filter { tour => not tour.estaConfirmado() }
    
    method totalDeToursQueSalenEsteAnio(anioActual) =
        tours.filter { tour => tour.fechaSalida().year() == anioActual }
             .sum { tour => tour.montoPorPersona() * tour.cantidadPersonas() }
}