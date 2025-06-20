extends Node2D

var items_tienda := {
	"sillas": {
		"Mesa": {
			"precio": [2,3,4,5,6,7],	#DEFINIR EL PRECIO DE VENTA A CADA NIVEL
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"imagen": preload("res://Sprites/SpriteMesa.png"),
			}
		},
		
	},
	
	"recetas": {	#tipo
		"hamburguesa": { #clave
			"precio": 100,
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "hamburguesa",
				"imagen": preload("res://Sprites/ComidaPrueba.png"),
				"imagenquemado":preload("res://Sprites/ComidaPrueba.png"),
				"precio": 15,
				"popularidad": 8,
				"recursos_requeridos": {"pescado": 1,},
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
				},
				"coccion": 2
			}
		}
	},
	"recursos": { 	#tipo
		"pescado999": {
			"precio": [1,2,3,4,5,6,7], #DEFINIR EL PRECIO DE VENTA A CADA NIVEL
			"nivel_requerido": 1,
			"datos": {  # estructura que se agrega a Globales.recetas_desbloqueadas
				"nombre": "Pescado999",
				"cantidad": [1,2,3,4,5,6,7],	#DEFINIR LA CANTIDAD DE RECURSOS A ENTREGAR EN CADA NIVEL 
				"imagen": preload("res://Sprites/RecursoPrueba.jpg"),
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
