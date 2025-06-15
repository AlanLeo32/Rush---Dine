extends Control

const AGUA_ID := "agua"
const AGUA_RECETA := {
		"nombre": "Agua",
		"imagen": preload("res://Sprites/agua.png"),
}


func _ready():
	cargar_disponibles()

func cargar_disponibles():
	for child in $Panel/ScrollDisponibles/HBoxDisponibles.get_children():
		child.queue_free()

	# 🔹 Siempre agregamos primero el ítem de "Agua"
	var receta_item_agua = preload("res://DisponibleItem.tscn").instantiate()
	receta_item_agua.set_data(AGUA_ID, AGUA_RECETA, -1)  # -1 para infinito
	receta_item_agua.connect("seleccionado", Callable(self, "_on_disponible_seleccionada"))
	$Panel/ScrollDisponibles/HBoxDisponibles.add_child(receta_item_agua)


	for disponible in NocheData.disponibles_cocinar:
		var receta_data = Globales.recetas_desbloqueadas[disponible]
		var receta_item = preload("res://DisponibleItem.tscn").instantiate()
		receta_item.set_data(disponible, receta_data,NocheData.disponibles_cocinar[disponible])
		receta_item.connect("seleccionado", Callable(self, "_on_disponible_seleccionada"))
		$Panel/ScrollDisponibles/HBoxDisponibles.add_child(receta_item)

func _on_disponible_seleccionada(disp_id):
	if disp_id != "agua":
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
	else:
		var resultado := {
		"puntaje": 999,
		"receta": AGUA_RECETA,
		}	
		var noche = get_tree().current_scene
		noche.procesar_resultado_minijuego(resultado)
	visible = false


func _on_cancelar_pressed() -> void:
	visible = false
func actualizar():
	cargar_disponibles()
