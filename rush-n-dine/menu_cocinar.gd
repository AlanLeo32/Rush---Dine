extends Control

func _ready():
	cargar_disponibles()

func cargar_disponibles():
	for child in $Panel/ScrollDisponibles/HBoxDisponibles.get_children():
		child.queue_free()

	for disponible in NocheData.disponibles_cocinar:
		var receta_data = Globales.recetas_desbloqueadas[disponible]
		var receta_item = preload("res://DisponibleItem.tscn").instantiate()
		receta_item.set_data(disponible, receta_data,NocheData.disponibles_cocinar[disponible])
		receta_item.connect("seleccionado", Callable(self, "_on_disponible_seleccionada"))
		$Panel/ScrollDisponibles/HBoxDisponibles.add_child(receta_item)

func _on_disponible_seleccionada(disp_id):
	print("Se gasta: ", disp_id)
	NocheData.disponibles_cocinar[disp_id] -= 1
	if NocheData.disponibles_cocinar[disp_id] <= 0:
		NocheData.disponibles_cocinar.erase(disp_id)
	
	# Obtengo los datos de la receta
	var receta_data = Globales.recetas_desbloqueadas[disp_id]
	#Selecciono el minijuego
	if receta_data.has("minijuegos") and receta_data["minijuegos"].size() > 0:
		ManejoMinijuegos.receta_actual = receta_data

		# Cambiar a escena del minijuego
		ManejoMinijuegos.logica_siguiente_minijuego()
	else:
		push_error("La receta no tiene minijuegos definidos")
	
	visible = false


func _on_cancelar_pressed() -> void:
	visible = false
func actualizar():
	cargar_disponibles()
