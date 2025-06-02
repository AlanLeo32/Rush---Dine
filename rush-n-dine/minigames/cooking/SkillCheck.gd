extends Control

@onready var needle = $Needle
@onready var background = $BgCircle
@onready var check_timer = $CheckTimer
@onready var success_zone = $SuccessZone
@onready var ideal_text = $IdealText

var angle = 0.0
var speed = 10.0 # grados por segundo
var rotating = false
var center = Vector2.ZERO
#var radius = 100.0  # ajustá esto al tamaño de tu círculo
var radius
var color 
var coordsCartel = [Vector2(1336, 720), Vector2(1389, 483), Vector2(1376, 272), Vector2(1295, 127)]
var pos_text = Vector2.ZERO
var deltaGlobal = 0

func _ready():
	#center = background.global_position + background.size * 0.5
	center = background.global_position + background.size * 0.5 + Vector2(50, 80)
	#radius = min(background.size.x, background.size.y) * 0.5 - 0.0  # margen interior
	radius = 0
	#var coccion = Globales.receta_actual["coccion"]
	var coccion = 1 # ESTO ESTA HARDCODEADO PARA PROBAR CORRIENDO SOLO ESTA ESCENA, USAR LA LINEA DE ARRIBA
	pos_text = coordsCartel[coccion-1]
	ideal_text.set_global_position(pos_text)
	start_skill_check()
	

func _process(delta):
	deltaGlobal = deltaGlobal + delta
	if (rotating) and (deltaGlobal > 0.16):
		angle += speed * (delta * 5)
		angle = fmod(angle, 360.0)
		update_needle_position()
		deltaGlobal = 0




func update_needle_position():
	var angle_rad = -deg_to_rad(angle)
	#var needle_pos = (center + Vector2(cos(angle_rad), sin(angle_rad)) * radius)
	#needle.global_position = needle_pos - needle.size * 0.5
	needle.rotation = (angle_rad + PI / 2 + deg_to_rad(15)) # 15 = +15 grados clockwise

func start_skill_check():
	angle = randf_range(0, 360)
	rotating = true
	check_timer.start(5.0)

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
	#terminar_minijuego()

func calcular_puntaje():
	var puntaje_final
	#calcular en base a la lejania de la zona de coccion objetivo

func terminar_minijuego():
	print('fin minijuego skillcheck')
	Globales.logica_siguiente_minijuego()

func _on_CheckTimer_timeout():
	rotating = false
	check_success()
