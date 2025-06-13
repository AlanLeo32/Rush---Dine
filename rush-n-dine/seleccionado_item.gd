extends Control

signal boton_resta(receta_id)

var receta_id
var start_pos := Vector2.ZERO
var moved := false
var threshold := 10

func set_data(id, receta_data, cantidad_disponible, cantidad_seleccionada):
	receta_id = id

	$CanvasLayer/ImagenSeleccion.texture = receta_data["imagen"]
	$CanvasLayer/Nombre.text = receta_data["nombre"]
	$CanvasLayer/ValorDisp.text = str(cantidad_disponible)
	$CanvasLayer/ValorAdd.text = str(cantidad_seleccionada)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pos = event.position
			moved = false
		else:
			if not moved:
				emit_signal("boton_resta", receta_id)
	elif event is InputEventMouseMotion:
		if (event.position - start_pos).length() > threshold:
			moved = true
