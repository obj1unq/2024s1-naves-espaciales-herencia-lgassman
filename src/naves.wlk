class Nave {
	var property velocidad = 0
	
	method propulsar() {
		self.acelerar(20000)
	}

	method acelerar(_velocidad) {
		velocidad = (velocidad + _velocidad).min(300000)
	}
	
	// Hacer que todas las naves se puedan preparar para viajar. 
	// Esto hace que aumenten su velocidad 15.000 kms/seg 
	//(teniendo la restricción de la velocidad máxima posible de 300.000kms/s). 

	method prepararParaViajar() {
		self.acelerar(15000)
	}

  //Hacer que una nave se encuentre con un enemigo. Esto les hace recibir una amenaza, sufriendo los efectos particulares de cada nave, y luego se propulsan para intentar escapar
	method encontrarEnemigo() {
		self.recibirAmenaza()
		self.propulsar()
	}
	
	method recibirAmenaza() 
	
}


class NaveDeCarga inherits Nave {

	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}
}

class NaveDeCargaRadiactiva inherits NaveDeCarga {
	
	//Aparecen un nuevo tipo de nave, las de carga de residuos radiactivos.
	// Estas son como cualquier nave de carga común, 
	// solo que pueden sellarse al vacío para evitar desparramar residuos radioactivos 
	// por todo el espacio. Por esto mismo, al recibir una amenaza no deben liberar 
	// su carga, sino que frenan (reduciendo su velocidad a 0) dispuestos a entregar la nave.
	var property sellada = false
	
	override method recibirAmenaza() {
		self.sellar()
		velocidad = 0
	}
	
	method sellar() {
		sellada = true
	}
	
	override method prepararParaViajar() {
		//Además de eso, ====>super!!
	    //las naves que cargan residuos radiactivos se cierran al vacío.
		super()
		self.sellar()    		
	}
}

class NaveDePasajeros inherits Nave {

	var property alarma = false
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}

class NaveDeCombate inherits Nave {

	var property modo = reposo
	const property mensajesEmitidos = []

	
	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}
	
	override method prepararParaViajar() {
		//Además de eso, ====>super!!
	    //y las de combate, si se encuentran en modo ataque emiten el mensaje "Volviendo a la base",
	    // mientras que si están en reposo emiten el mensaje "Saliendo en misión" y se ponen en modo ataque.
		super()
		modo.prepararParaViajar(self)
	}

}

object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}
	
	method prepararParaViajar(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}

}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}
	
	method prepararParaViajar(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}

}

