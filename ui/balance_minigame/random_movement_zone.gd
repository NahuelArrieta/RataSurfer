extends Control

const LEFT_LIMIT := 0
const SPEED := 50
const RIGHT_LIMIT := 380

var random_direction := 0

func _physics_process(delta: float) -> void:
	_random_movement(delta)

func _random_movement(delta: float) -> void:
	
	if random_direction == -1 and position.x <= LEFT_LIMIT:
		return
	elif random_direction == 1 and position.x >= RIGHT_LIMIT:
		return
	
	position.x += SPEED * random_direction * delta

func _on_direction_timer_timeout() -> void:
	random_direction = randi_range(-1, 1)
