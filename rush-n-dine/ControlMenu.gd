extends Node2D

func _ready():
	var fondo = $Fondo  # Asegurate que el nodo se llame así

	if Globales.dia:
		fondo.texture = load("res://Fondos/FondoDia.png")
	else:
		fondo.texture = load("res://Fondos/FondoNoche.png")
	


func _on_boton_jugar_pressed() -> void:
	if Globales.dia:
		get_tree().change_scene_to_file("res://MenuDia.tscn")
	else:
		get_tree().change_scene_to_file("res://noche.tscn")


func _on_boton_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://Ayuda.tscn")


func _on_boton_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_creditos.tscn")


func _on_texture_rect_pressed() -> void:
	Globales.cargar_recetas_iniciales()
	Globales.cargar_recursos_iniciales()
	Globales.dinero = 0
	Globales.reputacion_categoria = "D"
	Globales.reputacion_progreso = 0 #cuando llega a 100 pasa a siguiente categoria y este vuelve 0
	Globales.dia= true
	Globales.mesas= 1
	DiaData.dia_iniciado=false
	$Fondo.texture = load("res://Fondos/FondoDia.png")
	var path := "user://save_game.json"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)


func _on_boton_reinicio_2_pressed() -> void:
	if Globales.sonido: 
		$CanvasLayer/BotonReinicio2.texture_normal = preload("res://Sprites/Audio-mute.png")

		Globales.sonido=false
	else:
		$CanvasLayer/BotonReinicio2.texture_normal = preload("res://Sprites/Sonido.png")
		Globales.sonido=true
