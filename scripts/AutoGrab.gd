extends Area2D

# Signal to the parent or an external handler that the brush should be equipped
signal brush_equipped(enabled)
@onready var knife = get_parent().get_node("Knife")

func _ready():
	# Move hover-over to desired place
	global_position = get_tree().root.get_node("Main/DrawCanvas/Canvas").global_position
	connect("mouse_entered", self._on_mouse_entered)
	connect("mouse_exited", self._on_mouse_exited)

func _on_mouse_entered():
	if Grabbable.held == null: knife.grab()

func _on_mouse_exited():
	if Grabbable.held == knife: knife.drop()
