extends Button

signal seleccionado(id)

var disp_id

func set_data(id, receta_data,cantidad):
	disp_id = id

	# Imagen principal
	$CanvasLayer/ImagenReceta.texture = receta_data["imagen"]

	# Nombre
	$CanvasLayer/Nombre.text = receta_data["nombre"]

	# Precio
	$CanvasLayer/Precio.text = str(receta_data["precio"])

	# Popularidad
	$CanvasLayer/Popularidad.text = str(receta_data["popularidad"])

	$CanvasLayer/Cantidad.text = str(cantidad)

func _pressed():
	emit_signal("seleccionado", disp_id)
