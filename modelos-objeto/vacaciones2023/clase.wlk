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
class Persona{

  var property presupuestoMaximo 
  var property preferencia

  method elige(lugar) = preferencia.prefiere(lugar) 

  method puedePagar(monto) = monto <= presupuestoMaximo
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
object lugarRaro {
  method prefiere(lugar) = lugar.nombreRaro()
}

/*  << Strategy >>  strategy stateLess => no tienen estados */
class PreferenciaCombinada{
  var property preferencias =[]
  method prefiere(lugar) = preferencias.any{preferencia => preferencia.quiereIrA(lugar)}
}

//Punto 3


class Tour{
  const fechaSalida
  const integrantes = []
  const lugares
  const montoPorPersona
  const cantidadMaxima
  const listaDeEspera = []

//   var property personasAnotadas = []

  method montoTotal() = montoPorPersona * self.cantidadDeIntegrantes()
  method confirmado() = self.tourCompleto()

  method agregarPersona(persona){
    if (!persona.puedePagar(montoPorPersona)) {
        throw new DomainException(message = "El costo es mayor al presupuesto")
    }
    if (!self.eligeLugares(persona)) {
        throw new DomainException(message = "La persona no elige los lugares")
    }
    if (self.tourCompleto()) {
        throw new DomainException(message = "El tour está completo. Se añade a lista de espera")
    }
    integrantes.add(persona)
  }

  method darDeBaja(persona){
    integrantes.remove(persona)
    self.agregarPersonaLista()
  } 

  method agregarPersonaLista() {
    const nuevoIntegrante = listaDeEspera.first()
    listaDeEspera.remove(nuevoIntegrante)
    self.agregarPersona(nuevoIntegrante)
  }
  method eligeLugares(persona) = lugares.all{lugar => persona.elige(lugar)}
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