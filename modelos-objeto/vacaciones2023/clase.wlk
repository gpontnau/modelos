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

    override method esTranquilo() = !tienePeatonal
}

/*  << Context >>  */
class Persona {
    const property preferencia

    method prefiere(lugar) = preferencia.acepta(lugar)
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