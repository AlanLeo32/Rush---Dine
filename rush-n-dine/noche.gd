extends Node2D

@export var cliente_escena: PackedScene
@export var intervalo_min: float = 5.0
@export var intervalo_max: float = 8.0
@export var duracion_noche: float = 240.0 # duración total en segundos (ejemplo: 4 minutos)

var rng = RandomNumberGenerator.new()
var bloquear_cocinero = false
var tiempo_restante: float

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
	tiempo_restante = duracion_noche
	set_process(true)

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
	if tiempo_restante > 0:
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

func _process(delta):
	# Solo avanza el tiempo si no hay minijuego activo
	if tiempo_restante > 0 and not bloquear_cocinero:
		tiempo_restante -= delta

		# Simular el avance desde las 18:00 (1080 minutos) hasta las 24:00 (1440 minutos)
		var minutos_inicio = 18 * 60
		var minutos_fin = 24 * 60
		var minutos_totales = minutos_fin - minutos_inicio
		var proporcion = (duracion_noche - tiempo_restante) / duracion_noche
		var minutos_actuales = minutos_inicio + int(minutos_totales * proporcion)
		var horas = int(minutos_actuales / 60)
		var minutos = int(minutos_actuales % 60)

		$CanvasLayer2/RelojLabel.text = "Hora: %02d:%02d" % [horas, minutos]
		$CanvasLayer2/RelojLabel.visible = true
		print("Hora: %02d:%02d" % [horas, minutos])
	else:
		# Oculta el reloj si hay minijuego activo
		$CanvasLayer2/RelojLabel.visible = false

	if tiempo_restante <= 0:
		finalizar_noche()

func finalizar_noche():
	print("¡La noche terminó!")
	# Aquí puedes mostrar un resumen, guardar progreso, o cambiar de escena
	get_tree().change_scene_to_file("res://ControlMenu.tscn")
