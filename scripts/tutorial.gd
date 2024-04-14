extends "res://scripts/dialogue.gd"

func check_summon():
	return Utils.find_by_script(get_tree().root, "creature") != []
var rat_text = [
	"Lets begin with a simple Rattus Convocatio.",
	"Take the knife in hand, and carefully inscribe a modest circle at the altar's centere.",
	"(Mistakes can be washed away with a damp sponge, or you may cleanse the entire altar using the contents of the roach jar.)",
	"Once your inscription is complete, extinguish every candle to finalise the ritual, and summon what may.",
]
var bird_text = [
	"Try creating sigils in the middle and outer rings as well.",
	"Experiment with various sigils and observe what emerges from the gloom.",
	"Have you reveled enough in the bloodmagicks? Our initial patron now stands at our threshold.",
]
var start = [
	"Welcome to the blood-altar, apprentice! Today, you will begin your flesh-conjuring journey, discreetly satisfying the summoning needs of our clients.",
	"I am William. Your humble flayed-servant.",
] + rat_text
var passed = [
	"Ah hah! I heard something!",
	"Alas, I have long lost my eyes. Did you summon something? Was it good?",
] + bird_text + ["Shall I usher them in?"]
var failed = [
	"Did you summon something yet?",
	"Left click to pickup the knife or sponge. Right click to drop.",
	"Draw a shape on the altar, then click each of the 3 candles at the top."
]
	
func _ready():
	pitch_start = 0.5
	$FinalButton.text = "begin!"
	blocks = [TextBlock.new(start, passed, failed, check_summon)]
	$SkipButton.pressed.connect(self.start_game)
	super()

func _process(delta):
	super._process(delta)
	$ExampleRat.global_position  = get_parent().get_node("DrawCanvas/Canvas").global_position
	$ExampleRat.visible = (peek() in rat_text + failed)
	$ExampleBird.global_position  = get_parent().get_node("DrawCanvas/Canvas").global_position
	$ExampleBird.visible = (peek() in bird_text)

func on_final():
	start_game()

func start_game():
	get_parent().get_node("Summoner").next_client()
	queue_free()
