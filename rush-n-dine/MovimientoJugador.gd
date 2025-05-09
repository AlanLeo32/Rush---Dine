extends CharacterBody2D

@export var velocidad := 500.0
@onready var anim = $AnimatedSprite2D
@onready var boton_interactuar := $"../CanvasLayer/Interactuar"

var touch_start_position := Vector2.ZERO
var dragging := false
var direccion_joystick := Vector2.ZERO

var objeto_actual: Area2D = null
var interactuables_actuales := []
func _ready():
	boton_interactuar.visible = false

func _physics_process(delta):
	# Si el juego está pausado, no procesamos el movimiento
	if get_tree().paused:
		return
	#var direccion = Vector2.ZERO 
	var direccion = direccion_joystick
	#para mover con flechas
	#direccion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#direccion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = direccion.normalized() * velocidad
	move_and_slide()

	# Reproducir la animación correspondiente
	if direccion != Vector2.ZERO:
		if abs(direccion.x) > abs(direccion.y):
			if direccion.x > 0:
				anim.play("Caminar Derecha")
			else:
				anim.play("Caminar Izquierda")
		else:
			if direccion.y > 0:
				anim.play("Caminar Adelante")
			else:
				anim.play("Caminar Atras")
	else:
		# Animación en estado quieto según última dirección
		var actual = anim.animation
		if actual == "Caminar Adelante":
			anim.play("Parado Frente")
		elif actual == "Caminar Atras":
			anim.play("Parado Detras")
		elif actual == "Caminar Derecha":
			anim.play("Parada Derecha")
		elif actual == "Caminar Izquierda":
			anim.play("Parada Izquierda")
			
			
func _process(_delta):
	$AnimatedSprite2D.z_index = int(global_position.y)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("interactuar") and not interactuables_actuales.has(area):
		interactuables_actuales.append(area)
		objeto_actual = area  # tomamos el último ingresado
		boton_interactuar.visible = true

func _on_area_exited(area):
	if interactuables_actuales.has(area):
		interactuables_actuales.erase(area)
	# Si el área saliente es el tacho y está abierto, lo cerramos
		if area.name == "Tacho" and area.abierto:
			area.interactuar()
	if interactuables_actuales.is_empty():
		objeto_actual = null
		boton_interactuar.visible = false
	else:
		objeto_actual = interactuables_actuales[-1]  # tomá el último que queda



func _on_interactuar_pressed() -> void:
	if objeto_actual:
		objeto_actual.interactuar()
		
#esta solo usar para simular deslizamiento con gesto con mouse
func _unhandled_input(event):
	if OS.has_feature("pc"):  # Solo en PC
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				touch_start_position = event.position
				dragging = true
			else:
				dragging = false
				direccion_joystick = Vector2.ZERO
		elif event is InputEventMouseMotion and dragging:
			var drag_vector = event.position - touch_start_position
			if drag_vector.length() > 10:
				direccion_joystick = drag_vector.normalized()
			else:
				direccion_joystick = Vector2.ZERO
	else:
		# Esto sigue siendo válido para móviles
		if event is InputEventScreenTouch:
			if event.pressed:
				touch_start_position = event.position
				dragging = true
			else:
				dragging = false
				direccion_joystick = Vector2.ZERO

		elif event is InputEventScreenDrag and dragging:
			var drag_vector = event.position - touch_start_position
			if drag_vector.length() > 10:
				direccion_joystick = drag_vector.normalized()
			else:
				direccion_joystick = Vector2.ZERO
#esta es la funcion que va para el cel
#func _unhandled_input(event):
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			touch_start_position = event.position
#			dragging = true
#		else:
#			dragging = false
#			direccion_joystick = Vector2.ZERO
#	
#	elif event is InputEventScreenDrag and dragging:
#		var drag_vector = event.position - touch_start_position
#		if drag_vector.length() > 10:
#			direccion_joystick = drag_vector.normalized()
#		else:
#			direccion_joystick = Vector2.ZERO
