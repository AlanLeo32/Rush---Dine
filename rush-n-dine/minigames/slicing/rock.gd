extends RigidBody2D

@onready var area = $"."
var cortandose = false

func _ready():
	var impulse
	var ejex = randi_range(100, 1800)
	position = Vector2(ejex, 800)
	if ejex>900:
		impulse = Vector2(randf_range(-400, -700) * (0.5+ManejoMinijuegos.dificultad*0.5), randf_range(-920, -740) * (0.5+ManejoMinijuegos.dificultad*0.5))
	else:
		impulse = Vector2(randf_range(400, 720) * (0.5+ManejoMinijuegos.dificultad*0.5), randf_range(-920, -740) * (0.5+ManejoMinijuegos.dificultad*0.5))
	print(impulse)
	apply_impulse(impulse)
	add_to_group("Roca")
	#$Area2D.connect("area_entered", _on_area_entered)

func cortando():
	return cortandose
	
func cortar():
	cortandose = true

#func _on_area_entered(other_area):
#	print("Colisión con:", other_area.name)
#	if other_area.name == "SlashArea":
#		queue_free() # cortar la fruta
