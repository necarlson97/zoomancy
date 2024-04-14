extends AudioStreamPlayer2D

func _ready():
	connect("finished", self._on_AudioStreamRandomizer_finished)

func _on_AudioStreamRandomizer_finished():
	play()  # Immediately play another random stream from the set
