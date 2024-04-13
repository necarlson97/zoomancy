extends Node2D

var thread = Thread.new()
var sub_images = []  # This would be filled with your sub-image textures
var current_best_fit = null
var stop_thread = false
