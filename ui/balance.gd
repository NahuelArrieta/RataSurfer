extends Node

@onready var balance_minigame = preload("res://ui/balance_minigame.tscn")

var minigame_instance: Control

func _ready():
	print("BalanceTest iniciado - Presiona ENTER para mostrar el minijuego")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		show_balance_minigame()

func show_balance_minigame():
	if minigame_instance:
		minigame_instance.queue_free()
	
	minigame_instance = balance_minigame.instantiate()
	get_tree().current_scene.add_child(minigame_instance)
	
	# Conectar señales
	minigame_instance.success.connect(_on_minigame_success)
	minigame_instance.fail.connect(_on_minigame_fail)
	
func _on_minigame_success():
	print("¡Minijuego completado con éxito!")
	# Lógica cuando el jugador gana el minijuego

func _on_minigame_fail():
	print("Minijuego fallido")
	# Lógica cuando el jugador pierda el minijuego
