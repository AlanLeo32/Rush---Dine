extends Panel

func set_data(recurso_data, cantidad_disponible, cantidad_usada):
	# Imagen del recurso
	$ImagenRecurso.texture = recurso_data["imagen"]

	# Cantidad disponible
	$ValorDisp.text = str(cantidad_disponible)
	# Cantidad utilizada en la selección
	$ValorCosto.text = str(cantidad_usada)
