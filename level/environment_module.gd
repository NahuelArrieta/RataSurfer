extends CharacterBody3D

func _ready() -> void:
	velocity = Vector3(0, 0, 30)

func _physics_process(delta: float) -> void:
	move_and_slide()
