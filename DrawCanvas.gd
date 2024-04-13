extends Node2D

# Member variables
var draw_texture: ImageTexture
var draw_image: Image
var brush_size: int = 4

# Colors
var bg_color = Color.BEIGE
var fg_color = Color.html("#721817")

# Store the last position, for smoother lines
var last_pos: Vector2

func _ready():
	# Initialize the drawing surface
	draw_image = Image.create(512, 512, false, Image.FORMAT_RGBA8)  # Set size and format
	draw_image.fill(bg_color)

	draw_texture = ImageTexture.create_from_image(draw_image)
	$TextureRect.texture = draw_texture  # Assign texture to TextureRect for display

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		last_pos = event.position
		update_drawing(event.position)
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		update_drawing(event.position)
		last_pos = event.position

func update_drawing(pos):
	#draw_image.fill_rect(Rect2(pos.x - brush_size / 2, pos.y - brush_size / 2, brush_size, brush_size), Color(0, 0, 0, 1))
	if last_pos != null:
		interpolate_draw(last_pos, pos)
	draw_texture.set_image(draw_image)
	
func interpolate_draw(from, to):
	# Draw line
	var distance = from.distance_to(to)
	var steps = max(distance / brush_size, 1)

	for i in range(steps + 1):
		var lerp_pos = from.lerp(to, i / steps)
		draw_image.fill_rect(Rect2(lerp_pos.x - brush_size / 2, lerp_pos.y - brush_size / 2, brush_size, brush_size), fg_color)
