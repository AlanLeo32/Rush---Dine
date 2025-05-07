extends Area2D

# Variables para el movimiento
var vel = Vector2.ZERO
var grav = 500

# Tiempo de reaparición
const RESPAWN_TIME = 2.0

func _ready():
	# Inicializa la velocidad con un valor aleatorio
	reset_fruit()

func _process(delta):
	# Aplica la gravedad
	vel.y += grav * delta
	# Actualiza la posición
	position += vel * delta
	
	# Destruye la fruta si sale de la pantalla
	if position.y > get_viewport_rect().size.y:
		queue_free()
		respawn_fruit()

func reset_fruit():
	# Reposiciona la fruta en un lugar aleatorio en la parte superior
	position = Vector2(randf_range(50, get_viewport_rect().size.x - 50), -50)
	vel = Vector2(randf_range(-200, 200), randf_range(-600, -400))

func respawn_fruit():
	# Reaparece después de RESPAWN_TIME segundos
	await get_tree().create_timer(RESPAWN_TIME).timeout
	var new_fruit = preload("res://minigames/cuttingFruits/fruits.tscn").instantiate()
	new_fruit.reset_fruit()
	get_parent().add_child(new_fruit)

func cut():
	# Lógica cuando la fruta es cortada
	$Sprite.texture = load("res://data/circle.png")
	queue_free()  # Remueve la fruta después de un breve tiempo
