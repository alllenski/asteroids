extends Particles2D

var size = 1

func _ready():
	scale = Vector2(size, size)
	emitting = true

func _process(delta):
	if not emitting:
		queue_free()
