extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $AgenteNavegacion
var icono_exclamacion := preload("res://Sprites/Exclamacion.png")
var imagen_agua := preload("res://Sprites/agua.png")
@export var speed: float = 300.0
var target_position: Vector2
var mesa_asignada: Node = null
var sentado: bool = false
var pedido_actual : String = ""
var tiempo_espera : float = 0.0
var etapa_espera : int = 0

@export var punto_salida: NodePath
var nube_pedido: AnimatedSprite2D = null
var imagen_nube: TextureRect = null

var esperando_pedido: bool = false
var esperando_atencion: bool = false

var tiempos_espera_por_popularidad := {
	"S": 13,
	"A": 11,
	"B": 9,
	"C": 7,
	"D": 5
}



func _process(_delta):
	z_index = int(global_position.y)

	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var viewport := get_viewport()

	var screen_size: Vector2 = viewport.get_visible_rect().size
	var screen_center: Vector2 = screen_size / 2.0

	var transform: Transform2D = viewport.get_canvas_transform()
	var screen_coords: Vector2 = transform * global_position

	var margen_x: float = 10.0
	var margen_y: float = -90

	# Verificación de visibilidad con márgenes ajustados
	var visible := screen_coords.x >= margen_x and screen_coords.x <= screen_size.x - 250 and \
				   screen_coords.y >= margen_y+300 and screen_coords.y <= screen_size.y

	if visible:
		# Cliente dentro de cámara → globo sobre la cabeza
		nube_pedido.position = Vector2(0, -20)
		nube_pedido.rotation = 0
		nube_pedido.global_position = global_position + Vector2(0, -20)
	else:
		# Cliente fuera de cámara → proyectar al borde visible
		var dir: Vector2 = (screen_coords - screen_center).normalized()

		var limite_x: float = screen_center.x - margen_x
		var limite_y: float = screen_center.y - margen_y

		var escalar_x: float = limite_x / abs(dir.x) if dir.x != 0.0 else INF
		var escalar_y: float = limite_y / abs(dir.y) if dir.y != 0.0 else INF
		var escalar: float = min(escalar_x, escalar_y)

		var borde_pantalla: Vector2 = screen_center + dir * escalar

		# Clamp manual para evitar desbordes en cualquier dirección
		var margen_fijo_x: float = 250.0  # margen más amplio para el borde derecho
		borde_pantalla.x = clamp(borde_pantalla.x, margen_x, screen_size.x - margen_fijo_x)
		borde_pantalla.y = clamp(borde_pantalla.y, margen_y+400, screen_size.y - margen_y)

		# Convertimos de pantalla a mundo
		var world_coords: Vector2 = transform.affine_inverse() * borde_pantalla
		nube_pedido.global_position = world_coords
		nube_pedido.rotation = 0  # podés usar dir.angle() si querés que apunte


func _ready():
	# Ahora accedes directo al hijo nubePedido del cliente
	nube_pedido = $nubePedido
	imagen_nube= $nubePedido/TextureRect
	nube_pedido.visible = false
	add_to_group("clientes")  # ¡Clave!
	print("Cliente agregado al grupo:", self)
	
