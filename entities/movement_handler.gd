extends Node

@onready var player: CharacterBody3D = $".."
@onready var right_ray: RayCast3D = $"../RightRay"
@onready var left_ray: RayCast3D = $"../LeftRay"
@export var lane_size := 5


func _ready() -> void:
	# Move the rays to the sides
	right_ray.set_target_position(Vector3(lane_size, 0, 0))
	left_ray.set_target_position(Vector3(-lane_size, 0, 0))
	
var lane := 0

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
	player.position.x += lane_size * direction
	lane = new_lane


func start_sliding(direction):
	if !can_slide(direction):
		return
	player.position.x += lane_size * direction
	player.position.y = lane_size ##TODO
	lane += 1 * direction
	


func can_slide(direction) -> bool:
	var rayCast: RayCast3D
	if direction > 0: 
		rayCast = right_ray
	else: 
		rayCast = left_ray
	
	return rayCast.is_colliding()
		

func handle_slide_movement():
	if Input.is_action_just_pressed("down"):
		stop_sliding()
		
func stop_sliding():
	if lane == -2: 
		lane = -1
		player.position.x += lane_size
	else: 
		lane = 1
		player.position.x -= lane_size
	player.position.y = 0
