extends "res://scripts/dialogue.gd"

func check_summon():
	return Utils.find_by_script(get_tree().root, "creature") != []
	
func _ready():
	$FinalButton.text = "check" # TODO 'next
	super()

#TODO could randomize text
var happy_block = TextBlock.new(["I love him! Thanks!"])
var sad_block = TextBlock.new(["This isn't what I wanted..."])
var nothing_block = TextBlock.new([], [], [
	"You haven't summoned anything yet.",
	"Don't worry! I'll wait.",
	"Let me know when your ready for me to check what you conjured.",
], check_summon)

func set_dialogue(difficulty: int, inner: String, middle: String, outer: String):
	# TODO variants
	
	# Some things we want to format a bit nice
	var translator = {
		"angel": "extra angel wings",
		"devil ": "extra devil wings",
		"backpack": "a backpack",
		"hat": "a hat",
	}
	inner = translator.get(inner, inner)
	middle = translator.get(middle, middle)
	outer = translator.get(outer, outer)
	
	var diffs = ['easy', 'tricky', 'hard']
	var request = "I'd like a "+inner
	if middle != "":
		request += " with "+middle
	if outer != "":
		request += " that is "+outer
	request += "!"
	
	var request_dia = [
		"Hello! I've got an "+diffs[difficulty]+" one for you.",
		request,
	]
	blocks = [TextBlock.new(request_dia)]
	
# Check summoning
@onready var summoner = get_parent().get_parent().get_node("Summoner")
func next_block():
	var result = summoner.client_check(get_parent())
	print("Next block: %s" % result)
	if result == "good":
		$FinalButton.text = "Goodbye!"
		blocks = [happy_block]
	elif result == "bad":
		$FinalButton.text = "...bye"
		blocks = [sad_block]
	else:
		blocks = [nothing_block]
	start_typing()
	check_buttons()

func on_final():
	print("Final called")
	if blocks == [happy_block] or blocks == [sad_block]: next_client()
	else: next_block() 
	
func next_client():
	get_parent().go_away()
	summoner.next_client()
