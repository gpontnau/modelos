class CompraDeCompania {
    const property peliculas = []
    const property porcentaje
    
    method costo() = self.recaudacionTotal() * porcentaje / 100
    
    method recaudacionTotal() = peliculas.sum{ pelicula => pelicula.recaudacion() }
    
    method personajesInvolucrados() = self.todosLosPersonajes().asSet()
    
    method todosLosPersonajes() = peliculas.map{ pelicula => pelicula.personajes() }.flatten()
}

class ConstruccionParque {
    const property costoAtracciones
    const property metros
    
    method costo() = costoAtracciones + metros * mundo.precioMetroCuadrado()
    
    method personajesInvolucrados() = []
}

class ProduccionPelicula {
    const property costoBase
    const property personajes = []
    const property esIndependiente
    
    method costo() = costoBase + self.costoPersonajes()
    
    method costoPersonajes() = if(esIndependiente) self.costoPersonajesPrincipales() else self.costoTodosPersonajes()
    
    method costoPersonajesPrincipales() = self.personajesPrincipales().sum{ p => p.sueldo() }
    
    method costoTodosPersonajes() = personajes.sum{ p => p.sueldo() }
    
    method personajesPrincipales() = personajes.sortBy{ p1, p2 => p1.sueldo() > p2.sueldo() }.take(4)
    
    method personajesInvolucrados() = personajes.asSet()
}

class Pelicula {
    const property recaudacion
    const property personajes = []
}

class Personaje {
    var property sueldo
    const property nombre
    
    method duplicarSueldo() {
        sueldo *= 2
    }
}

class Raton {
    const property nombre
    const property inversiones = []
    const property pendientes = []
    var property dinero
    
    method costoTotal() = inversiones.sum{ inv => inv.costo() }
    
    method costoPendientes() = pendientes.sum{ inv => inv.costo() }
    
    method esAmbicioso() = self.costoPendientes() > dinero * 2
    
    method personajes() = self.personajesDeInversiones().asSet()
    
    method personajesDeInversiones() = inversiones.map{ inv => inv.personajesInvolucrados() }.flatten()
    
    method personajePeorPago() = self.personajes().min{ p => p.sueldo() }
    
    method esMasRatonQue(otroRaton) = self.costoTotal() < otroRaton.costoTotal()
    
    method puedeRealizarInversion(inversion) = inversion.costo() <= dinero
    
    method realizarInversion(inversion) {
        if(self.puedeRealizarInversion(inversion)) {
            self.pagarInversion(inversion)
            self.registrarInversion(inversion)
        }
    }
    
    method pagarInversion(inversion) {
        dinero -= inversion.costo()
    }
    
    method registrarInversion(inversion) {
        inversiones.add(inversion)
        pendientes.remove(inversion)
    }
    
    method realizarPendientes() {
        pendientes.forEach{ inv => self.intentarRealizarInversion(inv) }
    }
    
    method intentarRealizarInversion(inversion) {
        if(self.puedeRealizarInversion(inversion)) {
            self.realizarInversion(inversion)
        }
    }
}

object mundo {
    var property precioMetroCuadrado = 1000
    const property ratones = []
    
    method tocarFlauta() {
        self.ratonesAmbiciosos().forEach{ raton => raton.realizarPendientes() }
    }
    
    method ratonesAmbiciosos() = ratones.filter{ raton => raton.esAmbicioso() }
    
    method mejorarSueldos() {
        ratones.forEach{ raton => self.mejorarSueldoRaton(raton) }
    }
    
    method mejorarSueldoRaton(raton) {
        raton.personajePeorPago().duplicarSueldo()
    }
}