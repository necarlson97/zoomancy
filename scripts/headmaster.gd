extends Node2D
class_name Headmaster

#TODO what combinations do we want?
# Inner (animal)
# blob - none - fail
# cat - large circle - easy
# rat - small circle  - easy 
# dog - square - easy
# bird - triangle - easy
# bat - inverted triangle - medium
# rabbit - middle cirlce - medium
# frog - 4 lines - medium
# turtle - 8 lines - medium
# deer - circle and 4 lines - hard
# cow - square and 8 lines - hard

# Middle (additions)
# none - none - easy
# hat - 2 lines - easy
# angel wings - square - easy
# devil wings - diamond - easy
# backpack - 4 star - medium
# horns - small circle - medium
# antlers - large circle - medium
# horns, antlers, and wings - square, small cirle, large cirlce - hard 

# Outer (effects):
# none - none - easy
# sparkling - square - medium
# flaming - diamond - medium
# toxic - small circle - hard
# electic - 8 poly - hard
# icy - 8 star - hard
func _ready():
	$Button.pressed.connect(self.check_all)

@onready var proctors = [$ProctorInner, $ProctorMiddle, $ProctorOuter]
func check_all():
	var names = []
	var scores = []
	# Unpack image name and user's score to list
	for n in proctors:
		var best = n.check()
		names.append(best.name)
		scores.append(best.score)
	
	if names[0] == "":
		names[0] = "blob"
	
	var final_score = Utils.average(scores)
	print("Final: "+str(final_score)+" "+str(names))
	
	# pack to send off
	return Utils.CreatureFeatures.new(names, final_score)

@onready var creature = preload("res://scenes/creature.tscn")
func evauluate_creature():
	var features = self.check_all()
	var new_creature = creature.instantiate()
	new_creature.set_features(features)
	return new_creature
	
