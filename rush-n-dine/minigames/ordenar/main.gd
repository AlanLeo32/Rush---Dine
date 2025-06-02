extends Node2D

@onready var nodo_ing = $ingredientes
@onready var plato_final= $plato/plato_final

var timer_listo = false
const ING_SCENE = preload("res://minigames/ordenar/ingrediente.tscn")
var ubi_elem = []
var ing_repetible = []

func _ready():
	print("Instancia escena main del ordenar...")
	ing_repetible = []
	#aca habria que hacer la logica que elige el PLATO A ORDENAR
	dish_pescado()

	
func _process(delta):
	var tiempo_restante = int($MinigameTimer.time_left)
	$TimeLeftLabel.text = "%d" % tiempo_restante
	$CountdownLabel.text = "%d" % (tiempo_restante-10)
	if tiempo_restante>10:
		$TimeLeftLabel.visible = false
		$CountdownLabel.visible = true
	else:
		timer_listo = true
		$TimeLeftLabel.visible = true
		$CountdownLabel.visible = false

func dish_pescado():
	print('Preparando plato pescado...')
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


func terminar_minijuego():
	
	#Guardo el resultado
	#Globales.resultado_minijuego = {
	#	"puntaje": puntaje_final,
	#	"receta": Globales.receta_actual
	#}
	#Volver al juego principal
	print('fin minijuego ordenar')
	calcular_puntaje_final()
	#Globales.logica_siguiente_minijuego()
	#get_tree().change_scene_to_file("res://noche.tscn")

func calcular_puntaje_final():
	var puntaje_total = 0
	var ingredientes_colocados = nodo_ing.get_children()
	Globales.receta_actual = Globales.recetas_desbloqueadas["pescado_asado1"]
	var posiciones_ideales_pescado = Globales.receta_actual["ubi_ing"] # devuelve diccionario con "lechuga": Vector2(292.1, 174.9),

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
				puntaje_total += 20  # Puntaje por colocar el ingrediente en la posición correcta
			elif distancia < 50:
				puntaje_total += 10  # Penalización por estar lejos de la posición ideal
			elif distancia < 100:
				puntaje_total += 5
		
		var puntaje_anterior = Globales.resultado_minijuego["puntaje"]
		# ACTUALIZO el resultado, ya que no puedo saber
		# Si hubo otro minijuego antes de este o no
		Globales.resultado_minijuego = {
			"puntaje": puntaje_total + puntaje_anterior,
			"receta": Globales.receta_actual
		}
	   
	

func calcular_distancia(posicion_ingrediente_colocado,nombre_ingrediente, posiciones_ideales_pescado):
	var posicion_ideal
	var mejor_dist
	if !ing_repetible.has(nombre_ingrediente):
		posicion_ideal = posiciones_ideales_pescado.get(nombre_ingrediente, null)  
		mejor_dist = posicion_ideal.distance_to(posicion_ingrediente_colocado)
	else:
		print("entralelse")
		mejor_dist = 99999
		for repe in ing_repetible:
			posicion_ideal = posiciones_ideales_pescado.get(repe, null)
			if mejor_dist > posicion_ideal.distance_to(posicion_ingrediente_colocado):
				mejor_dist = posicion_ideal.distance_to(posicion_ingrediente_colocado)
	return mejor_dist
		

	
	

func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
