extends Node2D

@export var cliente_escena: PackedScene
@export var intervalo_min: float = 5.0
@export var intervalo_max: float = 8.0

var rng = RandomNumberGenerator.new()
var bloquear_cocinero = false

func is_minijuego_activo():
	return bloquear_cocinero
	
func _ready():
	$Timer.wait_time = rng.randf_range(intervalo_min, intervalo_max)
	$Timer.one_shot = true
	$Timer.start()
	$Timer.timeout.connect(_on_timer_timeout)
	bloquear_cocinero = false
	#Logica para obtener resultados de minijuego
	if Globales.resultado_minijuego["receta"]:
		procesar_resultado_minijuego(Globales.resultado_minijuego)
		Globales.resultado_minijuego = {}  # lo limpiás para el siguiente minijuego

func procesar_resultado_minijuego(resultado):
	var puntaje = resultado["puntaje"]
	var receta = resultado["receta"]

	print("¡Completaste el minijuego para:", receta["nombre"], "!")
	print("Puntaje:", puntaje)
	var cocinero = get_node_or_null("CharacterBodyCocinero2D")  # Ruta real a tu personaje
	print("Buscando cocinero... Encontrado:", cocinero != null)
	if cocinero:
		var plato: Node
		if puntaje >= 1:
			print("Instanciando PlatoBueno")
			plato = preload("res://Platos/PlatoBueno.tscn").instantiate()
		else:
			print("Instanciando PlatoQuemado")
			plato = preload("res://Platos/PlatoQuemado.tscn").instantiate()
		# Asignar la receta al plato
		plato.receta = receta
		plato.clave = ""  # <-- agregá esto
		# Buscá la clave correspondiente a la receta
		for clave in Globales.recetas_desbloqueadas.keys():
			if Globales.recetas_desbloqueadas[clave] == receta:
				plato.clave = clave
				break
		# Puedes guardar la receta también si querés
		print("Plato creado:", plato, "con receta:", receta)
		cocinero.recibir_plato(plato)
		print("Cocinero tiene método recibir_plato:", cocinero.has_method("recibir_plato"))
	Globales.resultado_minijuego = {}  # Limpiar para el próximo
	Globales.receta_actual = null      # <--- AGREGÁ ESTA LÍNEA
	Globales.pos_minijuego_actual = 0  # <--- AGREGÁ ESTA LÍNEA
	# Aca aplicar algo en base a los puntos

	# También podrías actualizar alguna UI de resultados si tenés

func _on_timer_timeout():
	var gestor = $Mesas
	var mesa_libre = gestor.obtener_mesa_libre()
	if mesa_libre:
		var cliente = cliente_escena.instantiate()
		cliente.global_position = $PuntoEntrada.global_position
		cliente.punto_salida = $PuntoEntrada.get_path()
		add_child(cliente)
		cliente.asignar_mesa(mesa_libre)  # Usar la función para asignar mesa y posición
	else:
		print("No hay mesas libres.")

	# Reprogramar siguiente cliente
	$Timer.wait_time = rng.randf_range(intervalo_min, intervalo_max)
	$Timer.start()
