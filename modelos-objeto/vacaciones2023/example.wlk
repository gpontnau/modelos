// Value Object para presupuesto
class Presupuesto {
    const monto
    
    method alcanzaPara(valor) {
        return monto >= valor
    }
}

// Criterios de diversión usando objetos
object criterioCiudad {
    method esDivertido(ciudad) {
        return ciudad.tieneAtraccionesSuficientes() and ciudad.esGrande()
    }
}

object criterioPueblo {
    method esDivertido(pueblo) {
        return pueblo.esAntiguo() or pueblo.esDelLitoral()
    }
}

object criterioBalneario {
    method esDivertido(balneario) {
        return balneario.tienePlayaGrande() and balneario.esMarPeligroso()
    }
}

// Clase base para lugares
class Lugar {
    const property nombre
    const criterioDiversion
    
    method esDivertido() {
        return self.tieneCantidadParDeLetras() and 
               criterioDiversion.esDivertido(self)
    }
    
    method tieneCantidadParDeLetras() {
        return nombre.size() % 2 == 0
    }
    
    method esTranquilo()
}

class Ciudad inherits Lugar {
    const property habitantes
    const property atracciones
    const property decibeles
  
    
    override method esTranquilo() {
        return decibeles < 20
    }
    
    method tieneAtraccionesSuficientes() {
        return atracciones.size() > 3
    }
    
    method esGrande() {
        return habitantes > 100000
    }
}

class Pueblo inherits Lugar {
    const property extension
    const property anioFundacion
    const property provincia
    
    method initialize(unNombre, ext, anio, prov) {
        super(unNombre, criterioPueblo)
        extension = ext
        anioFundacion = anio
        provincia = prov
    }
    
    override method esTranquilo() {
        return provincia == "La Pampa"
    }
    
    method esAntiguo() {
        return anioFundacion < 1800
    }
    
    method esDelLitoral() {
        return #{"Entre Ríos", "Corrientes", "Misiones"}.contains(provincia)
    }
}

class Balneario inherits Lugar {
    const property metrosPlayaPromedio
    const property marPeligroso
    const property tienePeatonal
    
    method initialize(unNombre, metros, peligroso, peatonal) {
        super(unNombre, criterioBalneario)
        metrosPlayaPromedio = metros
        marPeligroso = peligroso
        tienePeatonal = peatonal
    }
    
    override method esTranquilo() {
        return not tienePeatonal
    }
    
    method tienePlayaGrande() {
        return metrosPlayaPromedio > 300
    }
    
    method esMarPeligroso() {
        return marPeligroso
    }
}

// Preferencias usando objetos
object preferenciaTranquilidad {
    method acepta(lugar) {
        return lugar.esTranquilo()
    }
}

object preferenciaDiversion {
    method acepta(lugar) {
        return lugar.esDivertido()
    }
}

object preferenciaLugaresRaros {
    method acepta(lugar) {
        return lugar.nombre().size() > 10
    }
}

class PreferenciaCompuesta {
    const preferencias
    
    method initialize(listaPreferencias) {
        preferencias = listaPreferencias
    }
    
    method acepta(lugar) {
        return preferencias.any { preferencia => preferencia.acepta(lugar) }
    }
}

class Persona {
    var property preferencia
    const property presupuesto
    
    method initialize(unaPreferencia, unPresupuesto) {
        preferencia = unaPreferencia
        presupuesto = new Presupuesto(unPresupuesto)
    }
    
    method seIriaDeVacacionesA(lugar) {
        return preferencia.acepta(lugar)
    }
}

// Builder para Tour
class TourBuilder {
    var fechaSalida
    var cantidadPersonasRequerida
    var lugaresARecorrer = []
    var montoPorPersona
    
    method conFechaSalida(fecha) {
        fechaSalida = fecha
        return self
    }
    
    method conCantidadPersonas(cantidad) {
        cantidadPersonasRequerida = cantidad
        return self
    }
    
    method agregarLugar(lugar) {
        lugaresARecorrer.add(lugar)
        return self
    }
    
    method conMontoPorPersona(monto) {
        montoPorPersona = monto
        return self
    }
    
    method build() {
        return new Tour(fechaSalida, cantidadPersonasRequerida, 
                       lugaresARecorrer, montoPorPersona)
    }
}

class Tour {
    const property fechaSalida
    const property cantidadPersonasRequerida
    const property lugaresARecorrer
    const property montoPorPersona
    const personasAnotadas = []
    
    method agregarPersona(persona) {
        self.validarEstadoTour()
        self.validarPresupuestoPersona(persona)
        self.validarPreferenciasPersona(persona)
        personasAnotadas.add(persona)
    }
    
    method validarEstadoTour() {
        if (self.estaConfirmado()) {
            self.error("El tour ya está confirmado")
        }
    }
    
    method validarPresupuestoPersona(persona) {
        if (not persona.presupuesto().alcanzaPara(montoPorPersona)) {
            self.error("Presupuesto insuficiente")
        }
    }
    
    method validarPreferenciasPersona(persona) {
        if (not lugaresARecorrer.all { lugar => persona.seIriaDeVacacionesA(lugar) }) {
            self.error("Los lugares no son adecuados para la persona")
        }
    }
    
    method estaConfirmado() {
        return personasAnotadas.size() >= cantidadPersonasRequerida
    }
    
    method bajarPersona(persona) {
        personasAnotadas.remove(persona)
    }
    
    method cantidadPersonas() {
        return personasAnotadas.size()
    }
}

// Gestor de Tours como objeto único
object gestorDeTours {
    const tours = []
    
    method agregarTour(tour) {
        tours.add(tour)
    }
    
    method toursPendientesDeConfirmacion() {
        return tours.filter { tour => not tour.estaConfirmado() }
    }
    
    method totalDeToursQueSalenEsteAnio(anioActual) {
        return tours.filter { tour => tour.fechaSalida().year() == anioActual }
                   .sum { tour => tour.montoPorPersona() * tour.cantidadPersonas() }
    }
}