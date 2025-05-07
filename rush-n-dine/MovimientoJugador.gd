extends CharacterBody2D

@export var velocidad := 500.0
@onready var anim = $AnimatedSprite2D
@onready var boton_interactuar := $"../CanvasLayer/Interactuar"
var objeto_actual: Area2D = null
var interactuables_actuales := []

func _physics_process(delta):
	var direccion = Vector2.ZERO
	direccion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direccion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

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

	if interactuables_actuales.is_empty():
		objeto_actual = null
		boton_interactuar.visible = false
	else:
		objeto_actual = interactuables_actuales[-1]  # tomá el último que queda



func _on_interactuar_pressed() -> void:
	if objeto_actual:
		objeto_actual.interactuar()
