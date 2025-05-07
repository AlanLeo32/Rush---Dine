extends Area2D

var jugador_en_rango = false

func _on_body_entered(body):
	if body.name == "Jugador":
		jugador_en_rango = true


func on_body_exited(body):
	if body.name == "Jugador":
		jugador_en_rango = false
