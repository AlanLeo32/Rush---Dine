extends Node2D

var fishing_game_scene := preload("res://minigames/pesca/fisihing_game.tscn")


func _on_jugar_button_pressed() -> void:
	var fishing_game = $fishing_game
	if not fishing_game.visible:
		fishing_game.visible = true  # Mostrar el minijuego

		var timer = fishing_game.get_node("FishingGame/PanelContainer/MarginContainer/VBoxContainer/TimeoutTimer")
		timer.start()
		$JugarButton.visible=false
