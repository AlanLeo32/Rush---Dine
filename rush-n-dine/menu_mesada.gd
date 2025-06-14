extends Control

func _ready():
	cargar_platillos_en_mesada()

func cargar_platillos_en_mesada():
	$Panel/BotonPlatoActual/CanvasLayer.visible = false
	
	# Limpiar botones anteriores
	for child in $Panel/ScrollMesada/HBoxMesada.get_children():
		child.queue_free()

	# Cargar los platos disponibles en la mesada
	for plato in NocheData.platillos_mesada:
		var item = preload("res://MesadaItem.tscn").instantiate()
		item.set_data(plato)
		item.connect("seleccionado", Callable(self, "_on_plato_seleccionado"))
		$Panel/ScrollMesada/HBoxMesada.add_child(item)
	var cocinero = get_tree().get_root().get_node("Noche/CharacterBodyCocinero2D")
	if cocinero.objeto_en_mano!=null:
		$Panel/BotonPlatoActual/CanvasLayer.visible = true
		var receta_data= cocinero.objeto_en_mano.receta
		$Panel/BotonPlatoActual/CanvasLayer/ImagenReceta.texture = receta_data["imagen"]
		$Panel/BotonPlatoActual/CanvasLayer/Nombre.text = receta_data["nombre"]
		if cocinero.objeto_en_mano.scene_file_path.ends_with("PlatoBueno.tscn"):
			$Panel/BotonPlatoActual/CanvasLayer/Estado.text = "Bueno"
		elif cocinero.objeto_en_mano.scene_file_path.ends_with("PlatoQuemado.tscn"):
			$Panel/BotonPlatoActual/CanvasLayer/Estado.text = "Quemado"
		
func _on_plato_seleccionado(plato: Node):
	var cocinero = get_tree().get_root().get_node("Noche/CharacterBodyCocinero2D")
	if cocinero.objeto_en_mano:
		# Devolver el plato actual a la mesada
		NocheData.platillos_mesada.append(cocinero.objeto_en_mano)
		cocinero.dejar_plato_mesada()

	# Remover el nuevo plato de la mesada y dárselo al cocinero
	NocheData.platillos_mesada.erase(plato)
	cocinero.recibir_plato(plato)
	visible = false

func _on_boton_plato_actual_pressed() -> void:
	var cocinero = get_tree().get_root().get_node("Noche/CharacterBodyCocinero2D")
	if cocinero.objeto_en_mano:
		# Devolver el plato actual a la mesada
		NocheData.platillos_mesada.append(cocinero.objeto_en_mano)
		cocinero.dejar_plato_mesada()
		visible = false

func _on_cancelar_pressed():
	visible = false

func actualizar():
	cargar_platillos_en_mesada()
