extends Node2D


func _on_cancelar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
