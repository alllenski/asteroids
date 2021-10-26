extends Enemy

onready var collision_shape2d = $CollisionShape2D
onready var tendrils = $Tendrils.get_children()

const MOVE_SPEED = 60
const ATTACK_SPEED = 40

var move_direction = Vector2()
var look_direction = Vector2()

var target

func _ready():
	health = 12
	for tendril in tendrils:
		tendril.connect("got_hit", self, "got_hit")
	
func _process(delta):
	if hit_time > 0:
		for tendril in tendrils:
			tendril.hit = true
	else:
		for tendril in tendrils:
			tendril.hit = false
	
func _physics_process(delta):
	pass
	
func _draw():
	if hit_time > 0:
		draw_circle(Vector2(0, 0), collision_shape2d.shape.radius, 
				Color(1, 1, 1, range_lerp(hit_time, 0, 0.1, 0, 1.5)))	
	else:
		draw_arc(Vector2(0, 0), collision_shape2d.shape.radius,
			0, PI * 2, 12, Color(1, 0, 0, 1), 2)
		draw_circle(Vector2(0, 0) + look_direction, 2, Color(1, 0, 0, 1))
	
	translate(-shake)

func got_hit(damage):
	hit_time = 0.1
	health -= damage
	if health <= 0:
		var particle = death_particle.instance()
		particle.position = global_position
		get_tree().get_root().get_node("World").get_child(0).add_child(particle)
		queue_free()
	shake_magnitude += 0.2
	update()
