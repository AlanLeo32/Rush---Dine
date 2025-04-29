extends CharacterBody2D

@export var velocidad := 120.0

func _physics_process(delta):
	var direccion := Vector2.ZERO
	direccion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direccion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = direccion.normalized() * velocidad
	move_and_slide()
