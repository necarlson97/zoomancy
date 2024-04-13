extends Node2D

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

func average(numbers: Array) -> float:
	var sum := 0.0
	for n in numbers:
		sum += n
	return sum / numbers.size()
	
func check_all():
	var imgs = []
	var scores = []
	# Unpack image name and user's score to list
	for n in ["ProctorInner", "ProctorMiddle", "ProctorOuter"]:
		var best = get_node(n).check()
		imgs.append(best[0])
		scores.append(best[1])
	
	var final_score = average(scores)
	print("Final: "+str(final_score)+" "+str(imgs))
	
func summon(imgs, score):
	# Summon the creature, with all it's stuff, and add to score, etc
	print("Summoning with "+str(imgs)+" "+str(score))
