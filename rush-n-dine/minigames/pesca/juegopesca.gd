extends Node2D
var my_button: Button
var fishing_game_scene := preload("res://minigames/pesca/fisihing_game.tscn")
func _ready():
	my_button = $JugarButton

func _on_jugar_button_pressed() -> void:
	_show_fishing_game()

func _show_fishing_game():
	var fishing_game = fishing_game_scene.instantiate()
	get_tree().current_scene.add_child(fishing_game)
	var timer = fishing_game.get_node("FishingGame/PanelContainer/MarginContainer/VBoxContainer/TimeoutTimer")  #" Asegúrate de que la ruta es correcta
	timer.start()
