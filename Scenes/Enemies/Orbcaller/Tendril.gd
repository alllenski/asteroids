extends KinematicBody2D

onready var collision_polygon2d = $CollisionPolygon2D

signal got_hit

var hit

func _process(delta):
	update()
	
func _draw():
	
	if hit:
		draw_polygon(collision_polygon2d.polygon,
				PoolColorArray([Color(1, 1, 1)]))
	else:
		draw_polyline(collision_polygon2d.polygon,
				Color(1, 0, 0, 1), 2)

func got_hit(damage):
	emit_signal("got_hit", damage)
