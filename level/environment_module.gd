extends CharacterBody3D

const SPEED := 23

func _ready() -> void:
	velocity = Vector3(0, 0, SPEED)

func _physics_process(delta: float) -> void:
	move_and_slide()
