extends Panel

@onready var imagen = $ImagenReceta
@onready var jugador = get_tree().get_root().get_node("Noche/CharacterBodyCocinero2D")

func _process(_delta):
	if jugador.objeto_en_mano!=null:
		var receta = jugador.objeto_en_mano.receta
		imagen.texture = receta["imagen"]
		imagen.visible = true
	else:
		imagen.texture = null
		imagen.visible = false
