extends Node2D
class_name Grabbable

static var held: Node2D = null
static func get_held():
	return Grabbable.held
	
@onready var home = global_position
@onready var target = home

# How far to pickup/drop off
var radius = 100
var speed = 20

func _ready():
	home = global_position  # Save the initial position as home

func is_held():
	return self == get_held()

func _input(event):
	if not (event is InputEventMouseButton):
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_held() and home.distance_to(get_global_mouse_position()) < radius:
			grab()
		elif is_held() and global_position.distance_to(home) < radius:
			drop()
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		drop()
		
func drop():
	if $HeldParticles: $HeldParticles.emitting = false
	if $Audio: $Audio.play()
	Grabbable.held = null
	target = home

func grab():
	if Grabbable.held != null:
		Grabbable.held.drop()
	Grabbable.held = self
	$HeldParticles.emitting = true
	get_parent().get_node("GrabParticles").restart()
	if $Audio: $Audio.play()

func _process(delta):
	if is_held():
		target = get_global_mouse_position()
	global_position = lerp(global_position, target, delta*speed)
