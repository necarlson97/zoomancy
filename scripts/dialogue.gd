extends Node

# Dialogue content
var dialogues = [
	"Hello, world! This is the first line of dialogue.",
	"Here's the second line, isn't this exciting?",
	"And finally, this is the last line. Goodbye!"
]
var current_dialogue_index = 0
var chars_displayed = 0
var is_typing = false

# Nodes
@onready var text_label = $Label
@onready var next_button = $Button

func _ready():
	next_button.pressed.connect(self.next_click)
	start_typing()

func _process(delta):
	if is_typing:
		type_out(delta)

func type_out(delta):
	if chars_displayed < dialogues[current_dialogue_index].length():
		chars_displayed += 1
		text_label.text = dialogues[current_dialogue_index].substr(0, chars_displayed)
	else:
		is_typing = false

func next_click():
	if is_typing:
		# Finish the current typing immediately if button is pressed during typing
		chars_displayed = dialogues[current_dialogue_index].length()
		text_label.text = dialogues[current_dialogue_index]
		is_typing = false
	else:
		# Move to next dialogue
		current_dialogue_index += 1
		if current_dialogue_index < dialogues.size():
			start_typing()
		else:
			queue_free()  # Remove the dialogue system from the scene

func start_typing():
	chars_displayed = 0
	is_typing = true
	text_label.text = ""
