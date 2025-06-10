extends Area2D

func interactuar():
	var root = get_tree().current_scene
	if root.name == "Dia":
		var popup = root.get_node("CanvasLayer2/PopupCartel")
		popup.dialog_text = "Aprovechá el día para conseguir recursos, durante la noche podrás cocinar"
		popup.popup_centered()
	else:
		var menu = root.get_node("Noche/CanvasLayer2/MenuCocinar")
		menu.visible = true
		menu.actualizar()
