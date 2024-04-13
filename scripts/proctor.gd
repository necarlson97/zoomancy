extends Node2D

var sub_textures: Array[Texture] = []

func _ready():
	$Button.pressed.connect(self.check)
	sub_textures = load_sub_textures()
	
func load_sub_textures() -> Array[Texture]:
	# Get all images for inner/outer/etc
	var region_name = name.replace("Proctor", "")
	var path = "res://textures/sub_images/"+region_name+"/"
	var texs: Array[Texture]
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()  
	while file_name != "":
		var img = Image.new()
		if img.load(path+file_name) == OK:
			var tex = ImageTexture.create_from_image(img)
			texs.append(tex)
			print("Loaded: "+region_name+" "+file_name+" - "+tex.get_path().get_file())
		file_name = dir.get_next()
	return texs

func check():
	# Get the current user image from the DrawCanvas -> TextureTect
	var user_texture = get_tree().root.get_node("Main/DrawCanvas/TextureRect")
	var user_image = user_texture.get_texture().get_image()
	
	# 'and' the pixels with our black&white image showing the desired region,
	# to isolate the desired pixels
	var desired_region = $TextureRect.get_texture().get_image()
	var user_pixels = create_from_mask(desired_region, user_image)
	
	# Just for testing
	user_pixels.save_png("res://temp_user_pixels.png")
	
	# For the pixels in the deisred region, show them on the 'UserRect'
	$UserRect.texture = ImageTexture.create_from_image(user_pixels)
	
	# Compare those desired pixels with an existing list of sub-images,
	# to find out which it is closest to, and how 'far off' the pixles are
	var best_score = 0.1
	var best_image = null
	var best_image_name = "blob"
	for tex in sub_textures:
		var sub_name = tex.get_path().get_file()
		var sub_image = tex.get_image()
		var score = compare_images(user_pixels, sub_image)
		print("Comapring to "+str(sub_name)+" = "+str(score))
		if score > best_score:
			best_score = score
			best_image = sub_image
			best_image_name = sub_name.split('- ')[-1].replace('.png', '')
		
	# For the closest matching image, show it in 'BestRect'
	$BestRect.texture = ImageTexture.create_from_image(best_image)
	# Just for testing
	if best_image != null:
		best_image.save_png("res://temp_best.png")
	# Also, print it's closeness_score
	print("best: "+best_image_name+" "+str(best_score))
	return [best_image_name, best_score]
	
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
	var score = 0.0
	var total_red = 0
	for x in range(user_image.get_width()):
		for y in range(user_image.get_height()):
			var user_pixel = user_image.get_pixel(x, y)
			var mask_pixel = mask_image.get_pixel(x, y)
			if mask_pixel == Color.RED:
				total_red += 1
				if user_pixel == Color.WHITE:
					score += 1
	return score / total_red
