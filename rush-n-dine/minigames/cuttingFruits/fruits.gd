extends Node2D

var previous_position = Vector2.ZERO
var current_position = Vector2.ZERO



func _process(delta):
	if Input.is_action_pressed("mouse_left"):
		current_position = get_global_mouse_position()
		if previous_position != Vector2.ZERO:
			$RayCast2D.global_position = previous_position
			$RayCast2D.target_position = current_position
			$RayCast2D.force_raycast_update()
			if $RayCast2D.is_colliding():
				print("Colisión detectada con: ", $RayCast2D.get_collider())
			var collider = $RayCast2D.get_collider()
			if (collider and collider.has_method("cut")):
				collider.cut()
			# Construyendo los parámetros para intersect_ray()
			#var ray_params = PhysicsRayQueryParameters2D.new()
			#ray_params.from = previous_position
			#ray_params.to = current_position
			#var collision = get_world_2d().direct_space_state.intersect_ray(ray_params)
			#if collision:
			#	print("tocaste el tomate crack")
			#if collision and collision.collider.has_method("cut"):
			#	collision.collider.cut()
		previous_position = current_position
	else:
		previous_position = Vector2.ZERO
		
