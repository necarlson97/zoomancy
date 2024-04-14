extends Node
class_name Dialogue

# Dialogue content
var chars_displayed = 0
var is_typing = false

# Nodes
@onready var text_label = $Label

class TextBlock:
	# A chunk of dialogue that, at the end, we may repeat,
	# with some kind of check
	var check_func = self.default_check
	var all_dialogue = [
		"Hello, world! This is the first line of dialogue.",
		"Here's the second line, isn't this exciting?",
		"And finally, this is the last line. Goodbye!"
	]
	var failed_check = [
		"Uh oh! Try again?",
	]
	var passed_check = [
		"Congrats!",
	]
	var passed = false
	
	var hopper = []
	
	func _init(dialogues=["todo"], passed_dia=[], failed_dia=[], check=null):
		all_dialogue = dialogues
		passed_check = passed_dia
		failed_check = failed_dia
		if check != null: check_func = check
		
		hopper = all_dialogue.duplicate()
		if passed_check == [] and failed_check == []:
			print("No pass / fail, will move on")
			passed = true
	
	func next() -> String:
		check_hopper()
		hopper.pop_front()
		return peek()
	
	func peek() -> String:
		check_hopper()
		if hopper == []: return ""
		return hopper[0]
		
	func check_hopper():
		# TODO what do we do here?
		if hopper == []: refil_hopper()
	
	func refil_hopper():
		var result = self.check_func.call()
		if result: 
			hopper = passed_check.duplicate()
			passed = true
		else: hopper = failed_check.duplicate()
		
	func remaining(): return hopper.size()
	
	func default_check(): return true

# List of text blocks to complete
var blocks = [TextBlock.new()]

func _ready():
	$Button.pressed.connect(self.next_click)
	$FinalButton.pressed.connect(self.on_final)
	_load_audio_clips()
	start_typing()

func _process(delta):
	if is_typing:
		type_out()

func type_out():
	if chars_displayed < peek().length():
		chars_displayed += 1
		text_label.text = peek().substr(0, chars_displayed)
		_play_sound_for_letter()
	else:
		is_typing = false

func next_click():
	if is_typing:
		# Finish the current typing immediately if button is pressed during typing
		chars_displayed = peek().length()
		text_label.text = peek()
		is_typing = false
		return
	# Move to next dialogue
	next()
	start_typing()
	check_buttons()

func check_buttons():
	if blocks[0].remaining() <= 1 and blocks[0].passed:
		$Button.visible = false
		$FinalButton.visible = true
	else:
		$Button.visible = true
		$FinalButton.visible = false
		
	if blocks[0].remaining() == 1: $Button.text = "check"
	else: $Button.text = ">"
	
func next():
	var next_dialogue = blocks[0].next()
	if blocks[0].hopper.size() == 0:
		next_block()
		next_dialogue = blocks[0].peek()
	return next_dialogue

func next_block():
	if blocks.size() > 1: blocks.pop_front()

func peek():
	return blocks[0].peek()

func on_final():
	# Remove the dialogue system from the scene
	# (will get shadowed by children
	print("Default final")
	queue_free()

func start_typing():
	chars_displayed = 0
	is_typing = true
	text_label.text = ""
	
# Handle audio
var audio_clips = []
@onready var audio_player = $Audio
var can_play = true
var pitch_start = randf_range(0.6, 1.3)
func _play_sound_for_letter():
	if not can_play: return
	var clip = audio_clips[randi() % audio_clips.size()]
	audio_player.stream = clip
	audio_player.pitch_scale = pitch_start + randf_range(-0.1, 0.1)
	audio_player.play()
	can_play = false
	await get_tree().create_timer(.2).timeout
	can_play = true

func _load_audio_clips():
	var dir = DirAccess.open(ProjectSettings.globalize_path("res://audio/speech"))
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
			var path = ProjectSettings.globalize_path("res://audio/speech/" + file_name)
			var clip = load(path)
			audio_clips.append(clip)
		file_name = dir.get_next()
	dir.list_dir_end()
