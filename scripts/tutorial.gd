extends "res://scripts/dialogue.gd"

func _ready():
	dialogues = [
		"Welcome to the blood-altar, apprentice! Today, you will begin your flesh-conjuring journey, discreetly satisfying the summoning needs of our clients.",
		"I am William. Your humble flayed-servant.",
		"Lets begin with a simple Rattus Convocatio.",
		"Take the knife in hand, and carefully inscribe a modest circle at the altar's centere.",
		"Mistakes can be washed away with a damp sponge, or you may cleanse the entire altar using the contents of the roach jar.",
		"Once your inscription is complete, ignite every candle to finalize the ritual, and summon what may.",
		"Alas, I have long lost my eyes. Did you summon something? Was it good?",
		"Experiment with various sigils and observe what emerges from the gloom.",
		"Have you reveled enough in the bloodmagicks? Our initial patron now stands at our threshold. Shall I user them in?",
	]
	super()

# 'start the game' by summoning a creature with a request
@onready var character = preload("res://scenes/character.tscn")
func on_final():
	character.instantiate()
	queue_free()
