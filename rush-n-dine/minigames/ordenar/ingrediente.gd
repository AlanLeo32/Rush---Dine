extends TextureRect

signal dropped(ingredient_instance, drop_position)

# Propiedades del ingrediente
var ingredient_type: String = "desconocido" # Ejemplo: "tomate", "lechuga", "carne"
var original_position: Vector2 # Para volver si no se suelta en un lugar válido (opcional)
var target_position_on_plate: Vector2 # Posición ideal en el plato (para cálculo de score)
var tam

var dragging: bool = false
var drag_offset: Vector2
func soltar():
	# Si usás variables como dragging, ponelas en false
	dragging = false
	# Si usás input_event, podés resetear posiciones o estados acá
func _ready():
	# Para asegurar que el input se procese para este nodo Control
	mouse_filter = Control.MOUSE_FILTER_STOP # Captura clicks en este nodo
	original_position = global_position

	# Ejemplo de cómo se podría configurar desde fuera (al instanciar)

func setTexture(tipo, tam):
	texture = load('res://Sprites/'+ tipo +'.png')
	ingredient_type = tipo
	#custom_minimum_size = texture.get_size() # Ajustar tamaño al de la textura
	#realsize = texture.get_size()* tam
	#print(str(texture.get_size())+str(realsize))
	$".".scale = Vector2(tam, tam)
	#set_size(realsize)
	#print('asd' + str(realsize) + '2' + str(realsize/2))

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				#set_size(realsize)
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
				z_index = 10 # Para que esté por encima al arrastrar
				#print(ingredient_type + " picked up")
			else:
				if dragging:
					dragging = false
					z_index = 1 # Volver a su z-index normal o el que corresponda
					emit_signal("dropped", self, global_position)
					#print(ingredient_type + " dropped at " + str(global_position))

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

# Función para volver a la posición original si no se suelta en el plato
func return_to_original_pos():
	# Podrías añadir una pequeña animación con un Tween aquí
	global_position = original_position

# Función para establecer la posición en el plato una vez colocado
func set_on_plate(plate_node: Node2D, local_position_on_plate: Vector2):
	# Reparentar al plato y ajustar posición
	var current_global_pos = global_position
	get_parent().remove_child(self)
	plate_node.add_child(self)
	global_position = current_global_pos # Mantener la posición visual inicial

	# Desactivar más arrastres una vez colocado (opcional)
	set_process_input(false)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
