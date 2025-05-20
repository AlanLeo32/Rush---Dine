extends Node2D

var previous_position: Vector2
var line: Line2D
var slash_area: Area2D
var collision_shape: CollisionShape2D
var dir: String
var slice1
var slice2

func _ready():
	line = Line2D.new()
	line.width = 8
	line.default_color = Color.RED
	add_child(line)

	slash_area = Area2D.new()
	collision_shape = CollisionShape2D.new()
	slash_area.add_child(collision_shape)
	slash_area.name = "SlashArea"

	add_child(slash_area)
	#slash_area.connect("area_entered", _on_area_entered)

#func _on_area_entered(area):
#	var veggie = area.get_parent()
#	if veggie and veggie.is_in_group("Fruta"):
#		print("Colisión con:", veggie.name)
#		veggie.queue_free()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos = get_viewport().get_mouse_position()
		line.add_point(pos)
		var length = line.get_point_count()
		if length > 2:
			dir = ''
			var ult = line.get_point_position(length-1)
			var pri = line.get_point_position(0)
			dir = detectar_direccion(ult, pri)
			
			if length > 5:
				line.remove_point(0)
		#update_collision_shape()
		var space = get_world_2d().direct_space_state

		var params = PhysicsPointQueryParameters2D.new()
		params.position = pos

		var result = space.intersect_point(params, 32)

		for hit in result:
			var obj := hit.get("collider") as Node
			if obj and obj.is_in_group("Fruta") and !obj.cortando():
				obj.cortar()
				print("Fruta cortada:", obj.name)
				print('Direccion del corte: ' + dir)
				elimina_fruta(obj)
	else:
		line.clear_points()

func detectar_direccion(ult, pri) -> String:
	var movX = ult[0] - pri[0]
	var movY = ult[1] - pri[1]
	
	if movX == 0 and movY == 0:
		return "Sin movimiento"

	var dir = Vector2(movX, movY)
	var angle = dir.angle() # en radianes, entre -PI y PI

	var deg = rad_to_deg(angle)

	if deg >= -22.5 and deg < 22.5:
		return "Derecha"
	elif deg >= 22.5 and deg < 67.5:
		return "Abajo a la derecha"
	elif deg >= 67.5 and deg < 112.5:
		return "Abajo"
	elif deg >= 112.5 and deg < 157.5:
		return "Abajo a la izquierda"
	elif deg >= 157.5 or deg < -157.5:
		return "Izquierda"
	elif deg >= -157.5 and deg < -112.5:
		return "Arriba a la izquierda"
	elif deg >= -112.5 and deg < -67.5:
		return "Arriba"
	elif deg >= -67.5 and deg < -22.5:
		return "Arriba a la derecha"

	return "Indefinido"

func elimina_fruta(obj):
	#var full_sprite = obj.get_node("FullSprite")
	#if full_sprite:
	#	full_sprite.visible = false
	#	
	#if dir=='Arriba' or dir=='Abajo':
	#	slice1 = Sprite2D.new()
	#	slice1.texture = load("res://Sprites/tomate-slice/tomate-u.png")
	#	slice1.position = obj.position + Vector2(-10, 0)
	#	
	#	slice2 = Sprite2D.new()
	#	slice2.texture = load("res://fruta_right.png")
	#	slice2.position = obj.position + Vector2(10, 0)
	#	
	#obj.get_parent().add_child(slice1)
	#obj.get_parent().add_child(slice2)
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(obj):
		obj.queue_free()

#func update_collision_shape():
#	if line.get_point_count() < 2:
#		return
#	var start = line.get_point_position(0)
#	var end = line.get_point_position(line.get_point_count() - 1)
#	var center = (start + end) / 2.0
#	var length = start.distance_to(end)
#	var angle = (end - start).angle()

#	var shape = RectangleShape2D.new()
#	shape.size = Vector2(length, 20)

#	collision_shape.shape = shape
#	slash_area.position = center
#	slash_area.rotation = angle
