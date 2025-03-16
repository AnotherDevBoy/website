extends CharacterBody2D

@export var speed = 200
var TILE_SIZE = 48
var is_moving = false
var target_position: Vector2
var direction = Vector2.ZERO
var last_direction = Vector2.DOWN

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast2D = $RayCast2D

func _ready():
	target_position = position
	animation_player.play("idle_down")

func _physics_process(delta: float) -> void:
	if is_moving:
		move_towards_target(delta)
	else:
		handle_input()

func handle_input():
	var new_direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		new_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		new_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left"):
		new_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		new_direction = Vector2.RIGHT

	if new_direction != Vector2.ZERO and not is_moving:
		check_and_start_movement(new_direction)

func check_and_start_movement(new_direction: Vector2):
	raycast.target_position = new_direction * TILE_SIZE
	raycast.force_raycast_update()

	if raycast.is_colliding():
		return

	start_movement(new_direction)

func start_movement(new_direction: Vector2):
	is_moving = true
	direction = new_direction
	last_direction = direction
	target_position = position + (direction * TILE_SIZE)

	var anim = get_walk_animation(direction)
	if animation_player.current_animation != anim:
		animation_player.play(anim)

func move_towards_target(delta):
	position = position.move_toward(target_position, speed * delta)
	
	if position == target_position:
		is_moving = false
		direction = Vector2.ZERO # Reset direction for new input
		play_idle_animation() # Play idle animation based on last movement

func get_walk_animation(dir: Vector2) -> String:
	if dir == Vector2.UP:
		return "walk_up"
	elif dir == Vector2.DOWN:
		return "walk_down"
	elif dir == Vector2.LEFT:
		return "walk_left"
	elif dir == Vector2.RIGHT:
		return "walk_right"
	return "idle_down"

func get_idle_animation() -> String:
	if last_direction == Vector2.UP:
		return "idle_up"
	elif last_direction == Vector2.DOWN:
		return "idle_down"
	elif last_direction == Vector2.LEFT:
		return "idle_left"
	elif last_direction == Vector2.RIGHT:
		return "idle_right"
	return "idle_down" # Default fallback

func play_idle_animation():
	var idle_anim = get_idle_animation()
	if animation_player.current_animation != idle_anim or not animation_player.is_playing():
		animation_player.play(idle_anim)
