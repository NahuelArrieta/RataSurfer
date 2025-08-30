extends Node

signal minigame_requested
signal minigame_completed(success: bool)

var balance_minigame = preload("res://ui/balance_minigame.tscn")
var minigame_instance: Control
var movement_handler: Node
var was_sliding: bool = false

func _ready():
	print("BalanceEventManager iniciado")
	# Buscar el movement_handler del jugador
	await get_tree().process_frame
	movement_handler = get_node_or_null("/root/Level/Player/MovementHandler")
	if movement_handler:
		print("MovementHandler encontrado, monitoreando sliding...")
	else:
		print("MovementHandler no encontrado")

func _process(delta):
	if not movement_handler:
		return
	
	# Verificar si el jugador está deslizándose
	var is_sliding = movement_handler.is_sliding()
	
	# Si acaba de empezar a deslizarse y no estaba deslizándose antes
	if is_sliding and not was_sliding:
		print("¡Jugador empezó a deslizarse! Activando minijuego...")
		request_minigame()
	
	was_sliding = is_sliding

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
	if movement_handler:
		movement_handler.stop_sliding()
	minigame_completed.emit(true)

func _on_minigame_fail():
	print("Minijuego fallido")
	if movement_handler:
		movement_handler.stop_sliding()
	minigame_completed.emit(false)

# Función pública para lanzar el minijuego desde otros scripts
func launch_minigame():
	request_minigame()
