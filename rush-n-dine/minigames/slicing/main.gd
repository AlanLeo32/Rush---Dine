extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var fruits_node = $Veggies
@onready var slash = $Slash
var ings
var cant

const VEGETAL_SCENE = preload("veggie.tscn")
const ROCK_SCENE = preload("rock.tscn")

func _ready():
	print("Instancia escena main del slice")
	#aca habria que hacer la logica que elige los INGREDIENTES del PLATO a CORTAR
	ings = ['tomate', 'pepino'] #plato pescado
	spawn_timer.start()
	cant = 0

func _on_spawn_timer_timeout():
	var elem
	if randf() < 0.75:
		elem = VEGETAL_SCENE.instantiate()
		elem.setVegetal(ings[cant%len(ings)]) #itera entre los elementos de la lista de ingredientes
		cant+=1
	else:
		elem = ROCK_SCENE.instantiate()
	var x_local = randi_range(700, 1200)
	var y_local = 600
	elem.position = Vector2(x_local, y_local)
	#print("Spawnea en:", elem.position)
	fruits_node.add_child(elem)
	
func _process(delta):
	var tiempo_restante = int($MinigameTimer.time_left)
	$TimeLeftLabel.text = "%d" % tiempo_restante


func terminar_minijuego():
	var puntos: float
	if cant > 0:
		puntos = float(slash.getPuntaje()+1) / cant
	else:
		puntos = 1 - slash.getPuntaje()
		
	var puntaje_final = int(puntos * 5)
	if puntaje_final < 0:
		puntaje_final = 0
	elif puntaje_final > 5:
		puntaje_final = 5
	
	print("puntaje de cortar: " , puntaje_final)
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
	if noche and noche.has_node("Camera2D"):
		var cam_noche = noche.get_node("Camera2D")
		if cam_noche is Camera2D:
			cam_noche.make_current()
	set_process_input(false)
	set_process(false)
	# Si el minijuego debe eliminarse:
	queue_free()
	# Limpia cualquier focus de control (por si hay nodos Control con focus)
	if get_viewport().gui_get_focus_owner():
		get_viewport().gui_get_focus_owner().release_focus()

	# Libera cualquier captura de mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.action_release("ui_select") # Si usás "ui_select" para drag
	ManejoMinijuegos.logica_siguiente_minijuego()


func _on_minigame_timer_timeout() -> void:
	terminar_minijuego()
