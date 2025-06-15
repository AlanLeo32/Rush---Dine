extends Node
@export var cliente_escena: PackedScene
@export var duracion_noche: float = 240.0  # duración total en segundos (4 minutos reales)

var rng = RandomNumberGenerator.new()
var bloquear_cocinero = false
var tiempo_restante: float

var tiempos_por_popularidad := {
	"S": [2, 4],
	"A": [4, 8],
	"B": [8, 12],
	"C": [12, 15],
	"D": [15, 20]
}

func is_minijuego_activo():
	return bloquear_cocinero

func _ready():
	bloquear_cocinero = false
	tiempo_restante = duracion_noche
	set_process(true)

	# Conectar el timer solo una vez
	$TimerClientes.timeout.connect(_on_timer_timeout)


func _process(delta):
	var aguja = $CanvasLayer2/Reloj/Aguja

	if tiempo_restante > 0 and not bloquear_cocinero:
		$CanvasLayer2/Reloj.visible = true
		tiempo_restante -= delta

		# Simular avance horario de 20:00 a 24:00
		var minutos_inicio = 20 * 60
		var minutos_fin = 24 * 60
		var minutos_totales = minutos_fin - minutos_inicio
		var proporcion = (duracion_noche - tiempo_restante) / duracion_noche
		var progreso_aguja = clamp(proporcion, 0.0, 1.0)
		var angulo_aguja = lerp(deg_to_rad(240), deg_to_rad(360), progreso_aguja)
		aguja.rotation = angulo_aguja

		# Solo si el timer no está corriendo y hay mesas, activarlo
		if $TimerClientes.is_stopped():
			var gestor = $Mesas
			if gestor.hay_mesa_libre():
				var intervalo = tiempos_por_popularidad.get(Globales.reputacion_categoria)
				$TimerClientes.wait_time = rng.randf_range(intervalo[0], intervalo[1])
				$TimerClientes.one_shot = true
				$TimerClientes.start()

	else:
		$CanvasLayer2/Reloj.visible = false

	if tiempo_restante <= 0:
		finalizar_noche()

func _on_timer_timeout():
	var gestor = $Mesas
	var mesa_libre = gestor.obtener_mesa_libre()
	if tiempo_restante > 0 and mesa_libre:
		var cliente = cliente_escena.instantiate()
		cliente.global_position = $PuntoEntrada.global_position
		cliente.punto_salida = $PuntoEntrada.get_path()
		add_child(cliente)
		cliente.asignar_mesa(mesa_libre)

func finalizar_noche():
	print("¡La noche terminó!")
	get_tree().change_scene_to_file("res://ControlMenu.tscn")

func procesar_resultado_minijuego(resultado):
	var puntaje = resultado["puntaje"]
	var receta = resultado["receta"]

	print("¡Completaste el minijuego para:", receta["nombre"], "! Puntaje:", puntaje)
	var cocinero = get_node_or_null("CharacterBodyCocinero2D")
	if cocinero:
		var plato: Node
		if puntaje >= 1:
			plato = preload("res://Platos/PlatoBueno.tscn").instantiate()
		else:
			plato = preload("res://Platos/PlatoQuemado.tscn").instantiate()

		plato.receta = receta
		plato.clave = ""
		if receta["nombre"] != "Agua":
			for clave in Globales.recetas_desbloqueadas.keys():
				if Globales.recetas_desbloqueadas[clave] == receta:
					plato.clave = clave
					break
		else:
			plato.clave = "agua"
		cocinero.recibir_plato(plato)

	ManejoMinijuegos.resultado_minijuego = {}
	ManejoMinijuegos.receta_actual = null
	ManejoMinijuegos.pos_minijuego_actual = 0
