extends MarginContainer

onready var integrity_label = $"Grid/Left/Health Display"
onready var coordinates_display = $"Grid/Right/Coordinates"
onready var framecounter = $"Grid/Left/Framecounter"

func _process(delta):
	update_framecounter()

func update_health(value, max_value):
	integrity_label.text = "HEALTH [" + str(value) + "/" + str(max_value) + "]"

func update_coordinates(position):
	coordinates_display.text = "X: " + str(floor(position.x / 100)) + " Y: " + str(floor(position.y / 100))

func update_framecounter():
	framecounter.text = "FRAMES [" + str(Engine.get_frames_per_second()) + "]"
