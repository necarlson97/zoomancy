extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	check_candles()

@onready var candles = find_by_script("candle")
func check_candles():
	for candle in candles:
		if !candle.lit:
			return
	summon()
	for candle in candles:
		candle.lit = false
		candle.set_light()

@onready var headmaster = get_parent().get_node("Headmaster")
func summon():
	var new_creature = headmaster.evauluate_creature()
	new_creature.visible = true
	# TODO perfect particles or whatever
	
# This function collects all nodes with a specific script in the given parent node
func find_by_script(script_name):
	return find_by_script_recursive(get_tree().root, script_name, [])
	
func find_by_script_recursive(parent, script_name, found_nodes):
	# Check if the current node has the script attached
	var script_path = "res://scripts/"+script_name+".gd"
	if parent.script:
		print("Checking "+parent.script.resource_path+" against "+script_path)
	if parent.script and parent.script.resource_path == script_path:
		return [parent]
	# Recursively search in children
	var l = []
	for child in parent.get_children():
		l += find_by_script_recursive(child, script_name, found_nodes)
	return l
