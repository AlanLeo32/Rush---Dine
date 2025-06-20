extends RigidBody2D

@onready var area = $"."
var cortandose = false

func _ready():
	var impulse
	var ejex = randi_range(100, 1800)
	position = Vector2(ejex, 800)
	if ejex>900:
		impulse = Vector2(randf_range(-400, -700) * (0.5+ManejoMinijuegos.dificultad*0.5), randf_range(-920, -740)* (0.5+ManejoMinijuegos.dificultad*0.5))
		add_constant_torque(-10000)
	else:
		impulse = Vector2(randf_range(400, 720) * (0.5+ManejoMinijuegos.dificultad*0.5), randf_range(-920, -740) * (0.5+ManejoMinijuegos.dificultad*0.5))
		add_constant_torque(10000)
	#print(impulse)
	apply_impulse(impulse)
	add_to_group("Fruta")

	# Buscar la cámara del minijuego subiendo hasta el nodo Main
	var main = get_parent()
	while main and not main.has_node("Camera2D"):
		main = main.get_parent()
	var cam = null
	if main:
		cam = main.get_node_or_null("Camera2D")
	if cam:
		print("Fruta global:", global_position, " - Cámara global:", cam.global_position)
	else:
		print("Fruta global:", global_position, " - Cámara del minijuego NO encontrada")
func setVegetal(png):
	$FullSprite.texture = load("res://Sprites/veggies/" + png + '.png')
	var colision = get_node_or_null(png)
	if colision and colision is CollisionPolygon2D:
		colision.disabled = false
	else:
		push_warning("No se encontró un CollisionPolygon2D con el nombre: %s" % png)

func cortando():
	return cortandose
	
func cortar():
	cortandose = true

#func _on_area_entered(other_area):
#	print("Colisión con:", other_area.name)
#	if other_area.name == "SlashArea":
#		queue_free() # cortar la fruta
