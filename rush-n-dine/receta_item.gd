extends Button

signal receta_seleccionada(receta_id)

var receta_id

func set_data(id, receta_data):
	receta_id = id

	# Imagen principal
	$CanvasLayer/ImagenReceta.texture = receta_data["imagen"]

	# Nombre
	$CanvasLayer/Nombre.text = receta_data["nombre"]

	# Precio
	$CanvasLayer/Precio.text = str(receta_data["precio"])

	# Popularidad
	$CanvasLayer/Popularidad.text = str(receta_data["popularidad"])

	# Recurso único (solo 1)
	for recurso_id in receta_data["recursos_requeridos"]:
		var cantidad = receta_data["recursos_requeridos"][recurso_id]
		var recurso = Globales.recursos_disponibles[recurso_id]
		$CanvasLayer/ImagenRecurso.texture = recurso["imagen"]
		$CanvasLayer/Recursos.text = "x" + str(cantidad)

func _pressed():
	emit_signal("receta_seleccionada", receta_id)
