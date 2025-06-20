extends Node2D

@export var snake_scene : PackedScene

var score : int
var game_started : bool = false

# grid variables
var cells : int = 21
var cells_y : int = 12
var cell_size : int = 80

#food variables
var food_pos : Vector2
var regen_food : bool = true

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variables
var start_pos = Vector2(9, 5)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move: bool

# Definí el margen deseado (en píxeles)
var margin = Vector2(120, 78) # Cambiá estos valores según el padding que quieras

# Función para convertir coordenadas de celda a posición en pantalla con margen
func cell_to_screen(cell: Vector2) -> Vector2:
	return margin + cell * cell_size

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	get_tree().paused = false
	get_tree().call_group("segments", "queue_free")
	#$GameOverMenu.hide()
	score = 0
	$Hud.get_node("ScoreLabel").text = "PUNTAJE: " + str(score)
	move_direction = up
	can_move = true
	generate_snake()
	move_food()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	#starting with the start_pos, create tail segments vertically down
	first_segment()
	# Esto e abajo genera mas segmentos, pero si queres empezar con solo 1 no hacen falta
	#for i in range(2):
	#	add_segment(start_pos + Vector2(0, i+1))
		
func first_segment():
	#starting with the start_pos, create tail segments vertically down
	snake_data.append(start_pos)
	var SnakeSegment = snake_scene.instantiate()
	
	var sprite = SnakeSegment.get_node("Sprite2D")
	sprite.texture = preload("res://Sprites/chefFace70px.png")
	
	SnakeSegment.position = (cell_to_screen(start_pos)) + Vector2(0, cell_size)
	SnakeSegment.self_modulate = Color(1.0, 0.8, 0.2)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)

func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position = (cell_to_screen(pos)) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	move_snake()
#	
#func move_snake():
#	if can_move:
#		#update movement from keypresses
#		if Input.is_action_just_pressed("move_down") and move_direction != up:
#			move_direction = down
#			can_move = false
#			if not game_started:
#				start_game()
#		if Input.is_action_just_pressed("move_up") and move_direction != down:
#			move_direction = up
#			can_move = false
#			if not game_started:
#				start_game()
#		if Input.is_action_just_pressed("move_left") and move_direction != right:
#			move_direction = left
#			can_move = false
#			if not game_started:
#				start_game()
#		if Input.is_action_just_pressed("move_right") and move_direction != left:
#			move_direction = right
#			can_move = false
#			if not game_started:
#				start_game()
#
func start_game():
	game_started = true
	var factor = ((ManejoMinijuegos.dificultad - 1.0) / (1.6 - 1.0))
	var tiempo_moveTimer = 0.135 - (0.135-0.11) * factor
	$MoveTimer.start(tiempo_moveTimer)


func _on_move_timer_timeout():
	#allow snake movement
	can_move = true
	#use the snake's previous position to move the segments
	old_data = [] + snake_data
	snake_data[0] += move_direction
	for i in range(len(snake_data)):
		#move all the segments along by one
		if i > 0:
			snake_data[i] = old_data[i - 1]
		snake[i].position = (cell_to_screen(snake_data[i])) + Vector2(0, cell_size)
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	
func check_out_of_bounds():
	if snake_data[0].x < 0 or snake_data[0].x > cells - 1 or snake_data[0].y < 0 or snake_data[0].y > cells_y - 3:
		end_game()
		
func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		score += 1
		$Hud.get_node("ScoreLabel").text = "PUNTAJE: " + str(score)
		add_segment(old_data[-1])
		move_food()
		if score >= 15:
			end_game()

	
func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells_y - 3))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Food.position = (cell_to_screen(food_pos))+ Vector2(0, cell_size)
	regen_food = true

func end_game():
	#$GameOverMenu.show()
	print("Juego snake terminado")
	$MoveTimer.stop()
	game_started = false
	var cant_recursos = int(score / 3)
	var recurso = "verdura"
	ManejoMinijuegos.actualizar_recursos(recurso, cant_recursos)
	ManejoMinijuegos.volver_a_dia()
	


func _on_game_over_menu_restart():
	new_game()

var touch_start_position := Vector2.ZERO
var dragging := false

func _unhandled_input(event):
	# PC: Mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start_position = event.position
			dragging = true
			if not game_started:
				start_game()
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var drag_vector = event.position - touch_start_position
		if drag_vector.length() > 10:
			var dir = drag_vector.normalized()
			if abs(dir.x) > abs(dir.y):
				if dir.x > 0 and move_direction != Vector2.LEFT:
					move_direction = Vector2.RIGHT
				elif dir.x < 0 and move_direction != Vector2.RIGHT:
					move_direction = Vector2.LEFT
			else:
				if dir.y > 0 and move_direction != Vector2.UP:
					move_direction = Vector2.DOWN
				elif dir.y < 0 and move_direction != Vector2.DOWN:
					move_direction = Vector2.UP

	# Móvil: Touch
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_position = event.position
			dragging = true
			if not game_started:
				start_game()
		else:
			dragging = false
	elif event is InputEventScreenDrag and dragging:
		var drag_vector = event.position - touch_start_position
		if drag_vector.length() > 10:
			var dir = drag_vector.normalized()
			if abs(dir.x) > abs(dir.y):
				if dir.x > 0 and move_direction != Vector2.LEFT:
					move_direction = Vector2.RIGHT
				elif dir.x < 0 and move_direction != Vector2.RIGHT:
					move_direction = Vector2.LEFT
			else:
				if dir.y > 0 and move_direction != Vector2.UP:
					move_direction = Vector2.DOWN
				elif dir.y < 0 and move_direction != Vector2.DOWN:
					move_direction = Vector2.UP
