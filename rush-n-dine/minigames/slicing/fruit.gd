extends RigidBody2D

@onready var area = $Area2D

func _ready():
	var impulse = Vector2(randf_range(-200, 200), randf_range(-700, -800))
	apply_impulse(Vector2.ZERO, impulse)
	area.connect("area_entered", _on_area_entered)

func _on_area_entered(other_area):
	print("Colisión con:", other_area.name)
	if other_area.name == "SlashArea":
		queue_free() # cortar la fruta
