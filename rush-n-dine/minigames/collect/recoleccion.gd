extends Node2D

var colectable_scene: PackedScene = load("res://minigames/collect/colectable.tscn")
var roca_scene: PackedScene = load("res://minigames/collect/roca.tscn")
var cant_colectables: int = 0

@onready var canasta = $CanastaRecoleccion

func _on_timer_colectable_spawn_timeout() -> void:
	var colectable
	if randf() < 0.75:
		colectable = colectable_scene.instantiate()
		colectable.connect("recolectado", Callable(self, "_on_colectable_recolectado"))
	else:
		colectable = roca_scene.instantiate()
		colectable.connect("recolectado_roca", Callable(self, "_on_colectable_recolectado_roca"))
	
	$Colectables.add_child(colectable)


func _process(delta):
	var tiempo_restante = int($TimerMinijuego.time_left)
	$CantidadLabel.text = "Cantidad: %d" % cant_colectables
	$TimeLeftLabel.text = "%d" % tiempo_restante


func _on_timer_minijuego_timeout() -> void:
	terminar_minijuego()
	
func terminar_minijuego():
	print("Juego recolección terminado")
	# Detener timers, pausar si es necesario, etc.
	if has_node("TimerMinijuego"):
		$TimerMinijuego.stop()

	# Calcula la cantidad de recursos recolectados 
	var cant_recurso
	if cant_colectables > 0:
		cant_recurso = int(cant_colectables/2)
	else:
		cant_recurso = 0
	var recurso = "verdura" 

	ManejoMinijuegos.actualizar_recursos(recurso, cant_recurso)
	ManejoMinijuegos.volver_a_dia()

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		var screen_size = get_viewport().size
		if event.position.x < screen_size.x / 2:
			canasta.mover_izquierda()
		else:
			canasta.mover_derecha()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var screen_size = get_viewport().size
		if event.position.x < screen_size.x / 2:
			canasta.mover_izquierda()
		else:
			canasta.mover_derecha()

func _on_colectable_recolectado():
	cant_colectables += 1

func _on_colectable_recolectado_roca():
	if cant_colectables > 0:
		cant_colectables -= 1
