extends CharacterBody2D


@export var SPEED = 500.0

var direccion_manual := 0

func _physics_process(delta: float) -> void:

	# Usar la dirección manual en vez de Input
	if direccion_manual != 0:
		velocity.x = direccion_manual * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func mover_izquierda():
	direccion_manual = -1

func mover_derecha():
	direccion_manual = 1

func _unhandled_input(event):
	# Si quieres que se detenga al soltar el toque/clic:
	if (event is InputEventScreenTouch and not event.pressed) or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed):
		direccion_manual = 0
