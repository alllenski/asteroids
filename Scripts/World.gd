extends Node

onready var player = $Director/Entities/Player

func _ready():
	player.connect("health_changed", $Interface/GUI, "update_health")
	player.connect("update_offset", $Background/Background, "update_offset")
	player.connect("update_coordinates", $Interface/GUI, "update_coordinates")

