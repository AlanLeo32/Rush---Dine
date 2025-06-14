extends Node

var cant_colectables: int = 0
var receta_actual = null
var resultado_minijuego = {
	"puntaje" = 0,
	"receta" = null
}
var pos_minijuego_actual: int = 0

# logica_siguiente_minijuego()
# Esta funcion estandariza la logica de pasar al siguiente minijuego 
# luego de que termina cada minijuego, para que no dependa del minijuego
# en si, sino de los minijuegos que tiene cada receta.
# Una vez que se terminan los minijuegos de esa receta, se vuelve a la noche.

func logica_siguiente_minijuego():
	if receta_actual == null:
		print("No hay receta actual, no se puede avanzar al siguiente minijuego.")
		return
	var minijuegos = receta_actual["minijuegos"]
	if pos_minijuego_actual >= minijuegos.size():
		print("No hay otro minijuego a continuacion, volviendo al restaurante...")
		var noche = get_tree().get_root().get_node("Noche")
		if noche:
			# Volver a la cámara del jugador
			var camara_jugador = noche.get_node("CharacterBodyCocinero2D/Camera2D")
			if camara_jugador:
				camara_jugador.make_current()
			# Mostrar el botón de interactuar
			if noche.has_node("CanvasLayer/Interactuar"):
				noche.get_node("CanvasLayer/Interactuar").visible = true
			noche.procesar_resultado_minijuego(ManejoMinijuegos.resultado_minijuego)
			ManejoMinijuegos.resultado_minijuego = {}
			noche.set("bloquear_cocinero", false)
		pos_minijuego_actual = 0
	else:
		print("Minijuego actual: ", minijuegos[pos_minijuego_actual])
		var ruta_escena_minijuego = minijuegos[pos_minijuego_actual]
		pos_minijuego_actual += 1
		var noche = get_tree().get_root().get_node("Noche")
		if noche and noche.has_node("ContenedorMinijuegos"):
			var anchor = noche.get_node("ContenedorMinijuegos")
			# Limpiar minijuegos anteriores
			for child in anchor.get_children():
				child.queue_free()
			# Instanciar minijuego
			var minijuego_scene = load(ruta_escena_minijuego)
			var minijuego_instance = minijuego_scene.instantiate()
			minijuego_instance.position = Vector2.ZERO 
			anchor.add_child(minijuego_instance)
			# Activar cámara del minijuego
			var camara_minijuego = minijuego_instance.get_node_or_null("Camera2D")
			if camara_minijuego:
				camara_minijuego.make_current()
			# Ocultar el botón de interactuar
			if noche.has_node("CanvasLayer/Interactuar"):
				noche.get_node("CanvasLayer/Interactuar").visible = false
			# Bloquear movimiento cocinero
			noche.set("bloquear_cocinero", true)
		else:
			print("No se encontró el nodo ContenedorMinijuegos")
