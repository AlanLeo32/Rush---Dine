extends Node

# Variables globales del jugador
var nivel = 0
var dinero = 0

var reputacion_categoria = "S"
var reputacion_progreso = 50 #cuando llega a 100 pasa a siguiente categoria y este vuelve 0
var dia= true
var recetas_desbloqueadas : Dictionary = {}
var recursos_disponibles : Dictionary = {}
var mesas:= 2

	
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
