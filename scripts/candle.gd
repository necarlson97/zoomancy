extends Node2D

var lit = false
func _ready():
	$Button.pressed.connect(self.toggle)
	set_light()
	
func toggle():
	lit = !lit
	set_light()

func set_light():
	$PointLight2D.visible = lit
	$GPUParticles2D.emitting = lit
