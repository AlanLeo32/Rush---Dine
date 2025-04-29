extends Control

var estados = ["C","Ca","Car","Carg","Carga","Cargan","Cargand","Cargando", "Cargando.", "Cargando..", "Cargando...",""]
var indice = 0

@onready var label = $Texto_cargando # Asegurate que el nombre coincida

func _ready():
	# Crear un temporizador
	var timer = Timer.new()
	timer.wait_time = 0.25
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
func _on_timer_timeout():
	label.text = estados[indice]
	indice = (indice + 1) % estados.size()
