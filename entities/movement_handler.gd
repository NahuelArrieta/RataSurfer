extends Node

signal started_sliding
signal stopped_sliding
signal player_jumped
signal moved_right
signal moved_left
signal lost_minigame_and_is_sliding

@onready var player: CharacterBody3D = $".."
@onready var right_ray: RayCast3D = $"../RightRay"
@onready var left_ray: RayCast3D = $"../LeftRay"
@onready var jump_timer: Timer = $JumpTimer

@export var lane_size := 5

var movement_disabled := false
var is_jumping := false

func _ready() -> void:
	# Move the rays to the sides
	right_ray.set_target_position(Vector3(lane_size, 0, 0))
	left_ray.set_target_position(Vector3(-lane_size, 0, 0))
	
var lane := 0
# Variable para guardar la dirección de deslizamiento
var sliding_dir: int = 0  # -1 izquierda, 1 derecha

func is_sliding() -> bool:
	return abs(lane) == 2

func _snap_player_to_lane() -> void:
	# No sumes, seteá en función del lane (determinístico)
	player.position.x = lane * lane_size
	
func _physics_process(delta: float) -> void:
	if movement_disabled: # used when dead
		return
	
	if not is_sliding():
		handle_lane_movement()
	elif is_sliding() and check_pipe_end():
		stop_sliding()

## Takes left, right and jump input and executes it
func handle_lane_movement():
	if Input.is_action_just_pressed("left"):
		handle_x_movement(-1)
		moved_left.emit()
		
	elif Input.is_action_just_pressed("right"):
		handle_x_movement(1)
		moved_right.emit()
	
	if Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		player_jumped.emit()
		player.position += Vector3(0, 2.5, 0)
		jump_timer.start()

## Checks if it's sliding and snaps player to lane
func handle_x_movement(direction): 
	var new_lane: int = lane + 1 * direction
	if new_lane < -1 or new_lane > 1:
		start_sliding(direction)
		return
	lane = new_lane
	_snap_player_to_lane()

## Changes player pos and lane
func start_sliding(direction):
	if !can_slide(direction):
		return
	
	started_sliding.emit()
	# Guardar la dirección de deslizamiento (1 o -1)
	sliding_dir = direction
	
	lane += 1 * direction
	
	player.position.x = 7 * direction
	player.position.y = 1.5

## Checks if raycast is colliding with pipe and player not jumping
func can_slide(direction) -> bool:
	var rayCast: RayCast3D
	if direction > 0: 
		rayCast = right_ray
	else: 
		rayCast = left_ray
	
	return rayCast.is_colliding() and not is_jumping

## Verifica si la tubería ha terminado
func check_pipe_end() -> bool:
	if not is_sliding():
		return false
	
	var rayCast: RayCast3D
	if sliding_dir > 0:
		rayCast = right_ray
	else:
		rayCast = left_ray
	
	# Si ya no hay colisión, la tubería ha terminado
	return not rayCast.is_colliding()

func stop_sliding():
	
	stopped_sliding.emit()
	if lane == -2:
		lane = -1
	else: 
		lane = 1
	player.position.y -= 1.5
	_snap_player_to_lane()

## Jump fall animation
func _on_jump_timer_timeout() -> void:
	player.position -= Vector3(0, 2.5, 0)
	is_jumping = false


func _on_player_lost_minigame() -> void:
	if is_sliding(): # Might dodge bug where it activates when the minigame ends 2 times because of hitboxes
		stop_sliding()
		lost_minigame_and_is_sliding.emit()


func _on_gameover_area_3d_area_entered(area: Area3D) -> void:
	movement_disabled = true
