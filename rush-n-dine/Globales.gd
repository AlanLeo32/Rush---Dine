extends Node

var estado_de_carga := false
var sonido=true

# Variables globales del jugador
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
		"Ensalada verde": {
			"nombre": "Ensalada verde",
			"imagen": preload("res://Sprites/Comidas/SpriteEnsalada.png"),
			"imagenquemado":preload("res://Sprites/Comidas/ensaladaMala.png"),
			"precio": 12,
			"popularidad": 1,
			"recursos_requeridos": {
				"verdura": 1,
			},
			"minijuegos": [
				"res://minigames/slicing/main.tscn",
			],
		},
		" pescado a la plancha": {
			"nombre": " pescado a la plancha",
			"imagen": preload("res://Sprites/Comidas/SpritePescadoAsadoSolo.png"),
			"imagenquemado": preload("res://Sprites/Comidas/SpritePescadoQuemadoSolo.png"),
			"precio": 14,
			"popularidad": 1.5,
			"recursos_requeridos": {
				"pescado": 1,
			},
			"minijuegos": [
				"res://minigames/cooking/SkillCheck.tscn"
			],
			# El punto de coccion es necesario para
			# el minijuego del horno (skillcheck)
			"coccion": 2
		},
	}

func cargar_recursos_iniciales():
	recursos_disponibles = {
		"pescado": {"nombre": "Pescado", "cantidad": 0, "imagen": preload("res://Sprites/Pescado.png")},
		"verdura": {"nombre": "Verdura", "cantidad": 0, "imagen": preload("res://Sprites/Verduras.png")},
	}

func guardar_estado():
	var save_data := {
		"dinero": dinero,
		"reputacion_categoria": reputacion_categoria,
		"reputacion_progreso": reputacion_progreso,
		"dia": dia,
		"mesas": mesas,
		"recetas_desbloqueadas": {},
		"recursos_disponibles": {}
	}
	
	for nombre in recetas_desbloqueadas.keys():
		var r = recetas_desbloqueadas[nombre]
		save_data["recetas_desbloqueadas"][nombre] = {
			"nombre": r["nombre"],
			"imagen_path": r["imagen"].resource_path,
			"imagenquemado_path": r["imagenquemado"].resource_path,
			"precio": r["precio"],
			"popularidad": r["popularidad"],
			"recursos_requeridos": r["recursos_requeridos"],
			"minijuegos": r["minijuegos"],
			"ubi_ing": r.get("ubi_ing", null),
			"coccion": r.get("coccion", null)
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

func parsear_diccionario_de_vector2(dic: Dictionary) -> Dictionary:
	var nuevo_dic := {}
	for k in dic.keys():
		var s = dic[k]
		if typeof(s) == TYPE_STRING and s.begins_with("(") and s.ends_with(")"):
			s = s.substr(1, s.length() - 2)  # elimina "(" y ")"
			var partes = s.split(",")
			if partes.size() == 2:
				var x = partes[0].to_float()
				var y = partes[1].to_float()
				nuevo_dic[k] = Vector2(x, y)
			else:
				nuevo_dic[k] = s
		else:
			nuevo_dic[k] = s
	return nuevo_dic



func cargar_estado():
	if FileAccess.file_exists("user://save_game.json"):
		var file := FileAccess.open("user://save_game.json", FileAccess.READ)
		var contenido := file.get_as_text()
		file.close()

		var data = JSON.parse_string(contenido)
		if typeof(data) != TYPE_DICTIONARY:
			print("Error al cargar archivo de guardado.")
			return

		dinero = data.get("dinero", 0)
		reputacion_categoria = data.get("reputacion_categoria", "D")
		reputacion_progreso = data.get("reputacion_progreso", 0)
		dia = data.get("dia", true)
		mesas = data.get("mesas", 2)

		recetas_desbloqueadas.clear()
		for nombre in data["recetas_desbloqueadas"]:
			var r = data["recetas_desbloqueadas"][nombre]
			var ubi_raw = r.get("ubi_ing", null)
			recetas_desbloqueadas[nombre] = {
				"nombre": r["nombre"],
				"imagen": load(r["imagen_path"]),
				"imagenquemado": load(r["imagenquemado_path"]),
				"precio": r["precio"],
				"popularidad": r["popularidad"],
				"recursos_requeridos": r["recursos_requeridos"],
				"minijuegos": r["minijuegos"],
				"ubi_ing": parsear_diccionario_de_vector2(ubi_raw) if ubi_raw != null else null,
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
