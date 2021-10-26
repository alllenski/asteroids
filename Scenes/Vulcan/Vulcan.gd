extends Node2D

var vulcan_bullet = load("res://Scenes/Vulcan/VulcanBullet.tscn")

var base_fire_rate = 0.075
var max_fire_rate = base_fire_rate
var fire_rate = 0 

var inaccuracy

func _process(delta):
	if fire_rate > 0:
		fire_rate -= delta

func shoot():
	var inacurracy = Global.rng.randfn(0, 3)
	var bullet = vulcan_bullet.instance()
	bullet.position = global_position
	bullet.rotation_degrees = global_rotation_degrees + inacurracy
	get_tree().get_root().get_node("World").get_child(0).add_child(bullet)
	
	fire_rate = max_fire_rate
