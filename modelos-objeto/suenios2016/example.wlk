// Persona y sus comportamientos (Strategy Pattern)
class Persona {
    const property edad
    const property carrerasDeseadas = []
    const property sueldoDeseado
    const property lugaresParaViajar = []
    var property cantidadHijos = 0
    const property suenosPendientes = []
    const property suenosCumplidos = []
    var property comportamiento
    
    method cumplirSueno(sueno) {
        sueno.intentarCumplir(self)
    }
    
    method agregarSuenoCumplido(sueno) {
        suenosCumplidos.add(sueno)
        suenosPendientes.remove(sueno)
    }
    
    method esAmbiciosa() {
        return (suenosPendientes + suenosCumplidos).count({ sueno => sueno.felicidonios() > 100 }) > 3
    }
    
    method felicidoniosTotales() {
        return suenosCumplidos.sum({ sueno => sueno.felicidonios() })
    }
    
    method felicidoniosPendientes() {
        return suenosPendientes.sum({ sueno => sueno.felicidonios() })
    }
    
    method esFeliz() {
        return self.felicidoniosTotales() > self.felicidoniosPendientes()
    }
    
    method cumplirSuenoPreciado() {
        comportamiento.cumplirSuenoPreciado(self)
    }
}

// Strategy Pattern para tipos de personas
object realista {
    method cumplirSuenoPreciado(persona) {
        const sueno = persona.suenosPendientes().max({ sueno => sueno.felicidonios() })
        persona.cumplirSueno(sueno)
    }
}

object alocado {
    method cumplirSuenoPreciado(persona) {
        const sueno = persona.suenosPendientes().anyOne()
        persona.cumplirSueno(sueno)
    }
}

object obsesivo {
    method cumplirSuenoPreciado(persona) {
        const sueno = persona.suenosPendientes().first()
        persona.cumplirSueno(sueno)
    }
}

// Template Method Pattern para Sueños
class Sueno {
    const property felicidonios
    
    method intentarCumplir(persona) {
        if (!self.validar(persona)) {
            throw new Exception(message = "No se puede cumplir el sueño")
        }
        self.cumplir(persona)
        persona.agregarSuenoCumplido(self)
    }
    
    method validar(persona)
    method cumplir(persona)
}

class RecibirseDeCarrera inherits Sueno {
    const carrera
    
    override method validar(persona) {
        return persona.carrerasDeseadas().contains(carrera) && 
               !persona.suenosCumplidos().any({ sueno => 
                   sueno.instanceOf(RecibirseDeCarrera) && sueno.carrera() == carrera
               })
    }
    
    override method cumplir(persona) {
        // Efecto de recibirse
    }
}

class TenerHijo inherits Sueno {
    override method validar(persona) {
        return !persona.suenosCumplidos().any({ sueno => sueno.instanceOf(AdoptarHijos) })
    }
    
    override method cumplir(persona) {
        persona.cantidadHijos(persona.cantidadHijos() + 1)
    }
}

class AdoptarHijos inherits Sueno {
    const cantidad
    
    override method validar(persona) {
        return !persona.suenosCumplidos().any({ sueno => sueno.instanceOf(TenerHijo) })
    }
    
    override method cumplir(persona) {
        persona.cantidadHijos(persona.cantidadHijos() + cantidad)
    }
}

class Viajar inherits Sueno {
    const destino
    
    override method validar(persona) {
        return persona.lugaresParaViajar().contains(destino)
    }
    
    override method cumplir(persona) {
        // Efecto de viajar
    }
}

class ConseguirTrabajo inherits Sueno {
    const sueldo
    
    override method validar(persona) {
        return sueldo >= persona.sueldoDeseado()
    }
    
    override method cumplir(persona) {
        // Efecto de conseguir trabajo
    }
}

// Composite Pattern para Sueño Múltiple
class SuenoMultiple inherits Sueno {
    const suenos = []
    
    override method validar(persona) {
        return suenos.all({ sueno => sueno.validar(persona) })
    }
    
    override method cumplir(persona) {
        suenos.forEach({ sueno => sueno.cumplir(persona) })
    }
    
    method agregarSueno(sueno) {
        suenos.add(sueno)
    }
    
    override method felicidonios() {
        return suenos.sum({ sueno => sueno.felicidonios() })
    }
}