extends Node2D

var lit = true
func _ready():
	$Button.pressed.connect(self.toggle)
	set_light()
	
func toggle():
	lit = !lit
	set_light()
	$Audio.play()

func slow_light():
	lit = true
	await get_tree().create_timer(0.2).timeout  
	set_light()

func set_light():
	$PointLight2D.visible = lit
	$GPUParticles2D.emitting = lit
