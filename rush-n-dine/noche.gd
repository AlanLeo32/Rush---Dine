extends Node2D

@export var cliente_escena: PackedScene
@export var intervalo_min: float = 5.0
@export var intervalo_max: float = 8.0

var rng = RandomNumberGenerator.new()

func _ready():
	$Timer.wait_time = rng.randf_range(intervalo_min, intervalo_max)
	$Timer.one_shot = true
	$Timer.start()
	$Timer.timeout.connect(_on_timer_timeout)
	
	#Logica para obtener resultados de minijuego
	if Globales.resultado_minijuego.size() > 0:
		procesar_resultado_minijuego(Globales.resultado_minijuego)
		Globales.resultado_minijuego = {}  # lo limpiás para el siguiente minijuego

func procesar_resultado_minijuego(resultado):
	var puntaje = resultado.get("puntaje", 0)
	var receta = resultado.get("receta", null)

	print("¡Completaste el minijuego para:", receta.nombre)
	print("Puntaje:", puntaje)

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
