extends Control

@onready var needle = $Needle
@onready var background = $BgCircle
@onready var check_timer = $CheckTimer
@onready var success_zone = $SuccessZone
@onready var ideal_text = $IdealText

var angle = 0.0
var speed = 90.0  # grados por segundo
var rotating = false
var center = Vector2.ZERO
#var radius = 100.0  # ajustá esto al tamaño de tu círculo
var radius
var color 
var coordsCartel
var coordsArea1 = Vector2(800, 436)
var coordsArea2 = Vector2(818, 288)
var coordsArea3 = Vector2(806, 167)
var coordsArea4 = Vector2(741, 71)
var deltaGlobal = 0

func _ready():
	#center = background.global_position + background.size * 0.5
	center = background.global_position + background.size * 0.5 + Vector2(50, 80)
	#radius = min(background.size.x, background.size.y) * 0.5 - 0.0  # margen interior
	radius = 0
	ideal_text.set_global_position(coordsArea2)
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
	print(color)
	var overlapping_areas = $Needle/StaticBody2D.get_overlapping_areas()
	for area in overlapping_areas:
		print("Tocando: ", area.name)
	terminar_minijuego()
	

func terminar_minijuego():
	set_process_input(false)
	# Esperar 2 segundos antes de cerrar
	await get_tree().create_timer(2.0).timeout
	queue_free()  # cierra la escena del minijuego
	get_tree().current_scene.get_node("Jugador").set_process(true)

func _on_CheckTimer_timeout():
	rotating = false
	check_success()
