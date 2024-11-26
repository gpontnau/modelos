// Calendario para manejo de fechas
object calendario { 
    method hoy() = new Date()
    
    method mismoMes(fecha1, fecha2) = fecha1.month() == fecha2.month() && fecha1.year() == fecha2.year()
}

// === CLASES BASE ===
class EspacioUrbano {
    const property nombre
    const property superficie
    const property trabajosRealizados = []
    var property valuacion
    var property tieneVallado
    
    // Template Method - método de pregunta
    method esGrande() = superficie > 50 && self.condicionAdicionalGrande()
    
    // Primitiva para el template method - método de pregunta
    method condicionAdicionalGrande()
    
    // Método de efecto
    method registrarTrabajo(trabajo) {
        trabajosRealizados.add(trabajo)
    }
    
    // Método de pregunta
    method esDeUsoIntensivo() = self.trabajosUltimoMes().count({t => t.esHeavy()}) > 5
    
    // Método de pregunta
    method trabajosUltimoMes() = trabajosRealizados.filter({t => t.esDelUltimoMes()})
}

class Plaza inherits EspacioUrbano {
    const property cantidadCanchas
    
    override method condicionAdicionalGrande() = cantidadCanchas > 2
    
    method esVerde() = cantidadCanchas == 0
    
    method esLimpiable() = true
}

class Plazoleta inherits EspacioUrbano {
    const property procer
    
    override method condicionAdicionalGrande() = procer == "San Martín" && tieneVallado
    
    method esLimpiable() = false
}

class Anfiteatro inherits EspacioUrbano {
    const property capacidad
    // const property tamañoEscenario
    
    override method condicionAdicionalGrande() = capacidad > 500
    
    method esLimpiable() = self.esGrande()
}

// Composite pattern
class Multiespacio inherits EspacioUrbano {
    const property espacios = []
    
    override method condicionAdicionalGrande() = espacios.all({e => e.esGrande()})
    
    // Método de efecto
    method agregarEspacio(espacio) {
        espacios.add(espacio)
    }
    
    method esVerde() = espacios.size() > 3
    
    method esLimpiable() = false
}

// === STRATEGY PATTERN PARA PROFESIONES ===
class Persona {
    const property nombre
    var property profesion
    
    // Método de efecto que delega en la profesión
    method trabajarEn(espacioUrbano) {
        if (!profesion.puedeTrabajarEn(espacioUrbano)) {
            throw new DomainException(message = "No puede realizar este trabajo")
        }
        
        const trabajo = new Trabajo(
            persona = self,
            espacioUrbano = espacioUrbano,
            duracion = profesion.calcularDuracion(espacioUrbano),
            fecha = calendario.hoy(),
            costo = profesion.calcularCosto(self)
        )
        
        profesion.realizarTrabajo(espacioUrbano)
        espacioUrbano.registrarTrabajo(trabajo)
        return trabajo
    }
}

class Trabajo {
    const property persona
    const property espacioUrbano
    const property duracion
    const property fecha
    const property costo
    
    method esHeavy() = persona.profesion().esTrabajoHeavy(self)
    
    method esDelUltimoMes() = calendario.mismoMes(fecha, calendario.hoy())
}

object cerrajero {
    method puedeTrabajarEn(espacioUrbano) = !espacioUrbano.tieneVallado()
    
    method calcularDuracion(espacioUrbano) = if (espacioUrbano.esGrande()) 5 else 3
    
    // Método de efecto
    method realizarTrabajo(espacioUrbano) {
        espacioUrbano.tieneVallado(true)
    }
    
    method calcularCosto(persona) = self.calcularDuracion(self) * 100
    
    method esTrabajoHeavy(trabajo) = trabajo.duracion() > 5 || trabajo.costo() > 10000
}

object jardinero {
    method puedeTrabajarEn(espacioUrbano) = espacioUrbano.esVerde()
    
    method calcularDuracion(espacioUrbano) = espacioUrbano.superficie() / 10
    
    // Método de efecto
    method realizarTrabajo(espacioUrbano) {
        espacioUrbano.valuacion(espacioUrbano.valuacion() * 1.1)
    }
    
    method calcularCosto(persona) = 2500
    
    method esTrabajoHeavy(trabajo) = trabajo.costo() > 10000
}

object encargadoLimpieza {
    method puedeTrabajarEn(espacioUrbano) = espacioUrbano.esLimpiable()
    
    method calcularDuracion(espacioUrbano) = 8
    
    // Método de efecto
    method realizarTrabajo(espacioUrbano) {
        espacioUrbano.valuacion(espacioUrbano.valuacion() + 5000)
    }
    
    method calcularCosto(persona) = 8 * 100
    
    method esTrabajoHeavy(trabajo) = trabajo.costo() > 10000
}

// Ejemplo de uso en consola REPL:
/*
const tito = new Persona(nombre = "Tito", profesion = cerrajero)
tito.profesion(jardinero)
*/