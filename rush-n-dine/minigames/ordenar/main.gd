extends Node2D

@onready var nodo_ing = $ingredientes
@onready var plato_final= $plato/plato_final

var timer_listo = false
const ING_SCENE = preload("res://minigames/ordenar/ingrediente.tscn")
var ubi_elem = []
var ing_repetible = []
var platoEs = ""
var tiempo_primer_etapa

func _ready():
	print("Instancia escena main del ordenar...")
	ing_repetible = []
	var tiempo_timer = 20 - (ManejoMinijuegos.dificultad*6) # Arranca en 2 - 1 y va hasta 2 - 1.6
	$MinigameTimer.start(tiempo_timer)
	tiempo_primer_etapa = 15 - (ManejoMinijuegos.dificultad*6)
	#aca habria que hacer la logica que elige el PLATO A ORDENAR
	dish_pescado()

	
func _process(delta):
	var tiempo_restante = int($MinigameTimer.time_left)
	$TimeLeftLabel.text = "%d" % tiempo_restante
	$CountdownLabel.text = "%d" % (tiempo_restante-tiempo_primer_etapa)
	if tiempo_restante>tiempo_primer_etapa:
		$TimeLeftLabel.visible = false
		$CountdownLabel.visible = true
	else:
		timer_listo = true
		$TimeLeftLabel.visible = true
		$CountdownLabel.visible = false

func dish_pescado():
	print('Preparando plato pescado...')
	platoEs= "pescado"
	plato_final.texture = load("res://Sprites/dish-pescado/final.png")
	plato_final.scale= Vector2(2.1, 2.1)
	plato_final.visible = true
	while (!timer_listo):
		await get_tree().create_timer(0.2).timeout
	plato_final.visible = false
	var elem
	elem = ING_SCENE.instantiate()
	elem.setTexture('dish-pescado/lechuga', 2)
	elem.name = "lechuga"
	nodo_ing.add_child(elem)
	
	elem = ING_SCENE.instantiate()
	elem.setTexture('dish-pescado/pescado-naranja', 1)
	elem.name = "pescado"
	nodo_ing.add_child(elem)
	
	elem = ING_SCENE.instantiate()
	elem.setTexture('dish-pescado/tomate-slice', 0.4)
	elem.name = "tomate"
	nodo_ing.add_child(elem)
	
	for i in range(3):
		elem = ING_SCENE.instantiate()
		elem.setTexture('dish-pescado/pepino-slice', 0.4)
		elem.name = "pepino"+ str(i+1)
		ing_repetible.append(elem.name)
		nodo_ing.add_child(elem)

func soltar_todos_los_ingredientes():
	for ingrediente in nodo_ing.get_children():
		if ingrediente.has_method("soltar"):
			ingrediente.soltar()
func terminar_minijuego():
	
	#Guardo el resultado
	#Globales.resultado_minijuego = {
	#	"puntaje": puntaje_final,
	#	"receta": Globales.receta_actual
	#}
	#Volver al juego principal
	print('fin minijuego ordenar')
	soltar_todos_los_ingredientes()
	calcular_puntaje_final()
	# Activa la cámara de la noche si existe
	var noche = get_tree().get_root().get_node_or_null("Noche")
	if noche and noche.has_node("Camera2D"):
		var cam_noche = noche.get_node("Camera2D")
		if cam_noche is Camera2D:
			cam_noche.make_current()
	# Desactiva input del minijuego
	set_process_input(false)
	set_process(false)
	# Limpia cualquier focus de control (por si hay nodos Control con focus)
	if get_viewport().gui_get_focus_owner():
		get_viewport().gui_get_focus_owner().release_focus()

	# Libera cualquier captura de mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.action_release("ui_select") # Si usás "ui_select" para drag
	ManejoMinijuegos.logica_siguiente_minijuego()


func calcular_puntaje_final():
	var puntaje_total = 0
	var ingredientes_colocados = nodo_ing.get_children()
	var posiciones_ideales_pescado = ManejoMinijuegos.receta_actual["ubi_ing"] # devuelve diccionario con "lechuga": Vector2(292.1, 174.9),

	var puntos = 0
	for ingrediente_node in ingredientes_colocados:
		var posicion_ingrediente_colocado = ingrediente_node.global_position 
		var nombre_ingrediente = ingrediente_node.name
		var distancia
		if nombre_ingrediente == "Sprite2D":
			distancia = 999
		else:
			distancia = calcular_distancia(posicion_ingrediente_colocado,nombre_ingrediente , posiciones_ideales_pescado)
		if distancia:
			print(distancia)
			if distancia < 25:  # Si está cerca de la posición ideal
				puntos += 20  # Puntaje por colocar el ingrediente en la posición correcta
			elif distancia < 50:
				puntos += 10  # Penalización por estar lejos de la posición ideal
			elif distancia < 100:
				puntos += 5
		
	if platoEs == "pescado":
		if puntos == 120:
			puntaje_total = 5
		elif puntos >= 90:
			puntaje_total = 4
		elif puntos >= 60:
			puntaje_total = 3
		elif puntos >= 40:
			puntaje_total = 2
		elif puntos >= 20:
			puntaje_total = 1
		else:
			puntaje_total = 0
			
	print("puntaje de ordenar: " , puntaje_total)
	
	if not ManejoMinijuegos.resultado_minijuego.has("puntaje"):
		ManejoMinijuegos.resultado_minijuego["puntaje"] = 0
	if not ManejoMinijuegos.resultado_minijuego.has("receta"):
		ManejoMinijuegos.resultado_minijuego["receta"] = ManejoMinijuegos.receta_actual
	var puntaje_anterior = ManejoMinijuegos.resultado_minijuego["puntaje"]
	# ACTUALIZO el resultado, ya que no puedo saber
	# Si hubo otro minijuego antes de este o no
	ManejoMinijuegos.resultado_minijuego = {
		"puntaje": puntaje_total + puntaje_anterior,
		"receta": ManejoMinijuegos.receta_actual
	}
	   
	

func calcular_distancia(posicion_ingrediente_colocado,nombre_ingrediente, posiciones_ideales_pescado):
	var posicion_ideal
	var mejor_dist
	if !ing_repetible.has(nombre_ingrediente):
		posicion_ideal = posiciones_ideales_pescado.get(nombre_ingrediente, null)  
		mejor_dist = posicion_ideal.distance_to(posicion_ingrediente_colocado)
		#print("NOMBRE ING: ", nombre_ingrediente, "POS_IDEAL: ", posicion_ideal, "POS REAL: ", posicion_ingrediente_colocado)
	else:
		#print("entralelse")
		mejor_dist = 99999
		for repe in ing_repetible:
			posicion_ideal = posiciones_ideales_pescado.get(repe, null)
			if mejor_dist > posicion_ideal.distance_to(posicion_ingrediente_colocado):
				mejor_dist = posicion_ideal.distance_to(posicion_ingrediente_colocado)
	return mejor_dist
		

	
	

func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
