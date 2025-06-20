extends Node

var dificultad = 0.9 + Globales.mesas*0.1 # Valores entre 1 y 1.6
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
		var sumaPuntaje = resultado_minijuego["puntaje"]
		resultado_minijuego["puntaje"] = int(sumaPuntaje/minijuegos.size())
		secuenciaFinal()
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
			if noche.has_node("CanvasLayer2"):
				noche.get_node("CanvasLayer2/Panel").visible = false
				noche.get_node("CanvasLayer2/Panel2").visible = false
				for cliente in get_tree().get_nodes_in_group("clientes"):
					if is_instance_valid(cliente) and cliente.has_method("hide"):
						cliente.hide() 
			# Bloquear movimiento cocinero
			noche.set("bloquear_cocinero", true)
			noche.get_node("TimerClientes").set_paused(true)
		else:
			print("No se encontró el nodo ContenedorMinijuegos")

func secuenciaFinal():
	#posible mini pantalla con puntuacion
	cambioNoche()

func cambioNoche():
	var noche = get_tree().get_root().get_node("Noche")
	if noche:
		# Volver a la cámara del jugador
		var camara_jugador = noche.get_node("CharacterBodyCocinero2D/Camera2D")
		if camara_jugador:
			camara_jugador.make_current()
		# Mostrar el botón de interactuar
		if noche.has_node("CanvasLayer/Interactuar"):
			noche.get_node("CanvasLayer/Interactuar").visible = true
		if noche.has_node("CanvasLayer2"):
			noche.get_node("CanvasLayer2/Panel").visible = true
			noche.get_node("CanvasLayer2/Panel2").visible = true
			for cliente in get_tree().get_nodes_in_group("clientes"):
				if is_instance_valid(cliente) and cliente.has_method("show"):
					cliente.show()
		noche.procesar_resultado_minijuego(ManejoMinijuegos.resultado_minijuego)
		noche.set("bloquear_cocinero", false)
		noche.get_node("TimerClientes").set_paused(false)

func resetear():
	cant_colectables = 0
	receta_actual = null
	pos_minijuego_actual = 0

	resultado_minijuego = {
		"puntaje": 0,
		"receta": null
	}

func actualizar_recursos(recurso, cantidad):
	print(Globales.recursos_disponibles)
	if recurso in Globales.recursos_disponibles:
		Globales.recursos_disponibles[recurso]["cantidad"] += cantidad
		print("Recurso actualizado: ", recurso, " Cantidad: ", Globales.recursos_disponibles[recurso]["cantidad"])
	else:
		print("Recurso no encontrado: ", recurso)

func volver_a_dia():
	get_tree().change_scene_to_file("res://MenuDia.tscn")

func minijuego_snake():
	get_tree().change_scene_to_file("res://minigames/snake/main.tscn")
	
func minijuego_ruleta():
	get_tree().change_scene_to_file("res://minigames/ruleta/RuletaScene.tscn")
	
func abre_tienda():
	get_tree().change_scene_to_file("res://Tienda.tscn")

func minijuego_recolectar():
	get_tree().change_scene_to_file("res://minigames/collect/recoleccion.tscn")

func minijuego_pescado():
	get_tree().change_scene_to_file("res://minigames/pesca/juegopesca.tscn")

func minijuego_verdura_random():
	if randi() % 2 == 0:
		minijuego_snake()
	else:
		minijuego_recolectar()
