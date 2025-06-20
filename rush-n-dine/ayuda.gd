extends Node2D

var imagenes := []
var indice_actual := 0

func _ready() -> void:
	imagenes = [
		load("res://Fondos/Ayuda1.jpg"),
		load("res://Fondos/Ayuda2.jpg"),
		load("res://Fondos/Ayuda3.jpg"),
		load("res://Fondos/Ayuda4.jpg")
	]
	actualizar_imagen()

func actualizar_imagen():
	$TextureRect.texture = imagenes[indice_actual]

	# Ocultar "Atrás" si es el primero, "Siguiente" si es el último
	$TextureRect/Atras.visible = indice_actual > 0
	$TextureRect/Siguiente.visible = indice_actual < imagenes.size() - 1

func _on_siguiente_pressed() -> void:
	if indice_actual < imagenes.size() - 1:
		indice_actual += 1
		actualizar_imagen()

func _on_atras_pressed() -> void:
	if indice_actual > 0:
		indice_actual -= 1
		actualizar_imagen()

func _on_cancelar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
