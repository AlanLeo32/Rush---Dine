extends Area2D

signal target_entered()
signal target_exited()

const SPEED := 500
var dragging := false
var on_fish := false

func _input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		dragging = event.pressed
	elif event is InputEventMouseButton:
		dragging = event.pressed

func _physics_process(delta: float) -> void:
	_check_on_fish()

	if dragging:
		var target_pos := get_global_mouse_position()
		var direction := (target_pos - global_position).normalized()
		var distance := global_position.distance_to(target_pos)

		if distance > 5:
			global_position += direction * SPEED * delta
		else:
			global_position = target_pos

func _check_on_fish() -> void:
	var bodies := get_overlapping_bodies()

	if bodies.is_empty() and on_fish:
		on_fish = false
		target_exited.emit()
	elif not bodies.is_empty() and not on_fish:
		on_fish = true
		target_entered.emit()
