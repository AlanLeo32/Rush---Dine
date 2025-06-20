extends Node2D

var items_tienda := {
	"sillas": {
		"Mesa": {
			"precio": [60,125,175,225,300],	#DEFINIR EL PRECIO DE VENTA A CADA NIVEL
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"imagen": preload("res://Sprites/SpriteMesa.png"),
			}
		},
		
	},
	
	
	"recetas": {	#tipo
		"Rabas": { #clave
			"precio": 40,
			"nivel_requerido": 2,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Rabas",
				"imagen": preload("res://Sprites/Comidas/platoRabas.png"),
				"imagenquemado":preload("res://Sprites/Comidas/platoRabasQuemadas.png"),
				"precio": 25,
				"popularidad": 2.5,
				"recursos_requeridos": {"pescado": 2,},
				"minijuegos": [
					"res://minigames/cooking/SkillCheck.tscn"
				],
				"coccion": 2
			}
		},
		"Bacalao": { #clave
			"precio": 60,
			"nivel_requerido": 3,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Bacalao",
				"imagen": preload("res://Sprites/Comidas/bacalaoConPapa.png"),
				"imagenquemado":preload("res://Sprites/Comidas/bacalaoQuemado.png"),
				"precio": 30,
				"popularidad": 3.5,
				"recursos_requeridos": {"pescado":2,},
				"minijuegos": [
					"res://minigames/cooking/SkillCheck.tscn",
					"res://minigames/slicing/main.tscn",
				],
				"coccion": 2
			}
		},
		"Pescado y ensalada": { #clave
			"precio": 80,
			"nivel_requerido": 4,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Pescado y ensalada",
				"imagen": preload("res://Sprites/Comidas/PescadoConEnsalda.png"),
				"imagenquemado":preload("res://Sprites/Comidas/PescadoConEnsaldaquemado.png"),
				"precio": 45,
				"popularidad": 5,
				"recursos_requeridos": {"verdura":3,},
				"minijuegos": [
					"res://minigames/slicing/main.tscn",
					"res://minigames/ordenar/main.tscn",
				],
				"ubi_ing": {
					"lechuga": Vector2(292.1, 174.9),
					"pescado": Vector2(347.9, 340.6),
					"tomate": Vector2(322.1, 562),
					"pepino1": Vector2(693.6, 533.4),
					"pepino2": Vector2(600.7, 600.6),
					"pepino3": Vector2(493.6, 637.7)
				},
			}
		},
		"Hamburguesa": { #clave
			"precio": 100,
			"nivel_requerido": 5,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Hamburguesa",
				"imagen": preload("res://Sprites/Comidas/hamburguesaConEnsalada.png"),
				"imagenquemado":preload("res://Sprites/Comidas/hamburguesaQuemada.png"),
				"precio": 50,
				"popularidad": 7,
				"recursos_requeridos": {"pescado":3,},
				"minijuegos": [
					"res://minigames/cooking/SkillCheck.tscn",
					"res://minigames/slicing/main.tscn",
				],
				"coccion": 2
			}
		},
		"Sushi": { #clave
			"precio": 150,
			"nivel_requerido": 6,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Sushi",
				"imagen": preload("res://Sprites/Comidas/sushiBueno.png"),
				"imagenquemado":preload("res://Sprites/Comidas/sushiMalo.png"),
				"precio": 60,
				"popularidad": 8,
				"recursos_requeridos": {"verdura":4,},
				"minijuegos": [
					"res://minigames/cooking/SkillCheck.tscn",
					"res://minigames/slicing/main.tscn",
					
				],
				"coccion": 2
			}
		},
		"Mariscos": { #clave
			"precio": 200,
			"nivel_requerido": 7,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Mariscos",
				"imagen": preload("res://Sprites/Comidas/MariscosBueno.png"),
				"imagenquemado":preload("res://Sprites/Comidas/MariscosMalo.png"),
				"precio": 85,
				"popularidad": 10,
				"recursos_requeridos": {"pescado":5},
				"minijuegos": [
					"res://minigames/cooking/SkillCheck.tscn",
					"res://minigames/slicing/main.tscn",
					"res://minigames/ordenar/main.tscn",
				],
				"ubi_ing": {
					"lechuga": Vector2(292.1, 174.9),
					"pescado": Vector2(347.9, 340.6),
					"tomate": Vector2(322.1, 562),
					"pepino1": Vector2(693.6, 533.4),
					"pepino2": Vector2(600.7, 600.6),
					"pepino3": Vector2(493.6, 637.7)
				},
				"coccion": 2
			}
		},
	},
	"recursos": { 	#tipo
		"pescado": {
			"precio": [7,12,12,20,20,24,24], #DEFINIR EL PRECIO DE VENTA A CADA NIVEL
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "pescado",
				"cantidad": [1,2,2,3,3,4,4],	#DEFINIR LA CANTIDAD DE RECURSOS A ENTREGAR EN CADA NIVEL 
				"imagen": preload("res://Sprites/Pescado.png"),
			}
		},
		"verdura": {
			"precio": [6,10,10,15,15,20,20], #DEFINIR EL PRECIO DE VENTA A CADA NIVEL
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "verdura",
				"cantidad": [1,2,2,3,3,4,4],	#DEFINIR LA CANTIDAD DE RECURSOS A ENTREGAR EN CADA NIVEL 
				"imagen": preload("res://Sprites/Verduras.png"),
			}
		}
	}
}

@onready var contenedor_tienda = $TextureRect/Panel/Panel/ScrollContainer/GridContainer
@onready var BotonTienda = preload("res://ElementoTienda.tscn")

func _ready():
	generar_items()
	$TextureRect/Panel/Panel/Saldo.text= "Saldo: $"+str(Globales.dinero)
	if Globales.mesas==1 or DiaData.bajarnivel:
		$TextureRect/Panel/Panel/BajarNivel.visible=false

func actualizar():
	
	$TextureRect/Panel/Panel/Saldo.text= "Saldo: $"+str(Globales.dinero)
	generar_items()


func generar_items():
	for child in $TextureRect/Panel/Panel/ScrollContainer/GridContainer.get_children():
		child.queue_free()
	for tipo in items_tienda:
		for clave in items_tienda[tipo]:
			var datos = items_tienda[tipo][clave]
			# Filtrado por nivel
			if Globales.mesas >= datos.nivel_requerido and not(tipo=="sillas" and (DiaData.mejoranivel or Globales.mesas>=7)):
				if (tipo=="recetas"):
					if(not Globales.recetas_desbloqueadas.has(clave)):
						var boton = BotonTienda.instantiate()
						boton.set_data(tipo,clave, datos)
						contenedor_tienda.add_child(boton)
				else:
					var boton = BotonTienda.instantiate()
					boton.set_data(tipo,clave, datos)
					contenedor_tienda.add_child(boton)

func _on_cancelar_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuDia.tscn")


func fondos_insuficientes():
	$TextureRect/Panel/ErrorPopup.show()


func _on_bajar_nivel_pressed() -> void:
	if Globales.mesas>1:
		DiaData.bajarnivel=true
		$TextureRect/Panel/Panel/BajarNivel.visible=false
