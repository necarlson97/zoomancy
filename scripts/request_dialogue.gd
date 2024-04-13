extends "res://scripts/dialogue.gd"

func _ready():
	dialogues = ["TODO SET"]
	super()
	
func set_dialoge(difficulty: int, inner: String, middle: String, outer: String):
	# TODO variants
	var diffs = ['easy', 'tricky', 'hard']
	var request = "I'd like a "+inner
	if middle != "":
		request += " with "+middle
	if outer != "":
		request += " that is "+outer
	request += "!"
	
	dialogues = [
		"Hello! I've got an "+diffs+" one for you.",
		request
	]

# Check summoning
func on_final():
	get_parent().complete()
