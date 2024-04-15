extends Node2D
# Keeps track of winning
var res = {
	"perfect": 0,
	"great": 0,
	"okay": 0,
	
	"good": 0,
	"bad": 0,
	
	"clients": 0,
	"summons": 0,
}

@onready var on_screen = $OnScreen.position
@onready var off_screen = $Scroll.position
@onready var target = off_screen

var text_formatter = """%s

Summoned %s creatures
You served %s clientele 
	[color=#FFAF72]%s elated[/color]
	[color=#C2847A]%s happy[/color]
	[color=#848586]%s satisfied[/color]
	[color=#721817]%s begrudged[/color]
You unlocked [color=#000000]%s / %s [/color] of the Sanguine Codex
"""

func _ready():
	set_text()
	get_node("Scroll/Button").pressed.connect(self.keep_playing)
	$Button.pressed.connect(self.get_on_screen)
	
	# Just for debug purposes
	$HappyButton.pressed.connect(self.force_happy)
	$SadButton.pressed.connect(self.force_sad)

func _process(delta):
	$Scroll.position = lerp($Scroll.position, target, delta*10)

var last_shown = 0 
func completed_client(was_correct: bool):
	if was_correct: res["good"] += 1
	else: res["bad"] += 1
	res["clients"] += 1
	set_text()
	
	if res["good"] != last_shown and res["good"] % 10 == 0:
		get_on_screen()
		last_shown = res["good"]

func summoned(creature):
	res["summons"] += 1
	if creature:
		res[creature.features.score_category()] += 1


func set_text():
	var codex = get_parent().get_node("Codex")
	var text_values = [
		"Congradulations!" if res["good"] >= 10 else "Looking good",
		res['summons'],
		res['clients'],
		res['perfect'],
		res['great'],
		res['okay'],
		res['bad'],
		codex.get_total_progress(), codex.get_max_progress(),
	]
	get_node("Scroll/RichTextLabel").text = text_formatter % text_values
	
	# Also set lights
	var progress = res["good"] % 10
	for i in range(1,11):
		var l = get_node("Lights/"+str(i)+"/fg")
		l.visible = (i <= progress)

func get_on_screen():
	if target == on_screen: target = off_screen
	else: target = on_screen

func keep_playing():
	target = off_screen
	

# Debug
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_9: force_sad()
		if event.keycode == KEY_0: force_happy()
		
func force_happy(): completed_client(true)
func force_sad(): completed_client(false)
