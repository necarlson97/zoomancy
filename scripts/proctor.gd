extends Node2D

# Dict of name->image
var sub_images = {}

var thread = Thread.new()
var stop_thread = false

# A candatate for which image fits best
class BestFit:
	var score = 0.01
	var image = null
	var name = ""
var current_best_fit = BestFit.new()

# Get and dispaly user/mask and whatnot
@onready var user_texture = get_tree().root.get_node("Main/DrawCanvas/TextureRect")
@onready var user_display = $UserRect
@onready var mask_display = $TextureRect
@onready var best_display = $BestRect

func _ready():
	$Button.pressed.connect(self.check)
	thread.start(self.update_best_fit)
	load_sub_images()
	
func load_sub_images():
	# Get all images for inner/outer/etc
	var region_name = name.replace("Proctor", "")
	var path = "res://textures/sub_images/"+region_name+"/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()  
	while file_name != "":
		var img = Image.new()
		if img.load(path+file_name) == OK:
			sub_images[file_name.replace('.png', '')] = img
			#print("Loaded: "+region_name+" "+file_name)
		file_name = dir.get_next()

func check():
	# Compare those desired pixels with an existing list of sub-images,
	# to find out which it is closest to, and how 'far off' the pixles are
	var best_fit = get_current_best_fit()
	
	# Also, print it's closeness_score
	print("best: "+best_fit.name+" "+str(best_fit.score))
	return best_fit
	
func get_current_best_fit():
	return current_best_fit

func _exit_tree():
	stop_thread = true
	thread.wait_to_finish()
	
func get_user_image():
	# Get the current user image from the DrawCanvas -> TextureTect
	var user_image = user_texture.get_texture().get_image()
	# Just for testing
	#user_image.save_png("res://temp_user_pixels.png")
	
	# 'and' the pixels with our black&white image showing the desired region,
	# to isolate the desired pixels
	var desired_region = mask_display.get_texture().get_image()
	return create_from_mask(desired_region, user_image)

func update_best_fit():
	while not stop_thread:
		current_best_fit = find_best_fit()
		OS.delay_msec(100)  # Delay to prevent hogging CPU resources
		
func find_best_fit() -> BestFit:
	var user_image = get_user_image()
	var best_fit = BestFit.new()
	for sub_name in sub_images:
		var sub_image = sub_images[sub_name]
		var score = compare_images(user_image, sub_image)
		#print("Comapring to "+str(sub_name)+" = "+str(score))
		if score > best_fit.score:
			best_fit.score = score
			best_fit.image = sub_image
			best_fit.name = sub_name.split('- ')[-1]
			
	# For the pixels in the deisred region, show them on the 'UserRect'
	user_display.call_deferred(
		"set_texture", ImageTexture.create_from_image(user_image))

	# For the closest matching image, show it in 'BestRect'
	if best_fit.image != null:
		best_display.call_deferred(
			"set_texture", ImageTexture.create_from_image(best_fit.image))
		# Just for testing
		#best_fit.image.save_png("res://temp_best.png")
	else:
		best_display.call_deferred("set_texture", null)
		
	return best_fit

func create_from_mask(image, mask):
	var result_image = Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var mask_pixel = mask.get_pixel(x, y)
			if mask_pixel.a > 0.5:  # Assuming mask is an alpha mask
				result_image.set_pixel(x, y, Color.WHITE)
			else:
				result_image.set_pixel(x, y, Color.TRANSPARENT)
				
	return result_image

func compare_images(user_image, mask_image):
	var ui = reduce_image_resolution(user_image)
	var mi = reduce_image_resolution(mask_image)
	
	var score = 0.0
	var total_red = 0
	for x in range(ui.get_width()):
		for y in range(ui.get_height()):
			var user_pixel = ui.get_pixel(x, y)
			var mask_pixel = mi.get_pixel(x, y)
			if mask_pixel == Color.RED:
				total_red += 1
				if user_pixel == Color.WHITE:
					score += 1
	return score / total_red

func reduce_image_resolution(image, scale_factor=0.5):
	var new_image = Image.new()
	new_image.copy_from(image)
	var new_width = int(new_image.get_width() * scale_factor)
	var new_height = int(image.get_height() * scale_factor)
	new_image.resize(new_width, new_height)
	return new_image
