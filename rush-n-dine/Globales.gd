extends Node

var estado_de_carga := false

# Variables globales del jugador
var nivel = 0
var dinero = 0

var reputacion_categoria = "D"
var reputacion_progreso = 0 #cuando llega a 100 pasa a siguiente categoria y este vuelve 0
var dia= true
var recetas_desbloqueadas : Dictionary = {}
var recursos_disponibles : Dictionary = {}
var mesas:= 1

	
func _ready():
	if FileAccess.file_exists("user://save_game.json"):
		cargar_estado()
	else:
		cargar_recetas_iniciales()
		cargar_recursos_iniciales()
	estado_de_carga = true



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

func guardar_estado():
	var save_data := {
		"nivel": nivel,
		"dinero": dinero,
		"reputacion_categoria": reputacion_categoria,
		"reputacion_progreso": reputacion_progreso,
		"dia": dia,
		"mesas": mesas,
		"recetas_desbloqueadas": {},  # serializadas sin imágenes
		"recursos_disponibles": {}    # idem
	}
	
	for nombre in recetas_desbloqueadas.keys():
		var r = recetas_desbloqueadas[nombre]
		save_data["recetas_desbloqueadas"][nombre] = {
			"nombre": r["nombre"],
			"imagen_path": r["imagen"].resource_path,
			"precio": r["precio"],
			"popularidad": r["popularidad"],
			"recursos_requeridos": r["recursos_requeridos"],
			"minijuegos": r["minijuegos"],
			"ubi_ing": r.has("ubi_ing") if r.has("ubi_ing") else null,
			"coccion": r.has("coccion") if r.has("coccion") else null
		}

	for nombre in recursos_disponibles.keys():
		var rr = recursos_disponibles[nombre]
		save_data["recursos_disponibles"][nombre] = {
			"nombre": rr["nombre"],
			"cantidad": rr["cantidad"],
			"imagen_path": rr["imagen"].resource_path
		}
	var file := FileAccess.open("user://save_game.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	
func cargar_estado():
	if  FileAccess.file_exists("user://save_game.json"):
		var file := FileAccess.open("user://save_game.json", FileAccess.READ)
		var contenido := file.get_as_text()
		file.close()

		var data = JSON.parse_string(contenido)
		if typeof(data) != TYPE_DICTIONARY:
			print("Error al cargar archivo de guardado.")
			return

		nivel = data.get("nivel", 0)
		dinero = data.get("dinero", 0)
		reputacion_categoria = data.get("reputacion_categoria", "D")
		reputacion_progreso = data.get("reputacion_progreso", 0)
		dia = data.get("dia", true)
		mesas = data.get("mesas", 2)

		recetas_desbloqueadas.clear()
		for nombre in data["recetas_desbloqueadas"]:
			var r = data["recetas_desbloqueadas"][nombre]
			recetas_desbloqueadas[nombre] = {
				"nombre": r["nombre"],
				"imagen": load(r["imagen_path"]),
				"precio": r["precio"],
				"popularidad": r["popularidad"],
				"recursos_requeridos": r["recursos_requeridos"],
				"minijuegos": r["minijuegos"],
				"ubi_ing": r.get("ubi_ing", null),
				"coccion": r.get("coccion", null)
			}

		recursos_disponibles.clear()
		for nombre in data["recursos_disponibles"]:
			var rr = data["recursos_disponibles"][nombre]
			recursos_disponibles[nombre] = {
				"nombre": rr["nombre"],
				"cantidad": rr["cantidad"],
				"imagen": load(rr["imagen_path"])
			}
