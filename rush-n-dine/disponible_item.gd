extends Control

signal seleccionado(id)

var disp_id
var start_pos := Vector2.ZERO
var moved := false
var threshold := 10

func set_data(id, receta_data, cantidad):
	disp_id = id
	$CanvasLayer/ImagenReceta.texture = receta_data["imagen"]
	$CanvasLayer/Nombre.text = receta_data["nombre"]
	if id!="agua":
		$CanvasLayer/Precio.text = str(receta_data["precio"])
		$CanvasLayer/Popularidad.text = str(receta_data["popularidad"])
		$CanvasLayer/Cantidad.text = str(cantidad)
	else:
		$CanvasLayer/LbCantidad.visible = false
		$CanvasLayer/ImagenPrecio.visible = false
		$CanvasLayer/ImagenPopularidad.visible = false

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pos = event.position
			moved = false
		else:
			if not moved:
				emit_signal("seleccionado", disp_id)
	elif event is InputEventMouseMotion:
		if (event.position - start_pos).length() > threshold:
			moved = true
