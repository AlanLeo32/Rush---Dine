extends Node2D

@export var cliente_escena: PackedScene
@export var intervalo_min: float = 5.0
@export var intervalo_max: float = 8.0
@export var duracion_dia: float = 240.0 # duración total en segundos (ejemplo: 4 minutos)

var rng = RandomNumberGenerator.new()
var bloquear_cocinero = false
var tiempo_restante: float
var bloquear_jugador := false # Si querés bloquear movimiento durante minijuegos de farmeo

func is_minijuego_activo():
	return bloquear_cocinero
	
func _ready():
	bloquear_cocinero = false
	#Logica para obtener resultados de minijuego
	
	tiempo_restante = duracion_dia
	set_process(true)

#
# Descomentarla cuando los minijuegos se puedan jugar en el dia
#
#func procesar_resultado_minijuego(resultado):
	#var puntaje = resultado["puntaje"]
	#var receta = resultado["receta"]
#
	#print("¡Completaste el minijuego para:", receta["nombre"], "!")
	#print("Puntaje:", puntaje)
	#var cocinero = get_node_or_null("CharacterBodyCocinero2D")  # Ruta real a tu personaje
	#print("Buscando cocinero... Encontrado:", cocinero != null)
	#if cocinero:
	#	var plato: Node
	#	if puntaje >= 1:
	#		print("Instanciando PlatoBueno")
	#		plato = preload("res://Platos/PlatoBueno.tscn").instantiate()
	#	else:
	#		print("Instanciando PlatoQuemado")
	#		plato = preload("res://Platos/PlatoQuemado.tscn").instantiate()
	#	# Asignar la receta al plato
	#	plato.receta = receta
	#	plato.clave = ""  # <-- agregá esto
	#	# Buscá la clave correspondiente a la receta
	#	for clave in Globales.recetas_desbloqueadas.keys():
	#		if Globales.recetas_desbloqueadas[clave] == receta:
	#			plato.clave = clave
	#			break
	#	# Puedes guardar la receta también si querés
	#	print("Plato creado:", plato, "con receta:", receta)
	#	cocinero.recibir_plato(plato)
	#	print("Cocinero tiene método recibir_plato:", cocinero.has_method("recibir_plato"))
	#Globales.resultado_minijuego = {}  # Limpiar para el próximo
	#Globales.receta_actual = null      # <--- AGREGÁ ESTA LÍNEA
	#Globales.pos_minijuego_actual = 0  # <--- AGREGÁ ESTA LÍNEA
	# Aca aplicar algo en base a los puntos

	# También podrías actualizar alguna UI de resultados si tenés


func _process(delta):
	# Solo avanza el tiempo si no hay minijuego activo
	if tiempo_restante > 0 and not bloquear_cocinero:
		tiempo_restante -= delta

		# Simular el avance desde las 8:00 (480 minutos) hasta las 18:00 (1080 minutos)
		var minutos_inicio = 8 * 60
		var minutos_fin = 18 * 60
		var minutos_totales = minutos_fin - minutos_inicio
		var proporcion = (duracion_dia - tiempo_restante) / duracion_dia
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
		terminar_dia()

func terminar_dia():
	print("¡El día terminó!")
	# Aquí puedes mostrar un resumen, guardar progreso, o cambiar de escena
	get_tree().change_scene_to_file("res://noche.tscn")
