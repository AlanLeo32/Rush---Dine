extends CharacterBody2D

@export var velocidad := 500.0
@onready var anim = $AnimatedSprite2D
@export var horno: NodePath

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var horno_node = get_node(horno)
		if horno_node.jugador_en_rango:
			abrir_minijuego()

func abrir_minijuego():
	var minijuego = load("res://minigames/cooking/SkillCheck.tscn").instantiate()
	
	# Buscamos el UI desde el árbol global
	var ui = get_tree().current_scene.get_node("CanvasLayer/UI/MinigameContainer")
	# Opcional: limpiar el UI si ya hay algo cargado
	ui.add_child(minijuego)
	
	get_tree().current_scene.add_child(minijuego)
	self.set_process(false)  # opcional: desactiva movimiento del jugador

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
