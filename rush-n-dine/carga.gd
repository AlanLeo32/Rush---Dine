extends Node2D

func _ready():
	cargar_datos_del_juego()

func cargar_datos_del_juego() -> void:
	while not Globales.estado_de_carga:
		await get_tree().create_timer(0.1).timeout

	call_deferred("cambiar_escena")  # <- cambio seguro

func cambiar_escena():
	get_tree().change_scene_to_file("res://menu_principal.tscn")
