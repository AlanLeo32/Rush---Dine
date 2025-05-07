extends Node2D

var previous_position: Vector2
var line: Line2D
var slash_area: Area2D
var collision_shape: CollisionShape2D

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

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var pos = get_viewport().get_mouse_position()
		line.add_point(pos)
		if line.get_point_count() > 5:
			line.remove_point(0)
		update_collision_shape()
	else:
		line.clear_points()

func update_collision_shape():
	if line.get_point_count() < 2:
		return
	var start = line.get_point_position(0)
	var end = line.get_point_position(line.get_point_count() - 1)
	var center = (start + end) / 2.0
	var length = start.distance_to(end)
	var angle = (end - start).angle()

	var shape = RectangleShape2D.new()
	shape.size = Vector2(length, 20)

	collision_shape.shape = shape
	slash_area.position = center
	slash_area.rotation = angle
