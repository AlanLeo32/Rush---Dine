extends Node2D

@onready var nodo_ing = $ingredientes
@onready var plato_final= $plato/plato_final

var timer_listo = false
const ING_SCENE = preload("res://minigames/ordenar/ingrediente.tscn")

func _ready():
	print("Instancia escena main del ordenar...")
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
	nodo_ing.add_child(elem)
	
	elem = ING_SCENE.instantiate()
	elem.setTexture('dish-pescado/pescado-naranja', 1)
	nodo_ing.add_child(elem)
	
	elem = ING_SCENE.instantiate()
	elem.setTexture('dish-pescado/tomate-slice', 0.4)
	nodo_ing.add_child(elem)
	
	for i in range(3):
		elem = ING_SCENE.instantiate()
		elem.setTexture('dish-pescado/pepino-slice', 0.4)
		nodo_ing.add_child(elem)


func terminar_minijuego():
	
	#Guardo el resultado
	#Globales.resultado_minijuego = {
	#	"puntaje": puntaje_final,
	#	"receta": Globales.receta_actual
	#}
	#Volver al juego principal
	print('fin minijuego ordenar')
	#get_tree().change_scene_to_file("res://noche.tscn")


func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
