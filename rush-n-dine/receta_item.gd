extends Control

signal receta_seleccionada(receta_id)

var receta_id
var start_pos := Vector2.ZERO
var moved := false
var threshold := 10

func set_data(id, receta_data):
	receta_id = id

	$CanvasLayer/ImagenReceta.texture = receta_data["imagen"]
	$CanvasLayer/Nombre.text = receta_data["nombre"]
	$CanvasLayer/Precio.text = str(receta_data["precio"])
	$CanvasLayer/Popularidad.text = str(receta_data["popularidad"])

	for recurso_id in receta_data["recursos_requeridos"]:
		var cantidad = receta_data["recursos_requeridos"][recurso_id]
		var recurso = Globales.recursos_disponibles[recurso_id]
		$CanvasLayer/ImagenRecurso.texture = recurso["imagen"]
		$CanvasLayer/Recursos.text = "x" + str(cantidad)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pos = event.position
			moved = false
		else:
			if not moved:
				emit_signal("receta_seleccionada", receta_id)
	elif event is InputEventMouseMotion:
		if (event.position - start_pos).length() > threshold:
			moved = true
