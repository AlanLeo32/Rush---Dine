extends Control

@export var radio: float = 200.0
@export var grosor: float = 450.0
@export var angulo_inicio: float = 0.0  # en grados
@export var angulo_fin: float = 90.0    # en grados
@export var color_progreso: Color = Color.RED
@export var color_fondo: Color = Color("#ffdebc")

func _draw():
	var center := size / 2

	# Fondo circular completo
	draw_arc(center, radio, 0, TAU, 64, color_fondo, grosor)

	# Convertimos grados a radianes
	var start_angle := deg_to_rad(angulo_inicio)
	var end_angle := deg_to_rad(angulo_fin)

	# Si el fin es menor al inicio, asumimos que pasa por el 0°
	if end_angle < start_angle:
		end_angle += TAU

	# Pintamos solo el sector entre los ángulos
	draw_arc(center, radio, start_angle, end_angle, 64, color_progreso, grosor)

func actualizar_sector(nuevo_inicio: float, nuevo_fin: float) -> void:
	angulo_inicio = nuevo_inicio
	angulo_fin = nuevo_fin
	queue_redraw()
