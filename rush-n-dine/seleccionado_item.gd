extends Button

signal boton_resta(receta_id)

var receta_id

func set_data(id, receta_data, cantidad_disponible, cantidad_seleccionada):
	receta_id = id

	# Imagen de la receta
	$CanvasLayer/ImagenSeleccion.texture = receta_data["imagen"]

	# Nombre
	$CanvasLayer/Nombre.text = receta_data["nombre"]

	# Cantidad en NocheData
	$CanvasLayer/ValorDisp.text = str(cantidad_disponible)

	# Cantidad en seleccion_local
	$CanvasLayer/ValorAdd.text = str(cantidad_seleccionada)

func _pressed():
	# Si se toca cualquier parte del botón, dispara la señal
	emit_signal("boton_resta", receta_id)
