extends Node2D

func _ready():
	var fondo = $Fondo  # Asegurate que el nodo se llame así

	if Globales.dia:
		fondo.texture = load("res://Fondos/FondoDia.png")
	else:
		fondo.texture = load("res://Fondos/FondoNoche.png")
	


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://noche.tscn")


func _on_boton_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_configuracion.tscn")


func _on_boton_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_creditos.tscn")
