extends Node2D
class_name Utils


class CreatureFeatures:
	var inner = "Blob"
	var middle = ""
	var outer = ""
	var score = 0.0
	var feature_array = []
	
	func _init(features: Array, sc: float):
		feature_array = features
		if features.size() >= 3:
			self.inner = features[0]
			self.middle = features[1]
			self.outer = features[2]
		self.score = sc
		
	func check_request(r):
		return r[0] == inner and r[1] == middle and r[2] == outer
		
	func score_category():
		if score > 0.25: return "perfect"
		elif score > 0.1: return "great"
		else: return "okay"
		
	func _to_string():
		return inner+", "+middle+", "+outer+" ("+str(score)+")"

static func average(numbers: Array) -> float:
	if (numbers.size() == 0): return 0
	var sum := 0.0
	for n in numbers:
		sum += n
	return sum / numbers.size()
	
# This function collects all nodes with a specific script in the given parent node
static func find_by_script(root, script_name):
	return find_by_script_recursive(root, script_name, [])
	
static func find_by_script_recursive(parent, script_name, found_nodes):
	# Check if the current node has the script attached
	var script_path = "res://scripts/"+script_name+".gd"
	if parent.script and parent.script.resource_path == script_path:
		return [parent]
	# Recursively search in children
	var l = []
	for child in parent.get_children():
		l += find_by_script_recursive(child, script_name, found_nodes)
	return l

static func title_case(s):
	var words = s.split(" ")
	for i in range(words.size()):
		if words[i].length() > 0:
			words[i] = words[i].substr(0, 1).to_upper() + words[i].substr(1).to_lower()
	return " ".join(words)

static func reduce_image_resolution(image, scale_factor=0.5):
	var new_image = Image.new()
	new_image.copy_from(image)
	var new_width = int(new_image.get_width() * scale_factor)
	var new_height = int(image.get_height() * scale_factor)
	new_image.resize(new_width, new_height)
	return new_image

static func safe_image_load(filepath):
	var image = Image.new()
	image.load(ProjectSettings.globalize_path(filepath))
	# TODO hacky?
	if image.is_empty(): return null
	return image
