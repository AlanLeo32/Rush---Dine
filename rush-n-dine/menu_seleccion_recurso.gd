extends Panel

func _ready():
	visible = false

func mostrar():
	visible = true

func ocultar():
	visible = false

func _on_button_pescar_pressed() -> void:
	ocultar()
	get_tree().change_scene_to_file("res://minigames/collect/recoleccion.tscn")


func _on_button_recolectar_pressed() -> void:
	ocultar()
	get_tree().change_scene_to_file("res://minigames/collect/recoleccion.tscn")
