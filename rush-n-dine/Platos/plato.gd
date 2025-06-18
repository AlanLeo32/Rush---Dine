extends Node2D

var receta = null
var clave = ""  
var precio = 0
var entregaerronea:bool=false

func cambia_imagen():
	if entregaerronea:
		$Sprite.texture = receta.imagenquemado
	else:
		$Sprite.texture = receta.imagen
		
