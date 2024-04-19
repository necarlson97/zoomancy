extends Node2D

# Dict of creature -> difficulty
var inners = {
	"cat": 0,
	"rat": 0,
	"dog": 0,
	"bird": 0,
	"bat": 1,
	"rabbit": 1,
	"frog": 1,
	"turtle": 1,
	"deer": 2,
	"cow": 2,
	"blob": 3,
}
var middles = {
	"": 0,
	"hat": 0,
	"angel": 1,
	"devil": 1,
	"backpack": 1,
	"horns": 1,
	"antlers": 1,
}
var outers = {
	"": 0,
	"sparkling": 1,
	"flaming": 1,
	"toxic": 1,
	"electric": 2,
	"icy": 2,
}

var speed = 10

# Positions
@onready var waiting = get_parent().get_node("CharacterWait").position
@onready var standing = get_parent().get_node("CharacterStand").position
@onready var gone = get_parent().get_node("CharacterGone").position
@onready var target = standing

var difficulty = 0
var request = ["rat", "", ""]

@export var textures: Array[Texture] = []

func _ready():
	$Sprite.texture = choose(textures)
	
	difficulty = get_new_difficulty()
	position = waiting
	request = self.generate_request()
	print("Requesting "+str(request))
	$RequestDialogue.set_dialogue(difficulty, request[0], request[1], request[2])
	
func get_new_difficulty():
	var successes = get_parent().get_node("Referee").res['good']
	var max_difficulty = int(successes / 3)
	print("max_difficulty: "+str(max_difficulty))
	return clamp(max_difficulty, 0, 2)

func _process(delta):
	position = lerp(position, target, delta * speed)

func generate_request():
	# Generate a summoning request for 0 easy, 1 medium, 2 hard
	var is_easier = func is_easier(key):
		return key <= self.difficulty
	var ins = filter_dict(inners, is_easier)
	var mids = filter_dict(middles, is_easier)
	var outs = filter_dict(outers, is_easier)
	return [choose(ins), choose(mids), choose(outs)]

func filter_dict(dict, predicate):
	var result = []
	for k in dict.keys():
		var v = dict[k]
		if predicate.call(v):  # Apply the predicate to the value
			result.append(k)
	return result
	
func choose(arr):
	return arr[randi() % arr.size()]

var held_creature = null
func go_away():
	if (held_creature):
		held_creature.queue_free()
	target = gone
	await get_tree().create_timer(1).timeout
	queue_free()
