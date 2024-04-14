extends Node2D
# Summons creatures AND the characters that buy them

var current_client = null
var current_creature = null

@onready var character = preload("res://scenes/character.tscn")
func next_client():
	# TODO set timer on deleting old customer
	var characters = find_by_script("character")
	for c in characters:
		c.go_away()
	# Create new
	current_client = character.instantiate()
	get_parent().add_child(current_client)
	current_client.visible = true

func client_check(character):
	if current_creature == null:
		return "nothing"
	
	var cc = current_creature  # shorthand
	var fc = cc.features
	var is_correct = fc.check_request(character.request)
	
	if is_correct: score_particles(current_creature)
	
	current_creature.character = character
	current_creature = null
	
	get_parent().get_node("Referee").completed_client(is_correct, cc)
	
	if is_correct: return "good"
	else: return "bad"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var proctors = find_by_script("proctor")
func _process(delta):
	set_blackout(delta)
	check_candles()
	
	for proctor in proctors:
		var best_fit = proctor.get_current_best_fit()
		var has_guess = (best_fit!= null and best_fit.name != "")
		set_particle(proctor.name.replace("Proctor", ""), has_guess)

@onready var candles = find_by_script("candle")
func check_candles():
	for candle in candles:
		if candle.lit:
			return
	summon()
	for candle in candles:
		candle.slow_light()

@onready var headmaster = get_parent().get_node("Headmaster")
@onready var draw_canvas = get_parent().get_node("DrawCanvas")
func summon():
	$SummonParticle.restart()
	blackout()
	var creature = find_by_script("creature")
	for c in creature:
		c.queue_free()
		$BloodParticle.restart()
		
	current_creature = headmaster.evauluate_creature()
	get_parent().add_child(current_creature)
	current_creature.visible = true
	current_creature.position = self.position

	draw_canvas.clear()
	score_particles(current_creature)
	
func set_particle(particle_name, emitting=true):
	get_node(particle_name+"Particles").emitting = emitting
	
func score_particles(creature):
	var scoreParticles = Utils.title_case(creature.features.score_category())+"Particles"
	get_node(scoreParticles).restart()
	
var blackout_speed = 3
func set_blackout(delta):
	var alpha = $BlackOut.modulate.a
	alpha = lerp(alpha, 0.0, delta * blackout_speed)
	$BlackOut.modulate = Color(0, 0, 0, alpha)
	
func blackout():
	$BlackOut.modulate = Color(0, 0, 0, 0.8)
	
func find_by_script(script_name):
	return Utils.find_by_script_recursive(get_tree().root, script_name, [])
	
