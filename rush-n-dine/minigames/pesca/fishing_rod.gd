extends AnimatedSprite2D

var fishing_game_scene := preload("res://fisihing_game.tscn")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		play("pescar")
		_show_fishing_game()

func _show_fishing_game():
	var fishing_game = fishing_game_scene.instantiate()
	get_tree().current_scene.add_child(fishing_game)
	var timer = fishing_game.get_node("FishingGame/PanelContainer/MarginContainer/VBoxContainer/TimeoutTimer")  #" Asegúrate de que la ruta es correcta
	timer.start()

func _ready() -> void:
	play("cana_quieta")
