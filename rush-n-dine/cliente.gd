extends CharacterBody2D

@export var speed: float = 500.0
var target_position: Vector2
var mesa_asignada: Node = null
var sentado: bool = false

func _physics_process(delta: float) -> void:
	if sentado:
		velocity = Vector2.ZERO
		return

	var direction = (target_position - global_position).normalized()
	velocity = direction * speed

	if global_position.distance_to(target_position) > 4.0:
		move_and_slide()
		actualizar_animacion(direction)
	else:
		velocity = Vector2.ZERO
		sentado = true
		posicionar_sentado()

func actualizar_animacion(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		$AnimatedSprite2D.animation = "caminar_derecha" if direction.x > 0.0 else "caminar_izquierda"
	else:
		$AnimatedSprite2D.animation = "caminar_abajo" if direction.y > 0.0 else "caminar_frente"
	$AnimatedSprite2D.play()

func posicionar_sentado() -> void:
	if mesa_asignada:
		if mesa_asignada.has_node("PuntoSentado"):
			var punto = mesa_asignada.get_node("PuntoSentado")
			if punto != null:
				global_position = punto.global_position
				z_index = 1
				$AnimatedSprite2D.animation = "sentado"
				$AnimatedSprite2D.play()
			else:
				print("Error: 'PuntoSentado' es null")
		else:
			print("Error: Mesa asignada no tiene nodo 'PuntoSentado'")
	else:
		print("Error: mesa_asignada es null")


func asignar_mesa(mesa: Node) -> void:
	mesa_asignada = mesa  # Aquí asignamos la mesa correctamente
	print("Mesa asignada: ", mesa_asignada)
	print("Nombre de la mesa asignada: ", mesa_asignada.name)
	if mesa_asignada.has_node("PuntoSentado"):
		print("PuntoSentado existe")
		var punto = mesa_asignada.get_node("PuntoSentado")
		print("Posición PuntoSentado: ", punto.global_position)
		target_position = punto.global_position  # Asignar también target_position
	else:
		print("Asignar mesa: mesa no tiene nodo 'PuntoSentado'")
