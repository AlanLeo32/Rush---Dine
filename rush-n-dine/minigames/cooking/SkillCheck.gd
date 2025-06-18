extends Control

@onready var needle = $Needle
@onready var background = $BgCircle
@onready var check_timer = $CheckTimer
@onready var success_zone = $SuccessZone
@onready var ideal_text = $IdealText

var angle = 0
var speed = 30.0 # grados por segundo
var rotating = false
var center = Vector2.ZERO
#var radius = 100.0  # ajustá esto al tamaño de tu círculo
var radius
var color 
var coordsCartel = [Vector2(1336, 720), Vector2(1389, 483), Vector2(1376, 272), Vector2(1295, 127)]
var pos_text = Vector2.ZERO
var deltaGlobal = 0
var coccion

func _ready():
	#center = background.global_position + background.size * 0.5
	center = background.global_position + background.size * 0.5 + Vector2(50, 80)
	#radius = min(background.size.x, background.size.y) * 0.5 - 0.0  # margen interior
	radius = 0
	#coccion = 1 # ESTO ESTA HARDCODEADO PARA PROBAR CORRIENDO SOLO ESTA ESCENA, USAR LA LINEA DE ABAJO
	coccion = ManejoMinijuegos.receta_actual["coccion"]
	pos_text = coordsCartel[coccion-1]
	ideal_text.set_global_position(pos_text)
	start_skill_check()
	

func _process(delta):
	$TimeLeftLabel.text = str(int($Minijuego_timer.time_left))
	deltaGlobal = deltaGlobal + delta
	speed += delta * 50
	if (rotating) and (deltaGlobal > 0.16):
		angle += speed * (delta * 5)
		angle = fmod(angle, 360.0)
		update_needle_position()
		deltaGlobal = 0




func update_needle_position():
	var angle_rad = -deg_to_rad(angle)
	#var needle_pos = (center + Vector2(cos(angle_rad), sin(angle_rad)) * radius)
	#needle.global_position = needle_pos - needle.size * 0.5
	#needle.rotation = (angle_rad + PI / 2 + deg_to_rad(15)) # 15 = +15 grados clockwise
	needle.rotation = angle_rad

func start_skill_check():
	angle = 0
	rotating = true

func _input(event):
	#if event.is_action_pressed("ui_accept") and rotating:
	if (event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT): #click de mouse, para test
		if rotating:
			rotating = false
			check_success()

func check_success():
	var area_resultado
	var overlapping_areas = $Needle/StaticBody2D.get_overlapping_areas()
	for area in overlapping_areas:
		print("Tocando: ", area.name)
		area_resultado = int(area.name.substr(4))
		print(area_resultado)
	calcular_puntaje(area_resultado)

func calcular_puntaje(area_resultado):
	var puntaje_final
	#calcular en base a la lejania de la zona de coccion objetivo
	if !area_resultado:
		area_resultado = 0
	var diferencia = abs(coccion - area_resultado)

	if diferencia == 0:
		puntaje_final = 5
	elif diferencia == 1:
		puntaje_final = 3
	else:
		puntaje_final = 1
	
	
	if not ManejoMinijuegos.resultado_minijuego.has("puntaje"):
		ManejoMinijuegos.resultado_minijuego["puntaje"] = 0
	if not ManejoMinijuegos.resultado_minijuego.has("receta"):
		ManejoMinijuegos.resultado_minijuego["receta"] = ManejoMinijuegos.receta_actual
	var puntaje_anterior = ManejoMinijuegos.resultado_minijuego["puntaje"]
	ManejoMinijuegos.resultado_minijuego = {
		"puntaje": puntaje_final + puntaje_anterior,
		"receta": ManejoMinijuegos.receta_actual
	}
	terminar_minijuego()
	

func terminar_minijuego():
	print('fin minijuego skillcheck')
	# Activa la cámara de la noche si existe
	 # Oculta el cartel ideal si existe
	if has_node("IdealText"):
		$IdealText.visible = false
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



func _on_minijuego_timer_timeout() -> void:
	rotating = false
	print("¡Tiempo terminado!")
	
	check_success()
