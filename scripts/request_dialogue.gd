extends "res://scripts/dialogue.gd"

func _ready():
	dialogues = ["TODO SET"]
	super()
	
func set_dialogue(difficulty: int, inner: String, middle: String, outer: String):
	# TODO variants
	var diffs = ['easy', 'tricky', 'hard']
	var request = "I'd like a "+inner
	if middle != "":
		request += " with "+middle
	if outer != "":
		request += " that is "+outer
	request += "!"
	
	dialogues = [
		"Hello! I've got an "+diffs[difficulty]+" one for you.",
		request,
		"Let me know when your ready for me to take a look!"
	]
	reset()
	
func happy_dialogue():
	dialogues = [
		"I love him! Thanks!"
	]
	reset()
	$FinalButton.text = "Goodbye!"
	$FinalButton.pressed.connect(self.next_client)
	
func sad_dialogue():
	dialogues = [
		"This isn't what I wanted..."
	]
	reset()
	$FinalButton.text = "...bye"
	$FinalButton.pressed.connect(self.next_client)

func nothing_dialogue():
	dialogues = [
		"You haven't summoned anything yet.",
		"Don't worry! I'll wait.",
		"Let me know when your ready for me to check what you conjured.",
	]
	reset()
	$FinalButton.text = "check"

# Check summoning
@onready var summoner = get_parent().get_parent().get_node("Summoner")
func on_final():
	var result = summoner.client_check(get_parent())
	if result == "good":
		happy_dialogue()
	elif result == "bad":
		sad_dialogue()
	else:
		nothing_dialogue()
	
func next_client():
	get_parent().go_away()
	summoner.next_client()
