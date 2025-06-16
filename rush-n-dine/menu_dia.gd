extends Node2D

var cantidad_acciones := [2,2,3,3,4,4,4]
var costo_apertura_por_mesas := [0,50,100, 150,200, 250,300]

func _ready():
	if not DiaData.dia_iniciado:
		DiaData.dia_iniciado=true
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	elif DiaData.acciones_disponibles ==0:
		$TextureRect/BotonPesca.visible=false
		$TextureRect/BotonCosecha.visible=false
		$TextureRect/BotonTienda.visible=false
		$TextureRect/BotonRuleta.visible=false
		$TextureRect/PanelAdvertencia.visible=true
		$TextureRect/PanelAdvertencia/BotonNoAbrir/Label2.text+= str(costo_apertura_por_mesas[Globales.mesas-1])


func _on_boton_tienda_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego

func _on_boton_ruleta_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego

func _on_boton_cosecha_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego

func _on_boton_pesca_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego

func _on_boton_abrir_pressed() -> void:
	DiaData.dia_iniciado=false
	Globales.guardar_estado()
	get_tree().change_scene_to_file("res://noche.tscn")

func _on_boton_no_abrir_pressed() -> void:
	Globales.dinero-=costo_apertura_por_mesas[Globales.mesas-1]
	if Globales.dinero>=0:
		Globales.guardar_estado()
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
		$TextureRect/BotonPesca.visible=true
		$TextureRect/BotonCosecha.visible=true
		$TextureRect/BotonTienda.visible=true
		$TextureRect/BotonRuleta.visible=true
		$TextureRect/PanelAdvertencia.visible=false
	else:
		$TextureRect/PanelAdvertencia2.show()


func _on_boton_confirma_add_pressed() -> void:
	
	#logica para mostrar el anuncio
	
	Globales.dinero=0
	Globales.guardar_estado()
	DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	$TextureRect/BotonPesca.visible=true
	$TextureRect/BotonCosecha.visible=true
	$TextureRect/BotonTienda.visible=true
	$TextureRect/BotonRuleta.visible=true
	$TextureRect/PanelAdvertencia.visible=false
	$TextureRect/PanelAdvertencia2.visible=false
