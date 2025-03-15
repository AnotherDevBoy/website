extends CharacterBody2D

var TILE_SIZE = 48
var PLAYER_SPEED = 20000
var is_moving = false

var input_dir = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_down"):
		input_dir = Vector2(0,1)
		move()
	elif Input.is_action_pressed("ui_up"):
		input_dir = Vector2(0,-1)
		move()
	elif Input.is_action_pressed("ui_right"):
		input_dir = Vector2(1,0)
		move()
	elif Input.is_action_pressed("ui_left"):
		input_dir = Vector2(-1,0)
		move()

func move():
	if input_dir:
		if !is_moving:
			is_moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + input_dir*TILE_SIZE, 0.35)
			tween.tween_callback(stop_moving)

func stop_moving():
	is_moving = false;
