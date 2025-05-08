extends Area2D

@onready var sprite := $Tacho2D
var abierto := false

func interactuar():
	print("Usando el tacho...")
	if abierto:
		sprite.texture = preload("res://Sprites/tachoCerrado.png")
		abierto = false
	else:
		sprite.texture = preload("res://sprites/tachoAbierto.png")
		abierto = true
