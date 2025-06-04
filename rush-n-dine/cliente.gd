extends CharacterBody2D

@export var speed: float = 300.0
var target_position: Vector2
var mesa_asignada: Node = null
var sentado: bool = false
var pedido_actual : String = ""
var tiempo_espera : float = 0.0
var etapa_espera : int = 0
var esperando_pedido: bool = false
@export var punto_salida: NodePath
var nube_pedido: AnimatedSprite2D = null

var tiene_pedido
var pedido_tomado := false   # false: esperando que lo atiendan, true: esperando que le sirvan

func _ready():
	# Ahora accedes directo al hijo nubePedido del cliente
	nube_pedido = $nubePedido
	nube_pedido.visible = false
	add_to_group("clientes")  # ¡Clave!
	print("Cliente agregado al grupo:", self)
func _physics_process(delta: float) -> void:
	if sentado:
		velocity = Vector2.ZERO
	else:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed

		if global_position.distance_to(target_position) > 4.0:
			move_and_slide()
			actualizar_animacion(direction)
		else:
			velocity = Vector2.ZERO
			if not mesa_asignada:  # Si no tiene mesa, está yendo a la salida
				queue_free()
			elif not sentado:
				sentado = true
				posicionar_sentado()

	if esperando_pedido:
		tiempo_espera += delta
		if tiempo_espera >= 3.0:
			tiempo_espera = 0.0
			etapa_espera += 1
			match etapa_espera:
				1:
					nube_pedido.animation = "mitadEspera"
					nube_pedido.play()
				2:
					nube_pedido.animation = "finalizaEspera"
					nube_pedido.play()
				3:
					print("Cliente se enojó y se va")
					esperando_pedido = false
					nube_pedido.visible = false
					nube_pedido.stop()
					if not pedido_tomado:
						print("Cliente se va porque no lo atendieron")
					else:
						print("Cliente se va porque no le sirvieron el plato")

					Globales.reputacion -= 1
					irse()

func recibir_plato(plato: Node):
	
	print("Plato recibido:", plato)
	var clave_plato = plato.clave if "clave" in plato else ""
	print("Comparando clave del plato:", clave_plato, "con pedido_actual:", pedido_actual)
	if clave_plato == pedido_actual:
		print("Cliente recibió su pedido correcto")
		$AnimatedSprite2D.animation = "Comiendo"
		$AnimatedSprite2D.play()
		Globales.reputacion += 1
	else:
		print("Cliente recibió el pedido incorrecto")
		Globales.reputacion -= 1

	esperando_pedido = false
	nube_pedido.visible = false
	#nube_pedido.animation = ""
	nube_pedido.stop()
	await get_tree().create_timer(3.0).timeout
	irse()
func interactuar():
	if tiene_pedido:
		print("El cocinero toma el pedido.")
		tiene_pedido = false
		pedido_tomado = true

		# Reiniciar ciclo de espera para recibir el plato
		etapa_espera = 0
		tiempo_espera = 0.0
		esperando_pedido = true

		nube_pedido.visible = true
		nube_pedido.animation = "iniciaEspera"
		nube_pedido.play()

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
				print("Esperando que le entregues:", pedido_actual) # <-- Agrega esto si quieres
				tiene_pedido = true
				# Mostrar y posicionar nubePedido encima del cliente
				nube_pedido.visible = true
				# Como nubePedido es hijo, usamos position relativo, no global_position
				nube_pedido.position = Vector2(0, -20)  # Ejemplo: 20 pixeles arriba del cliente
				nube_pedido.z_index = 3002  # Por encima del cliente

				nube_pedido.animation = "iniciaEspera"
				nube_pedido.play()
				pedido_tomado = false
				esperando_pedido = true
				tiempo_espera = 0.0
				etapa_espera = 0
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
	var disponibles = NocheData.platos_seleccionables
	
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
			NocheData.platos_seleccionables[pedido_actual] -= 1
			# Si ya no queda, lo eliminamos del diccionario
			if NocheData.platos_seleccionables[pedido_actual] <= 0:
				NocheData.platos_seleccionables.erase(pedido_actual)
			# Refrescar el menú visual
			var menu_seleccionable = get_tree().get_root().get_node("Noche/CanvasLayer2/MenuSeleccionRecetas") # Ajusta si el nodo tiene otro nombre
			if menu_seleccionable and menu_seleccionable.has_method("actualizar"):
				menu_seleccionable.actualizar()
			return
func irse():
	var gestor_mesas = get_tree().get_root().get_node("Noche/Mesas")  # Ajusta la ruta según tu escena
	if gestor_mesas and mesa_asignada:
		gestor_mesas.liberar_mesa(mesa_asignada)


	# Liberar y resetear estado
	mesa_asignada = null
	sentado = false
	velocity = Vector2.ZERO
	
	# Devolver el pedido si el cliente se va sin recibirlo
	if pedido_actual != "":
		if tiene_pedido or pedido_tomado:
			print("Cliente se fue sin su plato, devolviendo:", pedido_actual)
			if NocheData.platos_seleccionables.has(pedido_actual):
				NocheData.platos_seleccionables[pedido_actual] += 1
			else:
				NocheData.platos_seleccionables[pedido_actual] = 1  # Volver a agregarlo al stock

			# Refrescar menú visual
			var menu_seleccionable = get_tree().get_root().get_node("Noche/CanvasLayer2/MenuSeleccionRecetas")
			if menu_seleccionable and menu_seleccionable.has_method("actualizar"):
				menu_seleccionable.actualizar()

	# Ir al punto de salida
	var salida = get_tree().get_root().get_node("Noche/PuntoEntrada")  # Ajusta la ruta si es necesario
	if salida:
		target_position = salida.global_position
		$AnimatedSprite2D.animation = "caminar_abajo"
		$AnimatedSprite2D.play()
	else:
		print("Error: PuntoEntrada no encontrado")
