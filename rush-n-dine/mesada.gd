extends Area2D

func interactuar():
	var menu = get_node("/root/Noche/CanvasLayer2/MenuMesada")
	menu.actualizar()
	menu.visible = true
