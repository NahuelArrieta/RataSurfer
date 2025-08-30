extends Node

@onready var player: CharacterBody3D = $".."

@export var distancia_carriles := 5

var lane := -1

func is_sliding() -> bool:
	return abs(lane) == 2
		

func _physics_process(delta: float) -> void:
	if is_sliding():
		handle_slide_movement()
	else: 
		handle_lane_movement()


func handle_lane_movement():
	if Input.is_action_just_pressed("left"):
		handle_x_movement(-1)
		
	elif Input.is_action_just_pressed("right"):
		handle_x_movement(1)


func handle_x_movement(direction): 
	var new_lane: int = lane + 1 * direction
	if new_lane < -1 or new_lane > 1:
		start_sliding(direction)
		return
	player.position.x += distancia_carriles * direction
	lane = new_lane


func start_sliding(direction):
	## TODO check if sliding is allowed
	player.position.x += distancia_carriles * direction
	player.position.y = distancia_carriles ##TODO
	lane += 1 * direction


func handle_slide_movement():
	if Input.is_action_just_pressed("down"):
		stop_sliding()
		
func stop_sliding():
	if lane == -2: 
		lane = -1
		player.position.x += distancia_carriles
	else: 
		lane = 1
		player.position.x -= distancia_carriles
	player.position.y = 0
