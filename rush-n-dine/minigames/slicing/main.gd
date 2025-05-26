extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var fruits_node = $Veggies
@onready var slash = $Slash

const FRUIT_SCENE = preload("veggie.tscn")
const ROCK_SCENE = preload("rock.tscn")

func _ready():
	print("Instancia escena main del slice")
	spawn_timer.start()

func _on_spawn_timer_timeout():
	var elem
	if randf() < 0.5:
		elem = FRUIT_SCENE.instantiate()
	else:
		elem = ROCK_SCENE.instantiate()
	fruits_node.add_child(elem)
	
func _process(delta):
	var tiempo_restante = int($MinigameTimer.time_left)
	$TimeLeftLabel.text = "%d" % tiempo_restante

func terminar_minijuego():
	var puntaje_final = slash.getPuntaje()
	
	#Guardo el resultado
	Globales.resultado_minijuego = {
		"puntaje": puntaje_final,
		"receta": Globales.receta_actual
	}
	#Volver al juego principal
	get_tree().change_scene_to_file("res://noche.tscn")


func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
