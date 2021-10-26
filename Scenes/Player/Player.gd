extends RigidBody2D

# Onreadies
onready var collision_polygon2D = $CollisionPolygon2D
onready var weapon = $Weapon.get_child(0)

# Other scenes
var ghost_scene = load("res://Scenes/Player/Ghost.tscn")

# Signals
signal health_changed
signal update_offset
signal update_coordinates

# Movement
var origin = Vector2(0, 0)
const MOVE_SPEED = 500
var speed = MOVE_SPEED
var slow = 1

# Direction
var move_direction = Vector2()
var face_direction = Vector2()

# Impulse
var impulse = Vector2()
var impulse_friction = 50

# Blink
const BLINK_FORCE = 2.5
var base_blink_cooldown = 0.5
var max_blink_cooldown = base_blink_cooldown
var blink_cooldown = 0

# Invincibilty Frames
var shield_integrity = 1

# Invincibility Effects
var max_ghost_cooldown = 0.075
var ghost_cooldown = 0

# Shake Effects
var shake = Vector2(0, 0)
var shake_magnitude = 1

# Stats
var max_health = 3
var health = max_health

func _ready():
	# Set health bar
	emit_signal("health_changed", health, max_health)

func _process(delta):
	# Handle timed variables
	if slow < 1:
		slow = lerp(slow, 1, 0.02)
	if shield_integrity < 1:
		shield_integrity += delta * 0.75
	else:
		collision_polygon2D.disabled = false
	if blink_cooldown > 0:
		if ghost_cooldown <= 0:
			spawn_ghost(global_position, 0.5 + blink_cooldown)
			ghost_cooldown = max_ghost_cooldown
		else:
			ghost_cooldown -= delta 
		blink_cooldown -= delta
	
	emit_signal("update_coordinates", global_position)
	
	update()
	
func _physics_process(delta):	
	# Movement
	if Input.is_action_pressed("move_up"):
		add_central_force(Vector2(10, 0).rotated(rotation))
	if Input.is_action_pressed("move_down"):
		pass
	if Input.is_action_pressed("move_left"):
		set_angular_velocity(-5)
	if Input.is_action_pressed("move_right"):
		set_angular_velocity(5) 
	
	# move_direction *= slow
	
	# move_direction += impulse
	# impulse *= impulse_friction * delta
	

	
	# var collision = move_and_collide(move_direction * speed * delta, false)
	# if collision:
	# 	if collision.collider.is_in_group("enemies"):
	# 		hit(collision)
		
	move_direction = global_position
	
	emit_signal("update_offset", global_position)

	if Input.is_action_pressed("shoot") && weapon.fire_rate <= 0:
		shoot()
	if Input.is_action_pressed("blink") && blink_cooldown <= 0:
		blink()

func shoot():
	weapon.shoot()

func blink():
	for i in 5:
		spawn_ghost(global_position + move_direction * i * 5, i * 0.25)
	impulse = move_direction * BLINK_FORCE

	blink_cooldown = max_blink_cooldown
	
func spawn_ghost(position, alpha):	
	var ghost = ghost_scene.instance()
	ghost.position = position
	ghost.rotation_degrees = global_rotation_degrees
	ghost.alpha = alpha
	ghost.polygon = collision_polygon2D.polygon
	get_tree().get_root().get_node("World").get_child(0).add_child(ghost)
		
func _draw():
	if shield_integrity < 1:
		for i in 4:
			var offset = Vector2(rand_range(-(1 - shield_integrity),
					1 - shield_integrity),
					rand_range(-(1 - shield_integrity),
					1 - shield_integrity)) * 25
			var polygon = collision_polygon2D.polygon
			for j in polygon.size():
				polygon.set(j, Vector2(polygon[j]) + offset)
			draw_polyline(polygon, Color(0.3, 0.3, 0.3, 1 - shield_integrity), 2)
	
	var offset = Vector2(rand_range(-1, 1),
			rand_range(-1, 1)) * shake_magnitude
	var polygon = collision_polygon2D.polygon
	for j in polygon.size():
		polygon.set(j, Vector2(polygon[j]) + offset)
	draw_polyline(polygon, Color(1, 1, 1, shield_integrity), 2)

func hit(collision):
	impulse = collision.normal * BLINK_FORCE
	shield_integrity = 0
	slow = 0.1
	health -= 1
	collision_polygon2D.disabled = true
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		get_tree().reload_current_scene()

