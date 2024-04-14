extends "res://scripts/dialogue.gd"

func _ready():
	dialogues = [
		"Welcome to the blood-altar, apprentice! Today, you will begin your flesh-conjuring journey, discreetly satisfying the summoning needs of our clients.",
		"I am William. Your humble flayed-servant.",
		"Lets begin with a simple Rattus Convocatio.",
		"Take the knife in hand, and carefully inscribe a modest circle at the altar's centere.",
		"Mistakes can be washed away with a damp sponge, or you may cleanse the entire altar using the contents of the roach jar.",
		"Once your inscription is complete, ignite every candle to finalize the ritual, and summon what may.",
	]
	$SkipButton.pressed.connect(self.start_game)
	super()

func _process(delta):
	super._process(delta)
	$ExampleRat.global_position  = get_parent().get_node("DrawCanvas/Canvas").global_position
	$ExampleRat.visible = (current_dialogue_index in range(2, 7))
	$ExampleBird.global_position  = get_parent().get_node("DrawCanvas/Canvas").global_position
	$ExampleBird.visible = (current_dialogue_index in range(7, 9))


func on_final():
	if Utils.find_by_script(get_tree().root, "creature") != []:
		ready_for_game()
	else:
		keep_trying()
		
func ready_for_game():
	dialogues = [
		"Ah hah! I heard something!",
		"Alas, I have long lost my eyes. Did you summon something? Was it good?",
		"Try creating sigils in the middle and outer rings as well.",
		"Experiment with various sigils and observe what emerges from the gloom.",
		"Have you reveled enough in the bloodmagicks? Our initial patron now stands at our threshold. Shall I user them in?",
	]
	reset()
	$FinalButton.text = "begin!"
	$FinalButton.pressed.connect(self.start_game)	
	
func keep_trying():
	dialogues = [
		"Did you summon something yet?",
		"Left click to pickup the knife or sponge. Right click to drop.",
		"Draw a shape on the altar, then click each of the 3 candles at the top.",
	]
	reset()
	$FinalButton.text = "check"
	

func start_game():
	get_parent().get_node("Summoner").next_client()
	queue_free()
