extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var fruits_node = $Veggies
@onready var slash = $Slash
var ings
var aux

const VEGETAL_SCENE = preload("veggie.tscn")
const ROCK_SCENE = preload("rock.tscn")

func _ready():
	print("Instancia escena main del slice")
	#aca habria que hacer la logica que elige los INGREDIENTES del PLATO a CORTAR
	ings = ['tomate', 'pepino'] #plato pescado
	spawn_timer.start()
	aux = 0

func _on_spawn_timer_timeout():
	var elem
	if randf() < 0.75:
		elem = VEGETAL_SCENE.instantiate()
		elem.setVegetal(ings[aux%len(ings)]) #itera entre los elementos de la lista de ingredientes
		aux+=1
	else:
		elem = ROCK_SCENE.instantiate()
	var x_local = randi_range(700, 1200)
	var y_local = 600
	elem.position = Vector2(x_local, y_local)
	print("Spawnea en:", elem.position)
	fruits_node.add_child(elem)
	
func _process(delta):
	var tiempo_restante = int($MinigameTimer.time_left)
	$TimeLeftLabel.text = "%d" % tiempo_restante


func terminar_minijuego():
	var puntaje_final = slash.getPuntaje()
	# ACTUALIZO el resultado, ya que no puedo saber
	# Si hubo otro minijuego antes de este o no
	if not ManejoMinijuegos.resultado_minijuego.has("puntaje"):
		ManejoMinijuegos.resultado_minijuego["puntaje"] = 0
	if not ManejoMinijuegos.resultado_minijuego.has("receta"):
		ManejoMinijuegos.resultado_minijuego["receta"] = ManejoMinijuegos.receta_actual
	var puntaje_anterior = ManejoMinijuegos.resultado_minijuego["puntaje"]
	print("Termina minijuego. Puntaje:", puntaje_final, "Puntaje anterior:", puntaje_anterior)
	ManejoMinijuegos.resultado_minijuego = {
		"puntaje": puntaje_final + puntaje_anterior,
		"receta": ManejoMinijuegos.receta_actual
	}
	# Oculta el overlay y desbloquea el cocinero
	var noche = get_tree().get_root().get_node("Noche")
	if noche and noche.has_node("OverlayMinijuegos"):
		var overlay = noche.get_node("OverlayMinijuegos")
		overlay.get_node("FondoOscuro").visible = false
		overlay.get_node("ContenedorMinijuego").visible = false
		noche.set("bloquear_cocinero", false)   
	print("Llamando a logica_siguiente_minijuego")

	# Si el minijuego debe eliminarse:
	queue_free()
	ManejoMinijuegos.logica_siguiente_minijuego()


func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
