extends Area2D

func interactuar():
	var root = get_tree().current_scene
	var menu = root.get_node("CanvasLayer2/MenuSeleccionRecurso")
	menu.mostrar()
