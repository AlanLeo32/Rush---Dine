extends Area2D

func interactuar():
	var menu = get_tree().root.get_node("Noche/CanvasLayer2/MenuCocinar")
	menu.visible = true
	menu.actualizar()
