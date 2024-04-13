extends Node2D

var character = null
var speed = 1

func _ready():
	print(name+" Ready")
	
func _process(delta):
	if character != null:
		position = lerp(position, character.position, delta * speed)

func set_features(inner: String, middle: String, outer: String):
	load_image($Inner.texture, inner)
	if middle == "":
		$Middle.visible = false
	else:
		load_image($Middle.texture, middle)
	
	if outer == "":
		$Outer.visible = false
	else:
		load_image($Outer.texture, outer, "particles")
		
func load_image(sprite, img_name, folder="creatures"):
	var img = Image.new()
	if img.load("res://textures/"+folder+"/"+img_name+".png") == OK:
		sprite.texture = ImageTexture.create_from_image(img)
