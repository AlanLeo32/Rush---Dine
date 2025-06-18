extends Node2D

signal recolectado_roca

var velocity = Vector2.ZERO
var speed: int # píxeles por segundo cuadrado

func _ready():
	var rng := RandomNumberGenerator.new()
	
	
	# start pos
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var pos_y = 0 
	position = Vector2(random_x, pos_y)
	
	speed = randi_range(300, 450)
	
func _process(delta):
	position += Vector2(0, 1.0) * speed * delta   # movemos la fruta con "gravedad"



func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		emit_signal("recolectado_roca")
		queue_free()
