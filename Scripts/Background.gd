extends Node2D

var screen_size
var row
var column
var spacing = 200
var offset = Vector2(0, 0)
var speed = 20
var color = Color(1, 1, 1, 0.3)

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	row = screen_size.y / spacing
	column = screen_size.x / spacing
	
func _process(delta):
	if abs(offset.x) >= spacing:
		offset.x = 0
	if abs(offset.y) >= spacing:
		offset.y = 0
	update()	
	
func _draw():

	for i in row + 1:
		draw_line(Vector2(0, i * spacing + offset.y),
				Vector2(screen_size.x, i * spacing + offset.y),
				color)
	for i in column + 1:
		draw_line(Vector2(i * spacing + offset.x, 0),
				Vector2(i * spacing + offset.x, screen_size.y),
				color)

func update_offset(player_position):
	offset = -player_position.posmod(200)
