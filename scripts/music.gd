extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(self.toggle)

func toggle():
	if playing: stop()
	else: play()
