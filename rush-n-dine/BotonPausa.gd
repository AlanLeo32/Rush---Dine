extends CanvasLayer

@onready var boton := $BotonPausa

var textura_pausa := preload("res://Sprites/BotonPausa.png")
var textura_play := preload("res://Sprites/BotonDesapausar.png")

func _ready():
	# Asegurarse de que la señal no esté ya conectada
	if boton.pressed.is_connected(_on_texture_button_pressed):
		boton.pressed.disconnect(_on_texture_button_pressed)  # Desconectar la señal previamente conectada
	
	# Conectar la señal correctamente
	boton.pressed.connect(_on_texture_button_pressed)
	
	# Asignamos la textura inicial
	boton.texture_normal = textura_pausa  # La imagen inicial de "Pausa"

func _on_texture_button_pressed():
	print("Botón presionado")
	
	# Alternar el estado de pausa
	get_tree().paused = not get_tree().paused
	
	# Cambiar la textura dependiendo del estado de pausa
	if get_tree().paused:
		print("Juego pausado")
		boton.texture_normal = textura_play  # Cambiar a la textura de "Despausar"
	else:
		print("Juego despausado")
		boton.texture_normal = textura_pausa  # Cambiar a la textura de "Pausa"

# Detectar entradas globales (teclado, ratón)
func _input(event: InputEvent):
	if get_tree().paused:
		# Si el juego está pausado, ignoramos la entrada
		return
	
	# Si no está pausado, procesamos la entrada normalmente
	if event is InputEventKey:
		if event.pressed:
			print("Tecla presionada: " + str(event.keycode))  # Usar keycode en lugar de scancode
	
	elif event is InputEventMouseButton:
		if event.pressed:
			print("Botón de ratón presionado: " + str(event.button_index))
