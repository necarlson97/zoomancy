extends Sprite2D


var max = 1
var speed = 0.005

func _ready():
	max = modulate.a

func _process(delta):
	var sine = (1+sin(Time.get_ticks_msec() * speed))/2
	var alpha = sine * max;
	modulate = Color(1,1,1, alpha)
