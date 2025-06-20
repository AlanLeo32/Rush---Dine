extends Area2D

signal target_entered()
signal target_exited()

const SPEED := 500
var dragging := false
var touch_position := Vector2.ZERO
var on_fish := false

func _input(event):
	if event is InputEventScreenTouch:
		dragging = event.pressed
		if dragging:
			touch_position = event.position
	elif event is InputEventScreenDrag:
		touch_position = event.position
		dragging = true
	elif event is InputEventMouseButton:
		dragging = event.pressed
		touch_position = event.position
	elif event is InputEventMouseMotion and dragging:
		touch_position = event.position

func _physics_process(delta: float) -> void:
	_check_on_fish()

	if dragging:
		var direction := (touch_position - global_position).normalized()
		var distance := global_position.distance_to(touch_position)

		if distance > 5:
			global_position += direction * SPEED * delta
		else:
			global_position = touch_position

func _check_on_fish() -> void:
	var bodies := get_overlapping_bodies()

	if bodies.is_empty() and on_fish:
		on_fish = false
		target_exited.emit()
	elif not bodies.is_empty() and not on_fish:
		on_fish = true
		target_entered.emit()
