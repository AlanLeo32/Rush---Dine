extends CharacterBody2D

@export var speed: float = 300.0
var target_position: Vector2
var mesa_asignada: Node = null
var sentado: bool = false
var pedido_actual : String = ""


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
				elegir_pedido()
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
func elegir_pedido():
	var disponibles = NocheData.disponibles_cocinar
	
	# Verificar si hay platos disponibles
	if disponibles.is_empty():
		pedido_actual = "agua"
		Globales.reputacion -= 1
		print("Cliente pidió agua. Reputación bajó a: ", Globales.reputacion)
		return

	# Armar lista de platos y sus pesos de popularidad
	var platos_validos = []
	var pesos = []
	var suma_total = 0.0

	for nombre_plato in disponibles.keys():
		if Globales.recetas_desbloqueadas.has(nombre_plato):
			var info = Globales.recetas_desbloqueadas[nombre_plato]
			var popularidad = float(info["popularidad"])
			if popularidad > 0:
				platos_validos.append(nombre_plato)
				pesos.append(popularidad)
				suma_total += popularidad

	# Si por alguna razón no hay platos con popularidad positiva
	if platos_validos.size() == 0:
		pedido_actual = "agua"
		Globales.reputacion -= 1
		print("Cliente pidió agua. Reputación bajó a: ", Globales.reputacion)
		return

	# Elegir aleatoriamente un plato según su popularidad
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var r = rng.randf_range(0, suma_total)
	var acumulado = 0.0

	for i in range(platos_validos.size()):
		acumulado += pesos[i]
		if r <= acumulado:
			pedido_actual = platos_validos[i]
			print("Cliente pidió: ", pedido_actual)
			# Restar uno del disponible para cocinar
			NocheData.disponibles_cocinar[pedido_actual] -= 1
			# Si ya no queda, lo eliminamos del diccionario
			if NocheData.disponibles_cocinar[pedido_actual] <= 0:
				NocheData.disponibles_cocinar.erase(pedido_actual)
			# Notificar al menú para actualizarse si está visible
			# Notificar al menú cocinar que se actualice
			#var menu = get_tree().get_root().get_node("Noche/CanvasLayer2/MenuSeleccionRecetas")
			#if menu:
			#	menu



			return
