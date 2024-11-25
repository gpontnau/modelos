// HERENCIA: Clase base que define el comportamiento común de todos los comensales.
// Ventaja: Permite reutilizar código y que cada comensal específico solo defina su comportamiento particular */
class Comensal {
  var property posicion
  const property elementosCerca = []
  const property comidasIngeridas = []
  const property criterioParaPasar 
  const property criterioParaComer
  
  method pedirElemento(elemento, comensal) {
    if (!comensal.tieneElemento(elemento)) {
      self.error("No tengo ese elemento")
    }
    criterioParaPasar.ejecutar(self, comensal, elemento)
  }
  
  method tieneElemento(elemento) = elementosCerca.contains(elemento)
  
  method pasarElemento(elemento, comensal) {
    elementosCerca.remove(elemento)
    comensal.recibirElemento(elemento)
  }
  
  method recibirElemento(elemento) {
    elementosCerca.add(elemento)
  }
  
  method cambiarPosicion(comensal) {
    const posicionTemporal = posicion
    posicion = comensal.posicion()
    comensal.posicion(posicionTemporal)
  }
  
  method evaluarComida(comida) {
    if (criterioParaComer.acepta(comida)) {
      self.comer(comida)
    }
  }
  
  method comer(comida) {
    comidasIngeridas.add(comida)
  }
  
  method estaPipon() = comidasIngeridas.any{ comida => comida.esPesada() }
  
  method cantidadElementosCerca() = elementosCerca.size()
  
  method comioAlgo() = not comidasIngeridas.isEmpty()
  
  method comioCarne() = comidasIngeridas.any{ comida => comida.esCarne() }
}

// POLIMORFISMO: Diferentes estrategias para pasar elementos.
// Ventaja: Permite agregar nuevos comportamientos sin modificar el código existente
// y cambiar el comportamiento en tiempo de ejecución 
object pasarPrimerElemento {
  method ejecutar(origen, destino, elemento) {
    const primerElemento = origen.elementosCerca().first()
    origen.pasarElemento(primerElemento, destino)
  }
}

object pasarTodo {
  method ejecutar(origen, destino, elemento) {
    origen.elementosCerca().forEach{ elem => 
      origen.pasarElemento(elem, destino)
    }
  }
}

object cambiarPosicion {
  method ejecutar(origen, destino, elemento) {
    origen.cambiarPosicion(destino)
  }
}

// POLIMORFISMO: Diferentes criterios para aceptar comida.
// Ventaja: Cada criterio implementa su propia lógica manteniendo la misma interfaz */
object vegetariano {
  method acepta(comida) = not comida.esCarne()
}

object dietetico {
  var property limiteCalorias = 500
  
  method acepta(comida) = comida.calorias() < limiteCalorias
  method limiteCalorias(nuevo) { limiteCalorias = nuevo }
}

object alternado {
  var property aceptaProxima = true
  
  method acepta(comida) {
    const decision = aceptaProxima
    aceptaProxima = not aceptaProxima
    return decision
  }
}

// COMPOSICIÓN: Permite combinar múltiples criterios.
// Ventaja: Crea comportamientos complejos combinando simples,
// más flexible que la herencia
class CriterioCombinado {
  const property criterios = []
   
  method acepta(comida) = criterios.all{ criterio => criterio.acepta(comida) }
}


// HERENCIA: Cada comensal específico hereda de Comensal y define su propio
// criterio para pasarla bien.
// Ventaja: Solo necesitan implementar su comportamiento particular
// object osky inherits Comensal {
//   method laPasaBien() = true
// }

// object moni inherits Comensal {
//   method laPasaBien() = self.comioAlgo() and posicion == "1@1"
// }

// object facu inherits Comensal {
//   method laPasaBien() = self.comioAlgo() and self.comioCarne()
// }

// object vero inherits Comensal {
//   method laPasaBien() = self.comioAlgo() and self.cantidadElementosCerca() <= 3
// }