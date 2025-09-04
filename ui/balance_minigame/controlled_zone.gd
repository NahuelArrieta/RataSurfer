extends Control

const SPEED := 200

const LEFT_LIMIT := 0
const RIGHT_LIMIT := 280
const CENTER := 140

var direction := 0
var input_direction := 0

func _physics_process(delta: float) -> void:
	_controlled_movement(delta)

func _controlled_movement(delta: float) -> void:
	print(direction)
	if Input.is_action_pressed("left") and position.x >= LEFT_LIMIT:
		direction = -1
		input_direction = direction
	elif Input.is_action_pressed("right") and position.x <= RIGHT_LIMIT:
		direction = 1
		input_direction = direction
	elif round(position.x) == CENTER: # Makes the controlled zone not move when in center
		direction = 0
	else: # Makes the controlled zone return to center when not pressing anything
		direction = input_direction * -1
	
	position.x += SPEED * direction * delta
