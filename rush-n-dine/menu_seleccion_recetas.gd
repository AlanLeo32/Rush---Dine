extends Control
var seleccion_local:= {} #clave=receta_id , valor= cantidad seleccionada

func _ready():
	cargar_recetas()
	cargar_seleccionados()
	cargar_recursos()

func cargar_recetas():
	for child in $Panel/ScrollRecetas/HBoxRecetas.get_children():
		child.queue_free()
	for receta in Globales.recetas_desbloqueadas:
		var receta_data = Globales.recetas_desbloqueadas[receta]
		var receta_item = preload("res://RecetaItem.tscn").instantiate()
		receta_item.set_data(receta, receta_data)
		receta_item.connect("receta_seleccionada", Callable(self, "_on_receta_seleccionada"))
		$Panel/ScrollRecetas/HBoxRecetas.add_child(receta_item)
		
func cargar_seleccionados():
	for child in $Panel/ScrollSeleccionados/HBoxSeleccionados.get_children():
		child.queue_free()
	var receta_ids = []
	receta_ids.append_array(NocheData.platos_seleccionables.keys())
	for id in seleccion_local.keys():
		if not receta_ids.has(id):
				receta_ids.append(id)
	for receta_id in receta_ids:
		var receta = Globales.recetas_desbloqueadas[receta_id]
		var cantidad_noche = 0
		var cantidad_local = 0
		if NocheData.platos_seleccionables.has(receta_id):
			cantidad_noche = NocheData.platos_seleccionables[receta_id]
		if seleccion_local.has(receta_id):
			cantidad_local = seleccion_local[receta_id]
		if cantidad_noche > 0 or cantidad_local > 0:
			var seleccionado_item = preload("res://SeleccionadoItem.tscn").instantiate()
			seleccionado_item.connect("boton_resta", Callable(self, "_on_boton_resta"))
			seleccionado_item.set_data(receta_id, receta, cantidad_noche, cantidad_local)
			$Panel/ScrollSeleccionados/HBoxSeleccionados.add_child(seleccionado_item)
		elif cantidad_noche == 0:
			NocheData.platos_seleccionables.erase(receta_id)

func cargar_recursos():
	for child in $Panel/ScrollRecursos/HBoxRecursos.get_children():
		child.queue_free()
	# Calcular costo total usado en seleccion_local
	var costo_total = {}
	for receta_id in seleccion_local.keys():
		var cantidad = seleccion_local[receta_id]
		var receta = Globales.recetas_desbloqueadas[receta_id]
		for recurso_id in receta["recursos_requeridos"].keys():
			var cantidad_por_plato = receta["recursos_requeridos"][recurso_id]
			if not costo_total.has(recurso_id):
				costo_total[recurso_id] = 0
			costo_total[recurso_id] += cantidad * cantidad_por_plato
	# Mostrar recursos
	for recurso_id in Globales.recursos_disponibles.keys():
		var recurso_data = Globales.recursos_disponibles[recurso_id]
		var cantidad_disponible = recurso_data["cantidad"]
		var cantidad_usada = costo_total.get(recurso_id, 0)
		var recurso_item = preload("res://RecursoItem.tscn").instantiate()
		recurso_item.set_data(recurso_data, cantidad_disponible, cantidad_usada)
		$Panel/ScrollRecursos/HBoxRecursos.add_child(recurso_item)

func _on_receta_seleccionada(receta_id):
	if not seleccion_local.has(receta_id):
		seleccion_local[receta_id] = 1
	else:
			seleccion_local[receta_id] += 1
	cargar_seleccionados()  # actualiza la lista seleccinada
	cargar_recursos()
	

func _on_boton_resta(receta_id):
	if seleccion_local.has(receta_id):
		seleccion_local[receta_id] -= 1
		if seleccion_local[receta_id] <= 0:
			seleccion_local.erase(receta_id)
	cargar_seleccionados()
	cargar_recursos()


func _on_aceptar_pressed() -> void:
	# Verificar recursos suficientes
	var recursos_necesarios = {}
	for receta_id in seleccion_local.keys():
		var cantidad = seleccion_local[receta_id]
		var receta = Globales.recetas_desbloqueadas[receta_id]
		for recurso_id in receta["recursos_requeridos"].keys():
			var cantidad_por_plato = receta["recursos_requeridos"][recurso_id]
			if not recursos_necesarios.has(recurso_id):
				recursos_necesarios[recurso_id] = 0
			recursos_necesarios[recurso_id] += cantidad * cantidad_por_plato

	# Verificar stock suficiente
	for recurso_id in recursos_necesarios.keys():
		if recursos_necesarios[recurso_id] > Globales.recursos_disponibles[recurso_id]["cantidad"]:
			$Panel/ErrorPopup.show()
			return

	# Aplicar cambios
	for recurso_id in recursos_necesarios.keys():
		Globales.recursos_disponibles[recurso_id]["cantidad"] -= recursos_necesarios[recurso_id]

	for receta_id in seleccion_local.keys():
		# platos_seleccionables
		if NocheData.platos_seleccionables.has(receta_id):
			NocheData.platos_seleccionables[receta_id] += seleccion_local[receta_id]
		else:
			NocheData.platos_seleccionables[receta_id] = seleccion_local[receta_id]

		# disponibles_cocinar
		if NocheData.disponibles_cocinar.has(receta_id):
			NocheData.disponibles_cocinar[receta_id] += seleccion_local[receta_id]
		else:
			NocheData.disponibles_cocinar[receta_id] = seleccion_local[receta_id]

	# Limpiar selección local
	seleccion_local.clear()

	# Cerrar menú
	_on_cancelar_pressed()




func _on_cancelar_pressed() -> void:
	seleccion_local= {}
	visible = false
	
	
func actualizar()-> void:
	cargar_recetas()
	cargar_seleccionados()
	cargar_recursos()
	
