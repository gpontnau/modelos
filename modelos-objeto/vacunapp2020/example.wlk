class Vacuna {
  // Template method para aplicación de vacunas
  method multiplicarAnticuerpos(persona) // Hook method
  method otorgarInmunidad(persona) // Hook method
  method calcularCostoExtra(persona) // Hook method
  
  // Operación primitiva que ejecuta la aplicación
  method aplicarA(persona) {
    self.multiplicarAnticuerpos(persona)
    self.otorgarInmunidad(persona)
  }
  
  // Calcula costo total incluyendo extras
  method costoTotal(persona) {
    return self.costoPorEdad(persona) + self.calcularCostoExtra(persona)
  }
  
  // Implementación base del costo por edad
  method costoPorEdad(persona) {
    const costoBase = 1000
    const aniosExtra = (persona.edad() - 30).max(0)
    return costoBase + aniosExtra * 50
  }
}

object fechaReferencia {
  // Singleton para manejar fechas fijas del sistema
  const property fechaLarussa = new Date(day = 3, month = 3, year = 2022)
  const property fechaInmunidosaFija = new Date(day = 5, month = 3, year = 2022)
  
  method hoy() = new Date()  // Método para facilitar testing
}

object paifer inherits Vacuna {
  // Multiplicador fijo de 10x
  override method multiplicarAnticuerpos(persona) {
    persona.multiplicarAnticuerpos(10)
  }
  
  // Inmunidad variable según edad
  override method otorgarInmunidad(persona) {
    const meses = if(persona.edad() > 40) 6 else 9
    persona.otorgarInmunidadPorMeses(meses)
  }
  
  // Extra por edad
  override method calcularCostoExtra(persona) {
    return if(persona.edad() < 18) 400 else 100
  }
}

class Larussa inherits Vacuna {
  const property efectoMultiplicador
  
  // Multiplicador con tope en 20x
  override method multiplicarAnticuerpos(persona) {
    persona.multiplicarAnticuerpos(efectoMultiplicador.min(20))
  }
  
  // Fecha fija de inmunidad
  override method otorgarInmunidad(persona) {
    persona.otorgarInmunidadHasta(fechaReferencia.fechaLarussa())
  }
  
  // Extra proporcional al efecto
  override method calcularCostoExtra(persona) {
    return efectoMultiplicador * 100
  }
}

object astraLaVistaZeneca inherits Vacuna {
  // Suma fija de anticuerpos
  override method multiplicarAnticuerpos(persona) {
    persona.sumarAnticuerpos(10000)
  }
  
  // Inmunidad según paridad del nombre
  override method otorgarInmunidad(persona) {
    const meses = if(persona.nombre().size() % 2 == 0) 6 else 7
    persona.otorgarInmunidadPorMeses(meses)
  }
  
  // Extra por zona geográfica
  override method calcularCostoExtra(persona) {
    const provinciasEspeciales = #{"Tierra del Fuego", "Santa Cruz", "Neuquén"}
    return if(provinciasEspeciales.contains(persona.provincia())) 2000 else 0
  }
}

class Combineta inherits Vacuna { // Composite
  const property vacunas = []
  
  // Aplica todas las vacunas
  override method multiplicarAnticuerpos(persona) {
    vacunas.forEach({ vacuna => vacuna.multiplicarAnticuerpos(persona) })
  }
  
  // Toma la máxima inmunidad
  override method otorgarInmunidad(persona) {
    const inmunidades = vacunas.map({ vacuna => vacuna.calcularInmunidad(persona) })
    persona.otorgarInmunidad(inmunidades.max())
  }
  
  // Suma extras más cargo por combinación
  override method calcularCostoExtra(persona) {
    return vacunas.sum({ vacuna => vacuna.calcularCostoExtra(persona) }) + vacunas.size() * 100
  }
}

// --- Criterios.wlk ---
// Strategy pattern para criterios de aceptación
object cualquierosa {
  method acepta(vacuna, persona) = true
}

object anticuerposa {
  method acepta(vacuna, persona) {
    const anticuerposOriginales = persona.anticuerpos()
    vacuna.multiplicarAnticuerpos(persona)
    const cumple = persona.anticuerpos() > 100000
    persona.anticuerpos(anticuerposOriginales)
    return cumple
  }
}

object inmunidosaFija {
  method acepta(vacuna, persona) {
    return vacuna.calcularInmunidad(persona) > fechaReferencia.fechaInmunidosaFija()
  }
}

class InmunidosaVariable {
  const property mesesRequeridos
  
  method acepta(vacuna, persona) {
    const fechaRequerida = fechaReferencia.hoy()
    fechaRequerida.plusMonths(mesesRequeridos)
    return vacuna.calcularInmunidad(persona) > fechaRequerida
  }
}

// --- Personas.wlk ---
class Persona {
  const property nombre
  const property edad
  const property provincia
  var property anticuerpos
  var property inmunidadHasta
  var property criterioEleccion // Strategy
  const property historialVacunas = []
  
  // Métodos de efecto para anticuerpos
  method multiplicarAnticuerpos(factor) {
    anticuerpos *= factor
  }
  
  method sumarAnticuerpos(cantidad) {
    anticuerpos += cantidad
  }
  
  // Métodos de efecto para inmunidad
  method otorgarInmunidadPorMeses(meses) {
    const fecha = fechaReferencia.hoy()
    fecha.plusMonths(meses)
    inmunidadHasta = fecha
  }
  
  method otorgarInmunidadHasta(fecha) {
    inmunidadHasta = fecha
  }
  
  // Delegación al strategy
  method aceptaVacuna(vacuna) {
    return criterioEleccion.acepta(vacuna, self)
  }
  
  // Método principal de aplicación
  method aplicarVacuna(vacuna) {
    if(self.aceptaVacuna(vacuna)) {
      vacuna.aplicarA(self)
      historialVacunas.add(vacuna)
    } else {
      throw new Exception(message = "La vacuna solicitada no es aplicable para la persona")
    }
  }
}

// --- PlanVacunacion.wlk ---
object planVacunacion {
  // Catálogo de vacunas disponibles
  const vacunasDisponibles = [
    paifer,
    new Larussa(efectoMultiplicador = 5),
    new Larussa(efectoMultiplicador = 2),
    astraLaVistaZeneca,
    new Combineta(vacunas = [new Larussa(efectoMultiplicador = 2), paifer])
  ]
  
  // Selección de vacuna óptima
  method vacunaParaPersona(persona) {
    const vacunasAceptadas = vacunasDisponibles.filter({ 
      vacuna => persona.aceptaVacuna(vacuna)
    })
    
    if(vacunasAceptadas.isEmpty()) {
      return null
    }
    
    return vacunasAceptadas.min({ 
      vacuna => vacuna.costoTotal(persona)
    })
  }
  
  // Cálculo del costo total del plan
  method costoTotal(personas) {
    return personas.sum({ persona =>
      const vacuna = self.vacunaParaPersona(persona)
      if(vacuna != null) vacuna.costoTotal(persona) else 0
    })
  }
}