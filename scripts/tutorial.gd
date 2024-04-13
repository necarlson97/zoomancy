extends "res://scripts/dialogue.gd"

func _ready():
	dialogues = [
		"Welcome to the tutorial! Let's get started.",
		"Use the arrow keys to move your character.",
		"Press the space bar to jump. Try it now to proceed!"
	]
	super()._ready()

# 'start the game' by summoning a creature with a request
func on_final():
	# TODO
	print("Create character")
	pass
