extends Enemy

# Onreadies

onready var collision_shape = $CollisionShape

# Signals

signal spawn_asteroid

var initial_speed
var initial_angular_velocity

var size = 3

func _ready():
	
	health = size * 8
	
	var polygon = PoolVector2Array()
	var angle = PI
	for i in collision_shape.polygon.size():
		if i != collision_shape.polygon.size() - 1:
			var offset = rand_range(size * 10, size * 60)
			var direction = Vector2(cos(angle), sin(angle)) * offset
			angle += PI / 4
			polygon.append(Vector2(collision_shape.polygon[i]) + 
					direction)
		else:
			polygon.append(Vector2(polygon[0]))
	collision_shape.polygon = polygon
	
	angle = rand_range(0, PI * 2)
	var direction = Vector2(cos(angle), sin(angle))
	direction = direction.normalized()
	apply_central_impulse(direction * initial_speed * 0.75)
	yield (get_tree(),"idle_frame")
	yield (get_tree(),"idle_frame")
	yield (get_tree(),"idle_frame")
	apply_torque_impulse(initial_angular_velocity * 0.75)

func _draw():
	if hit_time > 0:
		draw_polygon(collision_shape.polygon,
				PoolColorArray([Color(0.5, 0.5, 0.5,
				range_lerp(hit_time, 0, 0.2, -0.5, 1))]))	
	else:
		draw_polyline(collision_shape.polygon, Color(1, 0, 0, 1), 2)

func got_hit(damage):
	.got_hit(damage)
	if health <= 0:
		if size > 1:
			var speed = linear_velocity.length()
			emit_signal("spawn_asteroid", position, size - 1, speed, angular_velocity)
		queue_free()
