extends CanvasLayer

@onready var boton := $LogicaPausa/BotonPausa
@onready var boton_config := $MenuPausa/VBoxContainer/Configuracion
@onready var boton_menu_principal := $MenuPausa/VBoxContainer/MenuPrincipal
@onready var menu_pausa := $MenuPausa
@onready var icono :=boton
@onready var fondo_opaco := $fondoMenu
var textura_pausa := preload("res://Sprites/BotonPausa.png")
var textura_play := preload("res://Sprites/BotonDesapausar.png")



func _ready():
	menu_pausa.visible = false  # Asegura que el menú no se vea al inicio
	# Asignamos la textura inicial
	boton_config.disabled = false
	boton_menu_principal.disabled = false
	# Aseguramos la textura inicial del ícono
	icono.texture_normal = textura_pausa
	if not boton.pressed.is_connected(_on_logica_pausa_pressed):
		boton.pressed.connect(_on_logica_pausa_pressed)




# Detectar entradas globales (teclado, ratón)
func _input(event: InputEvent):
	#if get_tree().paused:
		# Si el juego está pausado, ignoramos la entrada
		#return
	# Si no está pausado, procesamos la entrada normalmente
	if event is InputEventKey:
		if event.pressed:
			print("Tecla presionada: " + str(event.keycode))  # Usar keycode en lugar de scancode
	
	elif event is InputEventMouseButton:
		if event.pressed:
			print("Botón de ratón presionado: " + str(event.button_index))


func _on_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_configuracion.tscn")


func _on_menu_principal_pressed() -> void:
	print("Volver al menú principal")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_principal.tscn")




func _on_logica_pausa_pressed() -> void:
	print("Botón presionado")

	# Alternar pausa
	get_tree().paused = not get_tree().paused
	
	if get_tree().paused:
		print("Juego pausado")
		icono.texture_normal = textura_play
		icono.texture_pressed = textura_play
		icono.texture_hover = textura_play
		menu_pausa.visible = true
		fondo_opaco.visible = true
	else:
		print("Juego despausado")
		icono.texture_normal = textura_pausa
		icono.texture_pressed = textura_pausa
		icono.texture_hover = textura_pausa
		menu_pausa.visible = false
		fondo_opaco.visible = false
