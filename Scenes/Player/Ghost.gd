extends Node2D

var shake = Vector2(0, 0)
var shake_magnitude = 1

var decay_speed = 3

var alpha
var polygon

func _process(delta):
	if alpha > 0:
		alpha -= decay_speed * delta
	elif alpha <= 0:
		queue_free()
		
	translate(shake)
	shake = Vector2(rand_range(-shake_magnitude, shake_magnitude),
			rand_range(-shake_magnitude, shake_magnitude))
	update()
	
func _draw():
	draw_polyline(polygon, Color(1, 1, 1, alpha), 2)
	translate(-shake)
