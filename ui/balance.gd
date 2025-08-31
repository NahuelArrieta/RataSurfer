extends Node

@onready var balance_minigame = preload("res://ui/balance_minigame.tscn")

var minigame_instance: Control

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		show_balance_minigame()

func show_balance_minigame():
	if minigame_instance:
		minigame_instance.queue_free()
	
	minigame_instance = balance_minigame.instantiate()
	get_tree().current_scene.add_child(minigame_instance)
