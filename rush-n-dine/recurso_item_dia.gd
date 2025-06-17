extends Panel

func set_data(recurso_data, cantidad_disponible):
	# Imagen del recurso
	$ImagenRecurso.texture = recurso_data["imagen"]

	# Cantidad disponible
	$ValorDisp.text = str(cantidad_disponible)
