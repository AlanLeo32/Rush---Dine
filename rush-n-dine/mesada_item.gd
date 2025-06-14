extends Control

signal seleccionado(plato)

var receta_id
var start_pos := Vector2.ZERO
var moved := false
var threshold := 10
var plato

func set_data(platillo):
	plato = platillo
	var receta_data = platillo.receta
	$CanvasLayer/ImagenReceta.texture = receta_data["imagen"]
	$CanvasLayer/Nombre.text = receta_data["nombre"]
	if platillo.scene_file_path.ends_with("PlatoBueno.tscn"):
		$CanvasLayer/Estado.text = "Bueno"
	elif platillo.scene_file_path.ends_with("PlatoQuemado.tscn"):
		$CanvasLayer/Estado.text = "Quemado"

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pos = event.position
			moved = false
		else:
			if not moved:
				emit_signal("seleccionado", plato)
	elif event is InputEventMouseMotion:
		if (event.position - start_pos).length() > threshold:
			moved = true
