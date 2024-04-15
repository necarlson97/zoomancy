extends Node2D

var character = null
var speed = 9
var target_scale = 1

var features: Utils.CreatureFeatures

func _ready():
	scale = Vector2(0, 0)
	
	load_image($Inner, features.inner)
	if features.middle == "": $Middle.visible = false
	else: load_image($Middle, features.middle)
	if features.outer == "": $Outer.visible = false
	else: load_image($Outer, features.outer, "particles")
	
func _process(delta):
	if character != null:
		# TODO gross, for deleting them later
		character.held_creature = self
		var holster = character.get_node("Holster")
		global_position = lerp(global_position, holster.global_position, delta * speed)
	scale = lerp(scale, Vector2(1, 1) * target_scale, delta*3)

func set_features(cf: Utils.CreatureFeatures):
	features = cf
		
func load_image(sprite, img_name, folder="creatures"):
	sprite.texture = get_tree().root.get_node("Main/AllCreatures").texture_dict[img_name]
		
func slow_die():
	$BloodParticle.emitting = true
	target_scale = 0
	await get_tree().create_timer(0.2).timeout
	queue_free()
