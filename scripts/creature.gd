extends Node2D

var character = null
var speed = 9
var target_scale = 1

var features: Utils.CreatureFeatures

func _ready():
	scale = Vector2(0, 0)
	
func _process(delta):
	if character != null:
		# TODO gross, for deleting them later
		character.held_creature = self
		var holster = character.get_node("Holster")
		global_position = lerp(global_position, holster.global_position, delta * speed)
	scale = lerp(scale, Vector2(1, 1) * target_scale, delta*3)

func set_features(cf: Utils.CreatureFeatures):
	features = cf
	
	load_image($Inner, features.inner)
	if features.middle == "": $Middle.visible = false
	else: load_image($Middle, features.middle)
	
	if features.outer == "": $Outer.visible = false
	else: load_image($Outer, features.outer, "particles")
		
func load_image(sprite, img_name, folder="creatures"):
	var img = Image.new()
	if img.load("res://textures/"+folder+"/"+img_name+".png") == OK:
		print("Setting "+str(sprite)+" to "+folder+" "+img_name)
		sprite.texture = ImageTexture.create_from_image(img)
		
func slow_die():
	$BloodParticle.emitting = true
	target_scale = 0
	await get_tree().create_timer(0.2).timeout
	queue_free()
