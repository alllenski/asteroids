extends Enemy

onready var collision_shape2d = $CollisionShape2D
onready var eye_shape = $EyeShape

const MOVE_SPEED = 60

var move_direction = Vector2()
var look_direction = Vector2()

var target

func _ready():
	health = 6
	move_direction = target.position - global_position
	move_direction = move_direction.normalized()
	
func _process(delta):
	look_direction = target.position - global_position
	look_direction = look_direction.normalized() * 3
	
func _physics_process(delta):
	pass

func _draw():
	if hit_time > 0:
		draw_circle(Vector2(0, 0), collision_shape2d.shape.radius, 
				Color(1, 1, 1, range_lerp(hit_time, 0, 0.1, 0, 1.5)))	
	else:
		draw_arc(Vector2(0, 0), collision_shape2d.shape.radius,
			0, PI * 2, 12, Color(1, 0, 0, 1), 2)
		draw_polyline(eye_shape.polygon, Color(1, 0, 0, 1), 2)
		draw_arc(Vector2(0, 0), 5, 0, PI * 2, 12, Color(1, 0, 0, 1), 1)
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
