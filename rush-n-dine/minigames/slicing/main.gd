extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var fruits_node = $Veggies

const FRUIT_SCENE = preload("Fruit.tscn")

func _ready():
	spawn_timer.start()

func _on_spawn_timer_timeout():
	var fruit = FRUIT_SCENE.instantiate()
	fruit.global_position = Vector2(randi_range(100, 700), 600)
	fruits_node.add_child(fruit)
