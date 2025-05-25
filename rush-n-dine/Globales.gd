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
var resultado_minijuego = {}

	
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
				"res://minigames/slicing/main.tscn"
			]
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
				"res://minigames/slicing/main.tscn"
			]
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
			}
		},
				"pescado_asado5": {
			"nombre": "Pescado Asado5",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			}
		},
				"pescado_asado6": {
			"nombre": "Pescado Asado6",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			}
		},
				"pescado_asado7": {
			"nombre": "Pescado Asado7",
			"imagen": preload("res://Sprites/ComidaPrueba.png"),
			"precio": 15,
			"popularidad": 8,
			"recursos_requeridos": {
				"pescado": 1,
			}
		}
	}
	
func cargar_recursos_iniciales():
	recursos_disponibles = {
		"pescado": {"nombre": "Pescado", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado2": {"nombre": "Pescado", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado3": {"nombre": "Pescado3", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
		"pescado4": {"nombre": "Pescado4", "cantidad": 3, "imagen": preload("res://Sprites/RecursoPrueba.jpg")},
	}