func _physics_process(delta: float) -> void:
	var noche = get_tree().get_root().get_node("Noche")
	if noche.is_minijuego_activo():
		# Pausar completamente el comportamiento del cliente
		velocity = Vector2.ZERO
		return
	else:
		if sentado:
			velocity = Vector2.ZERO
		else:
			if not nav_agent.is_navigation_finished():
				var next_point = nav_agent.get_next_path_position()
				var direction = (next_point - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
				actualizar_animacion(direction)
			else:
				velocity = Vector2.ZERO
				if not mesa_asignada:
					queue_free()
				elif not sentado:
					sentado = true
					posicionar_sentado()

		nav_agent.set_velocity(velocity)

		if esperando_pedido or esperando_atencion:
			tiempo_espera += delta
			if tiempo_espera >= tiempos_espera_por_popularidad.get(Globales.reputacion_categoria):
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
						if  esperando_atencion:
							print("Cliente se va porque no lo atendieron")
						else:
							print("Cliente se va porque no le sirvieron el plato")
						NocheData.atenciones_incompletas += 1
						# Devolver el pedido si el cliente se va sin recibirlo
						if pedido_actual != "agua":
							print("Cliente se fue sin su plato, devolviendo:", pedido_actual)
							if NocheData.platos_seleccionables.has(pedido_actual):
								NocheData.platos_seleccionables[pedido_actual] += 1
							else:
								NocheData.platos_seleccionables[pedido_actual] = 1  # Volver a agregarlo al stock

							# Refrescar menú visual
							var menu_seleccionable = get_tree().get_root().get_node("Noche/CanvasLayer2/MenuSeleccionRecetas")
							if menu_seleccionable and menu_seleccionable.has_method("actualizar"):
								menu_seleccionable.actualizar()
						irse()

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
				# Esperar antes de mostrar el pedido
				await get_tree().create_timer(5).timeout
				# Mostrar nube y comenzar ciclo
				imagen_nube.texture = icono_exclamacion
				nube_pedido.visible = true
				nube_pedido.animation = "iniciaEspera"
				nube_pedido.play()
				esperando_atencion = true
				tiempo_espera = 0.0
				etapa_espera = 0
			else:
				print("Error: 'PuntoSentado' es null")
		else:
			print("Error: Mesa asignada no tiene nodo 'PuntoSentado'")
	else:
		print("Error: mesa_asignada es null")

func asignar_mesa(mesa: Node) -> void:
	mesa_asignada = mesa
	print("Mesa asignada: ", mesa_asignada.name)
	if mesa_asignada.has_node("PuntoSentado"):
		var punto = mesa_asignada.get_node("PuntoSentado")
		target_position = punto.global_position
		nav_agent.target_position = target_position
	else:
		print("Asignar mesa: mesa no tiene nodo 'PuntoSentado'")

func recibir_plato(plato: Node):
	print("Cliente recibió su pedido correcto")
	
	# Obtener el sprite del nodo que recibió
	var sprite_origen := plato.get_node("Sprite")
	# Obtener el Sprite de la mesa asignada
	var sprite_destino := mesa_asignada.get_node("Plato")
	# Copiar la textura
	sprite_destino.texture = sprite_origen.texture
	sprite_destino.scale = Vector2(0.25, 0.25)
	# Asegurarse que esté visible
	sprite_destino.visible = true
	
	$AnimatedSprite2D.animation = "Comiendo"
	$AnimatedSprite2D.play()
	NocheData.atenciones_completas +=1
	if pedido_actual!="agua":
		NocheData.dinero_ganado+= plato.receta["precio"]
	esperando_pedido = false
	nube_pedido.visible = false
	nube_pedido.stop()
	await get_tree().create_timer(3.0).timeout
	sprite_destino.texture = load("res://Sprites/plato.png")
	sprite_destino.scale = Vector2(0.5, 0.4)
	irse()

func atendido():
	if esperando_atencion:
		print("El cocinero toma el pedido.")
		esperando_atencion = false
		esperando_pedido = true

		# Reiniciar ciclo de espera para recibir el plato
		etapa_espera = 0
		tiempo_espera = 0.0
		esperando_pedido = true
		if Globales.recetas_desbloqueadas.has(pedido_actual):
			imagen_nube.texture = Globales.recetas_desbloqueadas.get(pedido_actual)["imagen"]
		else:
			imagen_nube.texture = imagen_agua
		nube_pedido.visible = true
		nube_pedido.animation = "iniciaEspera"
		nube_pedido.play()


func elegir_pedido():
	var disponibles = NocheData.platos_seleccionables
	# Crear una lista filtrada de platos realmente disponibles (cantidad > 0 y popularidad > 0)
	var platos_validos = []
	var pesos = []
	var suma_total = 0.0

	for nombre_plato in disponibles.keys():
		var cantidad = disponibles[nombre_plato]
		if cantidad > 0 and Globales.recetas_desbloqueadas.has(nombre_plato):
			var info = Globales.recetas_desbloqueadas[nombre_plato]
			var popularidad = float(info["popularidad"])
			if popularidad > 0:
				platos_validos.append(nombre_plato)
				pesos.append(popularidad)
				suma_total += popularidad

	# Si no hay platos realmente disponibles
	if platos_validos.size() == 0:
		pedido_actual = "agua"
		NocheData.aguas_servidas+=1
		return

	# Sorteo ponderado
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var r = rng.randf_range(0, suma_total)
	var acumulado = 0.0

	for i in range(platos_validos.size()):
		acumulado += pesos[i]
		if r <= acumulado:
			pedido_actual = platos_validos[i]
			print("Cliente pidió:", pedido_actual)
			NocheData.platos_seleccionables[pedido_actual] -= 1
			break

	# Refrescar menú visual
	var menu_seleccionable = get_tree().get_root().get_node("Noche/CanvasLayer2/MenuSeleccionRecetas")
	if menu_seleccionable and menu_seleccionable.has_method("actualizar"):
		menu_seleccionable.actualizar()

func irse():
	mesa_asignada.esperar_limpieza()
	# Liberar y resetear estado
	mesa_asignada = null
	sentado = false
	velocity = Vector2.ZERO

	# Ir al punto de salida
	var salida = get_tree().get_root().get_node("Noche/PuntoEntrada")  # Ajusta la ruta si es necesario
	if salida:
		target_position = salida.global_position
		nav_agent.target_position = target_position
		$AnimatedSprite2D.animation = "caminar_abajo"
		$AnimatedSprite2D.play()
	else:
		print("Error: PuntoEntrada no encontrado")
