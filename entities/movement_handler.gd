extends Node

@onready var player: CharacterBody3D = $".."

@export var distancia_carriles := 5


var carril := -1

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("left") and carril > -1 :
		player.position.x -= distancia_carriles
		carril -= 1
	elif Input.is_action_just_pressed("right")and carril < 1:
		player.position.x += distancia_carriles
		carril += 1
	
