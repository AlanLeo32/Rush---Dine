extends Node2D

func _ready():
	var fondo = $Fondo  # Asegurate que el nodo se llame así

	if Globales.dia:
		fondo.texture = load("res://Fondos/FondoDia.png")
	else:
		fondo.texture = load("res://Fondos/FondoNoche.png")
	
