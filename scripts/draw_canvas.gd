extends Node2D

# Member variables
var draw_texture: ImageTexture
var draw_image: Image
var brush_size: int = 4
var eraser_size: int = 50

# Colors
var bg_color = Color.TRANSPARENT
var fg_color = Color.html("#721817")

# Store the last position, for smoother lines
var last_pos: Vector2

var current_color = fg_color
var current_size = brush_size

func _ready():
	# Initialize the drawing surface
	draw_image = Image.create(512, 512, false, Image.FORMAT_RGBA8)  # Set size and format
	draw_texture = ImageTexture.create_from_image(draw_image)
	$TextureRect.texture = draw_texture  # Assign texture to TextureRect for display
	clear()
	
	# Assign buttons
	$ClearButton.pressed.connect(self.button_clear)
	
func _process(delta):
	# Sloppy but eh
	if Grabbable.held == null: equip_nothing()
	elif Grabbable.held.name == 'Knife': equip_knife()
	elif Grabbable.held.name == 'Sponge': equip_eraser()
	else: equip_nothing()
	
func clear():
	draw_image.fill(bg_color)
	draw_texture.set_image(draw_image)

func button_clear():
	get_node("ClearButton/GPUParticles2D").restart()
	clear()
	
func equip_eraser():
	current_color = bg_color
	current_size = eraser_size
	
func equip_knife():
	current_color = fg_color
	current_size = brush_size

func equip_nothing():
	current_color = bg_color
	current_size = 0

func _input(event):
	if "position" not in event:
		return
	var pos = event.position - self.position
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		last_pos = pos
		update_drawing(pos)
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		update_drawing(pos)
		last_pos = pos

func update_drawing(pos):
	if brush_size == 0:
		return
	if last_pos != null:
		interpolate_draw(last_pos, pos)
	draw_texture.set_image(draw_image)
	
func interpolate_draw(from, to):
	# Draw line
	var distance = from.distance_to(to)
	var steps = max(distance / current_size, 1)

	for i in range(steps + 1):
		var lerp_pos = from.lerp(to, i / steps)
		draw_image.fill_rect(Rect2(
			lerp_pos.x - current_size / 2,
			lerp_pos.y - current_size / 2,
			current_size, current_size),
			current_color)
