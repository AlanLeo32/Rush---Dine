extends Node2D

var colectable_scene: PackedScene = load("res://minigames/collect/colectable.tscn")
var cant_colectables: int = 0

func _on_timer_colectable_spawn_timeout() -> void:
	var colectable = colectable_scene.instantiate()
	
	$Colectables.add_child(colectable)


func _process(delta):
	var tiempo_restante = int($TimerMinijuego.time_left)
	$CantidadLabel.text = "Cantidad: %d" % Globales.cant_colectables
	$TimeLeftLabel.text = "%d" % tiempo_restante


func _on_timer_minijuego_timeout() -> void:
	# Ejemplo: cambiar de escena
	#get_tree().change_scene_to_file("res://escenas/MenuPrincipal.tscn")

	# O si querés mostrar un mensaje final antes:
	# $GameOverLabel.visible = true
	set_process(false)  # detener la lógica del juego
