extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var fruits_node = $Veggies

const FRUIT_SCENE = preload("veggie.tscn")

func _ready():
	spawn_timer.start()

func _on_spawn_timer_timeout():
	var fruit = FRUIT_SCENE.instantiate()
	fruits_node.add_child(fruit)
