extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var current_emotion = ""

func _ready():
	hide()  # Hide it initially

# Function to set and show an emotion
func show_emotion(emotion_type: String):
	if current_emotion == emotion_type:
		return  # Don't restart if already showing the same emotion

	current_emotion = emotion_type

	if animated_sprite.sprite_frames.has_animation(emotion_type):
		animated_sprite.play(emotion_type)  # Play selected animation
		show()
	else:
		push_warning("Emotion animation '%s' not found" % emotion_type)

func hide_emotion():
	hide()
	animated_sprite.stop()
	current_emotion = ""
