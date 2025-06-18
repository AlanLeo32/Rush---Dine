extends Node2D  # o Control si estás usando UI
var anuncio=false
# Diccionario de eventos
var eventos := [
	{
		"descripcion": "Hoy no pasó nada inusual.",
		"factor": 0.0,
		"nivel": 1,
		"variable": "ninguna",
		"probabilidad": 0.5
	},
	{
		"descripcion": "Un cliente exigente se queja y baja la popularidad",
		"factor": 0.1,  # 10% de pérdida
		"nivel": 2,
		"variable": "popularidad",
		"probabilidad": 0.3
	},
	{
		"descripcion": "Una inspección detecta fallas de salubridad",
		"factor": 0.2,
		"nivel": 3,
		"variable": "dinero",
		"probabilidad": 0.2
	},
	{
		"descripcion": "Un influencer menciona el restaurante negativamente",
		"factor": 0.3,
		"nivel": 4,
		"variable": "popularidad",
		"probabilidad": 0.15
	},
	{
		"descripcion": "Clientes insatisfechos por demora, baja popularidad",
		"factor": 0.15,
		"nivel": 5,
		"variable": "popularidad",
		"probabilidad": 0.3
	},
	{
		"descripcion": "Ocurrió un robo durante la noche",
		"factor": 0.5,
		"nivel": 6,
		"variable": "dinero",
		"probabilidad": 0.2
	},
	{
		"descripcion": "Incendio menor en la cocina: pérdida de dinero",
		"factor": 0.7,
		"nivel": 7,
		"variable": "dinero",
		"probabilidad": 0.15
	},
	{
		"descripcion": "La ruleta se atascó\nHoy no podrás probar suerte",
		"factor": 0,
		"nivel": 4,
		"variable": "ruleta",
		"probabilidad": 0.25
	},
	{
		"descripcion": "Los peces han desaparecido hoy\nParece que alguien los espantó.",
		"factor": 0,
		"nivel": 4,
		"variable": "pesca",
		"probabilidad": 0.25
	},
	{
		"descripcion": "Un corte de calles impide las entregas\nEl servicio de delivery está suspendido.",
		"factor": 0,
		"nivel": 4,
		"variable": "delivery",
		"probabilidad": 0.25
	},
		{
		"descripcion": "Una plaga arruinó parte de la cosecha\nHoy no se podrá recolectar nada útil.",
		"factor": 0,
		"nivel": 4,
		"variable": "cosecha",
		"probabilidad": 0.25
	},
	{
		"descripcion": "Un inversionista quedó impresionado por tu éxito.\nTe propone abrir un restaurante en el Gran Buenos Aires.\n Fin del juego ¡Gracias por jugar!",
		"factor": 0,
		"nivel": 7,
		"variable": "FinJuego",
		"probabilidad": 1.
	}
]

func lanzar_evento():
	var nivel_actual = Globales.mesas

	# Filtrar eventos válidos
	var eventos_validos = eventos.filter(func(e): return e["nivel"] <= nivel_actual)

	if eventos_validos.is_empty():
		print("No hay eventos disponibles")
		return

	# Calcular la suma total de probabilidades
	var total_prob = 0.0
	for e in eventos_validos:
		total_prob += e["probabilidad"]

	# Normalizar: crear nueva lista con probabilidades normalizadas
	var eventos_normalizados = []
	for e in eventos_validos:
		var copia = e.duplicate()
		copia["probabilidad"] /= total_prob
		eventos_normalizados.append(copia)

	# Generar número aleatorio entre 0.0 y 1.0
	var r = randf()
	var acumulado = 0.0

	for evento in eventos_normalizados:
		acumulado += evento["probabilidad"]
		if r <= acumulado:
			_aplicar_evento(evento)
			break



func _aplicar_evento(evento):
	var nombre_var = evento["variable"]
	var factor = evento["factor"]
	$Panel/PanelNotificacion/LabelResultado.text = "⚠️ EVENTO ⚠️\n\n" + evento["descripcion"]
	if nombre_var == "popularidad":
		# Obtener progreso actual
		var progreso = Globales.reputacion_progreso
		var reduccion = int(progreso * factor)
		progreso -= reduccion

		# Si baja de 0, retrocede una categoría si se puede
		if progreso < 0:
			progreso = 100 + progreso  # el sobrante negativo se aplica al nuevo rango
			var categorias = ["D", "C", "B", "A", "S"]
			var indice = categorias.find(Globales.reputacion_categoria)
			if indice > 0:
				Globales.reputacion_categoria = categorias[indice - 1]
			else:
				progreso = 0  # ya está en el mínimo

		Globales.reputacion_progreso = progreso

		print("Popularidad reducida a: " + Globales.reputacion_categoria + " (" + str(progreso) + "%)")
		$Panel/PanelNotificacion/LabelResultado.text += "\n"+ "Popularidad reducida a: " + Globales.reputacion_categoria + " (" + str(progreso) + "%)"
	elif nombre_var == "dinero":
		var valor_actual = Globales.get(nombre_var)
		if valor_actual==0:
			$Panel/PanelNotificacion/LabelResultado.text += "\n"+ "El dinero no alcanza para cubrir el gasto\nDebes mirar un anuncio"
			anuncio=true
		else:
			var reduccion = valor_actual * factor
			Globales.set(nombre_var, valor_actual - reduccion)
			$Panel/PanelNotificacion/LabelResultado.text += "\n"+nombre_var + " reducido en " + str(reduccion)
	elif  nombre_var == "ruleta":
		DiaData.bloqueoRuleta=true
	elif  nombre_var == "pesca":
		DiaData.bloqueoPesca=true
	elif  nombre_var == "cosecha":
		DiaData.bloqueoCosecha=true
	elif  nombre_var == "delivery":
		DiaData.bloqueoDelivery=true
	elif  nombre_var == "delivery":
		DiaData.bloqueoDelivery=true
	elif nombre_var == "FinJuego":
		fin_del_juego()
func _ready():

	$Panel/FondoNoche.modulate.a = 0.0
	$Panel/FondoDia.modulate.a = 0.0
	$Panel/PanelNotificacion.modulate.a = 0.0
	$Panel/TextureRect.modulate.a = 0.0  # Fondo de fin invisible
	$Panel/TextureRect.visible = false   # Oculto al inicio

	var tween = create_tween()

	tween.tween_interval(0.5)
	tween.tween_property($Panel/FondoNoche, "modulate:a", 1.0, 2.0)


	tween.tween_interval(1.0)


	tween.tween_property($Panel/FondoNoche, "modulate:a", 0.0, 2.0)
	tween.parallel().tween_property($Panel/FondoDia, "modulate:a", 1.0, 2.0)


	tween.tween_interval(1.0)

	tween.tween_property($Panel/PanelNotificacion, "modulate:a", 1.0, 1.5)

	tween.tween_callback(lanzar_evento)



func _on_boton_confirma_pressed() -> void:
	if (anuncio):
		#LOGICA DE MOSTRAR ANUNCIO...
		Globales.dinero=0 #Se deja el dinero en balance 0
	Globales.guardar_estado()
	get_tree().change_scene_to_file("res://MenuDia.tscn")

func fin_del_juego():
	$Panel/TextureRect.visible=true
	# Asegurate de que el fondo de fin esté invisible al inicio
	$Panel/TextureRect.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property($Panel/TextureRect, "modulate:a", 1.0, 2.5)  # Fade in en 2.5 segundos

	# Podés agregar más cosas después, como un botón para continuar
