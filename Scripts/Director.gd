extends Node2D

var observer_scene = load("res://Scenes/Enemies/Observer/Observer.tscn")
var asteroid_scene = load("res://Scenes/Enemies/Asteroid/Asteroid.tscn")

var entities
var player

var max_spawn_cooldown = 1
var spawn_cooldown = max_spawn_cooldown

var edges = ["Left", "Right", "Up", "Down"]

func _ready():
	entities = $Entities
	player = entities.get_node("Player")

func _process(delta):
	if spawn_cooldown > 0:
		spawn_cooldown -= delta
	else:
		spawn_cooldown = max_spawn_cooldown
		var choice = edges[randi() % edges.size()]
		if choice == "Left":
			spawn_asteroid(Vector2(-640 * 2, rand_range(0, 720)) + player.global_position)
		elif choice == "Right":
			spawn_asteroid(Vector2(640 * 2, rand_range(0, 720)) + player.global_position)
		elif choice == "Up":
			spawn_asteroid(Vector2(rand_range(0, 1280), -360 * 2) + player.global_position)
		elif choice == "Down":
			spawn_asteroid(Vector2(rand_range(0, 1280), 360 * 2) + player.global_position)
			

func spawn(enemy_scene, position):
	var enemy = enemy_scene.instance()
	enemy.position = position
	enemy.target = player
	entities.add_child(enemy)
	pass

func spawn_asteroid(position, size = 3, speed = 200, angular_velocity = 1000):
	var enemy = asteroid_scene.instance()
	enemy.position = position
	enemy.size = size
	enemy.initial_speed = speed
	enemy.initial_angular_velocity = angular_velocity
	enemy.connect("spawn_asteroid", self, "spawn_asteroid")
	entities.call_deferred("add_child", enemy)
	pass
