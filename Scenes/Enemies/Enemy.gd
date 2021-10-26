extends RigidBody2D

class_name Enemy

var death_particle = load("res://Scenes/Particles/SquareParticle/SquareParticle.tscn")

var hit_time = 0

var shake = Vector2(0, 0)
var shake_magnitude = 1

var health

func _ready():
	add_to_group("enemies")
	
func _process(delta):
	if hit_time > 0:
		hit_time -= delta
	update()

func got_hit(damage):
	hit_time = 0.2
	health -= damage
	if health <= 0:
		var particle = death_particle.instance()
		particle.position = global_position
		particle.size = 50
		get_tree().get_root().get_node("World").get_child(0).add_child(particle)
		queue_free()
	shake_magnitude += 0.2
	update()
