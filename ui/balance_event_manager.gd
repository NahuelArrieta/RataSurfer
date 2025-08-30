extends Node

signal minigame_requested
signal minigame_completed(success: bool)

var balance_minigame = preload("res://ui/balance_minigame.tscn")
var minigame_instance: Control

func _ready():
	print("BalanceEventManager iniciado")
	# Conectar al evento de ENTER global
	# También puedes emitir minigame_requested desde cualquier script

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		request_minigame()

func request_minigame():
	print("Solicitud de minijuego recibida")
	minigame_requested.emit()
	show_balance_minigame()

func show_balance_minigame():
	if minigame_instance:
		minigame_instance.queue_free()
	
	minigame_instance = balance_minigame.instantiate()
	get_tree().current_scene.add_child(minigame_instance)
	
	# Conectar señales
	minigame_instance.success.connect(_on_minigame_success)
	minigame_instance.fail.connect(_on_minigame_fail)
	
	print("Minijuego de equilibrio iniciado")

func _on_minigame_success():
	print("¡Minijuego completado con éxito!")
	minigame_completed.emit(true)

func _on_minigame_fail():
	print("Minijuego fallido")
	minigame_completed.emit(false)

# Función pública para lanzar el minijuego desde otros scripts
func launch_minigame():
	request_minigame()
