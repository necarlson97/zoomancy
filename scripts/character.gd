extends Node2D

# Dict of creature -> difficulty
var inners = {
	"cat": 0,
	"rat": 0,
	#"dog": 0,
	"bird": 0,
	"bat": 1,
	"rabbit": 1,
	#"frog": 1,
	#"turtle": 1,
	#"deer": 2,
	#"cow": 2,
}
var middles = {
	"": 0,
	#"hat": 0,
	"angel": 0,
	"devil": 0,
	#"backpack": 1,
	"horns": 1,
	"antlers": 1,
	#"horns antlers wings": 2,
}
var outers = {
	"": 0,
	"sparkling": 1,
	"flaming": 1,
	#"toxic": 1,
	"electic": 2,
	"icy": 2,
}

# Positions
var target = self.position
var waiting = Vector2(256, 512+260)
var present = Vector2(256, 256)
var gone = Vector2(256, -260)

func choose(dict):
	var values = dict.values()
	return values[randi() % values.size()]

func _process(delta):
	self.position = lerp(self.position, target, delta)

func generate_request(difficulty: int):
	# Generate a summoning request for 0 easy, 1 medium, 2 hard
	var is_easier = func is_easier(key):
		return key <= difficulty
	var ins = inners.values().filter(is_easier)
	var mids = middles.values().filter(is_easier)
	var outs = outers.values().filter(is_easier)
	return [choose(ins), choose(mids), choose(outs)]
