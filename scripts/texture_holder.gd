extends Node2D
# just a 'static' truth for textures
# TODO sloppy, but whatever
@export var textures: Array[Texture] = []

# created from names
var texture_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for t in textures:
		var t_name = t.get_path().get_file().replace('.png', '')
		t_name = t_name.split('- ')[-1]
		texture_dict[t_name] = t
