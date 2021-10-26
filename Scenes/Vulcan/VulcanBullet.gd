extends Area2D

var hit_particle = load("res://Scenes/Particles/SquareParticle/SquareParticle.tscn")

const MOVE_SPEED = 1000

onready var collision_shape2D = $CollisionShape2D

var direction = Vector2()

var shake = Vector2(0, 0)
var shake_magnitude = 1

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)

func _process(delta):
	translate(shake)
	shake = Vector2(rand_range(-shake_magnitude, shake_magnitude),
			rand_range(-shake_magnitude, shake_magnitude))
	update()
	
func _physics_process(delta):
	position += direction * MOVE_SPEED * delta
	
func _draw():
	draw_rect(Rect2(Vector2(0, 0), Vector2(8, 2)), Color(1, 1, 1, 1))
	translate(-shake)


func _on_VulcanBullet_body_entered(body):
	body.got_hit(1)
	var particle = hit_particle.instance()
	particle.position = global_position
	particle.size = 15
	get_tree().get_root().get_node("World").get_child(0).add_child(particle)
	queue_free()
