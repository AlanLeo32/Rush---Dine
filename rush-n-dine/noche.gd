extends Node2D

@export var cliente_escena: PackedScene
@export var intervalo_min: float = 7.0
@export var intervalo_max: float = 7.0

var rng = RandomNumberGenerator.new()

func _ready():
	$Timer.wait_time = rng.randf_range(intervalo_min, intervalo_max)
	$Timer.one_shot = true
	$Timer.start()
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var gestor = $Mesas
	var mesa_libre = gestor.obtener_mesa_libre()
	if mesa_libre:
		var cliente = cliente_escena.instantiate()
		cliente.global_position = $PuntoEntrada.global_position
		add_child(cliente)
		cliente.asignar_mesa(mesa_libre)  # Usar la función para asignar mesa y posición
	else:
		print("No hay mesas libres.")

	# Reprogramar siguiente cliente
	$Timer.wait_time = rng.randf_range(intervalo_min, intervalo_max)
	$Timer.start()
