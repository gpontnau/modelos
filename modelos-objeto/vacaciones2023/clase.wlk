class Lugar {
    const property nombre

    // metodo template
    method esDivertido() = nombre.length().even() && self.esDivertidoExtra()

    // primitiva/hook (al menos debe de haber una primitiva por template method)
    method esDivertidoExtra()
    method esTranquilo()

    method esRaro() = nombre.length() > 10
}


class Ciudad inherits Lugar {
    const property atracciones = []
    const property cantHabitantes 
    const property decibeles

    override method esDivertidoExtra() = nombre.length().even() && 
                            (atracciones.length() > 3 && cantHabitantes > 100000)

    override method esTranquilo() = decibeles < 20

}

class Pueblo inherits Lugar {
    const property extension
    const property anioFundacion
    const property provincia

    override method esDivertidoExtra() = nombre.length().even() && 
                            (self.esAntiguo() || self.esDelLitoral())

    method esAntiguo() = anioFundacion < 1800
    method esDelLitoral() = ["Entre Ríos", "Corrientes", "Misiones"].includes(provincia)
}

class Balneario inherits Lugar {
    const property marPeligroso
    const property extensionPlaya
    const property tienePeatonal

    override method esDivertidoExtra() = extensionPlaya > 300 and marPeligroso

    method puedePagar

    override method esTranquilo() = !tienePeatonal
}


/*  << Context >>  */
class Persona {
    const property preferencia
    var property presupuestoMax

    method prefiere(lugar) = preferencia.acepta(lugar)

    // presupuestoMax se delega en persona y no en tour para hacer mas cohesivo
    method puedePagar(monto) = monto <= presupuestoMax

    method eligeLugares(lugares) = lugares.all { lugar => self.prefiere(lugar) }

    // method hayLugar() = integrantes.size() < cuposTotales
}

/*  << Strategy >>  strategy stateLess => no tienen estados */
object tranquilidad {
    method prefiere(lugar) = lugar.esTranquilo()
}

/*  << Strategy >>  strategy stateLess => no tienen estados */
object diversion {
    method prefiere(lugar) = lugar.esDivertido()
}

/*  << Strategy >>  strategy stateLess => no tienen estados */
object raris {
    method prefiere(lugar) = lugar.esRaro()
}

/*  << Strategy >>  strategy stateLess => no tienen estados */
object combineta {
    const property estrategias = []

    method prefiere(lugar) = estrategias.any { estrategia => estrategia.prefiere(lugar) }
}

/************** PUNTO 3 ***************/
class Tour {
    const property integrantes = []
    const property destinos = []
    const property listaEspera = []
    const property cuposTotales
    var property montoTour
    const property cantidadMaxima
    const property fechaSalida

    method hayLugar() = integrantes.size() < cuposTotales
    
    // method bajarPersona(persoba) { integrantes.remove(persona) }

    method agregarPersona(persona) {
        if (!(persona.puedePagar(montoTour))) {
            throw new DomainException(message = "Usted esta dispuesto a pagar menos que" + montoTour)
        }
        if (!(persona.eligeLugares(destinos))) {
            throw new DomainException(message = "Algun lugar no lo eligiria")
        }
        if (!self.hayLugar()) {
            throw new DomainException(message = "No hay mas lugar")
        }
        integrantes.add(persona)
    }

  method darDeBaja(persona){
    integrantes.remove(persona)
    self.agregarPersonaLista()
  } 

  method agregarPersonaLista() {
    const nuevoIntegrante = listaEspera.first()
    listaEspera.remove(nuevoIntegrante)
    self.agregarPersona(nuevoIntegrante)
  }
  method eligeLugares(persona) = destinos.all{lugar => persona.elige(lugar)}
  method tourCompleto() = self.cantidadDeIntegrantes() == cantidadMaxima
  method cantidadDeIntegrantes() = integrantes.size()

  method esDeEsteAnio() = fechaSalida.year() == new Date().year()
}


/************** PUNTO 4 ***************/
object reporte{
  const tours = []

  method toursPendientes() = tours.filter{tour => !tour.confirmado()}

  method montoTotalAnio() = self.toursEsteAnio().sum{tour => tour.montoTotal()}

  method toursEsteAnio() = tours.filter{tour => tour.esDeEsteAnio()}

}