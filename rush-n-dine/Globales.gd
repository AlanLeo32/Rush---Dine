extends Node

# Variables globales del jugador
var nivel = 0
var dinero = 0
var reputacion = 0
var dia= true
var recetas_desbloqueadas : Dictionary = {}
var recursos_disponibles : Dictionary = {}
var cant_colectables: int = 0
var receta_actual = null
var resultado_minijuego = {
	"puntaje" = 0,
	"receta" = null
}
var pos_minijuego_actual: int = 0

	
func _ready():
	cargar_recetas_iniciales()
	cargar_recursos_iniciales()

func cargar_recetas_iniciales():
	recetas_desbloqueadas = {
		"pescado_asado1": {
			"nombre": "Pescado Asado1",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn",
				"res://minigames/ordenar/main.tscn"
			],
			"ubi_ing": {
				"lechuga": Vector2(292.1, 174.9),
				"pescado": Vector2(347.9, 340.6),
				"tomate": Vector2(322.1, 562),
				"pepino1": Vector2(693.6, 533.4),
				"pepino2": Vector2(600.7, 600.6),
				"pepino3": Vector2(493.6, 637.7)
			}
		},
		"pescado_asado2": {
			"nombre": "Pescado Asado2",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn",
				"res://minigames/cooking/SkillCheck.tscn"
			],
			# El punto de coccion es necesario para
			# el minijuego del horno (skillcheck)
			"coccion": 2
		},
				"pescado_asado3": {
			"nombre": "Pescado Asado3",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn"
			]
		},
				"pescado_asado4": {
			"nombre": "Pescado Asado4",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn"
			]
		},
				"pescado_asado5": {
			"nombre": "Pescado Asado5",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn"
			]
		},
				"pescado_asado6": {
			"nombre": "Pescado Asado6",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn"
			]
		},
				"pescado_asado7": {
			"nombre": "Pescado Asado7",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn"
			]
		}
	}
	
func cargar_recursos_iniciales():
	recursos_disponibles = {
		"pescado": {"nombre": "Pescado", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado2": {"nombre": "Pescado", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado3": {"nombre": "Pescado3", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado4": {"nombre": "Pescado4", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
	}


# logica_siguiente_minijuego()
# Esta funcion estandariza la logica de pasar al siguiente minijuego 
# luego de que termina cada minijuego, para que no dependa del minijuego
# en si, sino de los minijuegos que tiene cada receta.
# Una vez que se terminan los minijuegos de esa receta, se vuelve a la noche.

func logica_siguiente_minijuego():
	var minijuegos = receta_actual["minijuegos"]
	
	if pos_minijuego_actual >= minijuegos.size():
		print("No hay otro minijuego a continuacion, volviendo al restaurante...")
		# Al terminar el minijuego
		var noche = get_tree().get_root().get_node("Noche")
		if noche:
			noche.procesar_resultado_minijuego(Globales.resultado_minijuego)
			Globales.resultado_minijuego = {}
		pos_minijuego_actual = 0
	else:
		print("Minijuego actual: ", minijuegos[pos_minijuego_actual])
		var ruta_escena_minijuego = minijuegos[pos_minijuego_actual]
		pos_minijuego_actual += 1

		var noche = get_tree().get_root().get_node("Noche")
		if noche and noche.has_node("OverlayMinijuegos/ContenedorMinijuego"):
			var overlay = noche.get_node("OverlayMinijuegos")
			var contenedor = overlay.get_node("ContenedorMinijuego")
			var fondo = overlay.get_node("FondoOscuro")
			# Limpiar overlay anterior
			for child in contenedor.get_children():
				child.queue_free()
			# Instanciar minijuego
			var minijuego_scene = load(ruta_escena_minijuego)
			var minijuego_instance = minijuego_scene.instantiate()
			contenedor.add_child(minijuego_instance)
			# Mostrar overlay
			fondo.visible = true
			contenedor.visible = true
			# Bloquear movimiento cocinero
			noche.set("bloquear_cocinero", true)
		else:
			print("No se encontró el overlay para minijuegos")
