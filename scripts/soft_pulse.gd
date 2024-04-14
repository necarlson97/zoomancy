extends Sprite2D


var a_max = 1
var speed = 0.003

func _ready():
	a_max = modulate.a

func _process(_delta):
	var sine = (1+sin(Time.get_ticks_msec() * speed))/2
	var alpha = sine * a_max;
	modulate = Color(1,1,1, alpha)
