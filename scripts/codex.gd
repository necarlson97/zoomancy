extends Node2D

class Entry:
	# 1 for okay, 2 for good, 3 for perfect
	var progress = 0
	var name = ""
	var sub_image = null
	var creature_image = null
	func _init(n: String, all_creatures=null, proctors=null, s_img=null, c_img=null):
		self.name = n
		
		# For now, allowing null  for blob's sake
		#if s_img == null: s_img = find_sub_image(proctors)
		#assert(sub_image != null, "Could not find %s in %s " % [name, proctors])
		if s_img != null:
			print("Converting sub_image for %s"%name)
			sub_image = convert_mask(s_img)
		
		if c_img == null: c_img = all_creatures.texture_dict[name].get_image()
		creature_image = c_img
		assert(creature_image != null, "Could not find %s in creatures " % name)

	func find_sub_image(proctors):
		# TODO sloppy
		for p in proctors:
			if name in p.sub_images:
				sub_image = p.sub_images[name]

	func is_unlocked(): return progress > 0
	
	func convert_mask(mask):
		# Convert a mask to something easier for the user to see
		var image = Utils.reduce_image_resolution(mask, 0.25)
		for x in range(image.get_width()):
			for y in range(image.get_height()):
				var pixel = image.get_pixel(x, y)
				
				if pixel == Color.WHITE: image.set_pixel(x, y, Color.BLACK)
				elif pixel == Color.html('#727476'): continue
				elif pixel == Color.RED: image.set_pixel(x, y, Color.html("#721817"))
				else: image.set_pixel(x, y, Color.TRANSPARENT)
		
		return image

# Dict of name -> entry
var entries = {}

@onready var proctors = find_by_script("proctor")
func _ready():
	load_all()
	for k in entries:
		var entry = entries[k]
		assert(entry != null, "%s was null"%k)
		create_codex_entry(entry)
	update_progress()

# Just for qol
var order = [
	"blob", "rat", "rabbit", "cat", "dog", "bird", "bat",
	"turtle", "frog", "deer", "cow",
	"hat", "backpack", "angel", "devil", "horns", "antlers",
	"sparkling", "flaming", "toxic", "electric", "icy",
]
func load_all():
	# Proctors already loaded sub_images, steal that from them
	for k in order:
		entries[k] = null
	
	var all_creatures = get_parent().get_node("AllCreatures")
	for p in proctors:
		for k in p.sub_images:
			var v = p.sub_images[k]
			var new_name = k.split('- ')[-1]
			entries[new_name] = Entry.new(new_name, all_creatures, proctors, v)
	
	# Load blob seaperatly
	entries["blob"] = Entry.new("blob", all_creatures)
	
@onready var codex_entry_scene = preload("res://scenes/codex_entry.tscn")
@onready var list_container = get_node("ScrollContainer/VBoxContainer")
func create_codex_entry(entry):
	var new_entry = codex_entry_scene.instantiate()
	list_container.add_child(new_entry)
	new_entry.visible = true
	
	# Set stuff inside of it
	var st = ImageTexture.create_from_image(entry.sub_image)
	new_entry.get_node("SubImage").texture = st
	var ct = ImageTexture.create_from_image(entry.creature_image)
	new_entry.get_node("CreatureImage").texture = ct
	new_entry.name = entry.name
	
func update_progress():
	# Update the progress bars or whatever
	for k in entries:
		var v = entries[k]
		var ratio = 1-(v.progress / 3.0)
		var en = get_entity_node(k)
		en.get_node("ProgressBar").set_value(ratio * 100)
		var value = clamp(1-ratio, 0, 1)
		en.get_node("CreatureImage").modulate = Color.from_hsv(0, 0, value)
	get_parent().get_node("Referee").set_text()

func add_progress(k, xp):
	if k == "": return
	entries[k].progress = clamp(entries[k].progress + xp, 0, 3)
	get_entity_node(k).get_node("ProgressBar/Particles").restart()
	update_progress()

func get_entity_node(k):
	return list_container.get_node("%s"%k)
	
func find_by_script(script_name):
	return Utils.find_by_script_recursive(get_tree().root, script_name, [])
	
func get_total_progress():
	var sum = 0
	for k in entries:
		var entry = entries[k]
		sum += clamp(entry.progress, 0, 3)
	return sum

func get_max_progress():
	return entries.size() * 3
	
