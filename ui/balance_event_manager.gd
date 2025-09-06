extends Node

signal minigame_requested
signal minigame_completed(success: bool)

var balance_minigame = preload("res://ui/balance_minigame.tscn")
var minigame_instance: Control
var movement_handler: Node
var was_sliding: bool = false

func _ready():
	await get_tree().process_frame
	movement_handler = get_node_or_null("/root/Level/Player/MovementHandler")
	
func _process(delta):
	if not movement_handler:
		return
	
	# Verificar si el jugador está deslizándose
	var is_sliding = movement_handler.is_sliding()
	
	# Si acaba de empezar a deslizarse y no estaba deslizándose antes
	if is_sliding and not was_sliding:
		request_minigame()
	
	# Si está deslizándose, verificar si la tubería ha terminado
	if is_sliding and minigame_instance and minigame_instance.is_active:
		if movement_handler.check_pipe_end():
			# La tubería ha terminado, forzar fallo del minijuego
			minigame_instance.force_fail()
	
	was_sliding = is_sliding

func request_minigame():
	minigame_requested.emit()
	show_balance_minigame()

func show_balance_minigame():
	if minigame_instance:
		minigame_instance.queue_free()
	
	minigame_instance = balance_minigame.instantiate()
	get_tree().current_scene.add_child(minigame_instance)
	
	# Conectar señales con CONNECT_ONE_SHOT 
	#minigame_instance.success.connect(_on_minigame_success, CONNECT_ONE_SHOT)
	minigame_instance.random_zone_out.connect(_on_minigame_fail, CONNECT_ONE_SHOT)
	
func _on_minigame_success():
	if movement_handler:
		movement_handler.stop_sliding()
	minigame_completed.emit(true)

func _on_minigame_fail():
	if movement_handler:
		movement_handler.stop_sliding()
	minigame_completed.emit(false)

# Función pública para lanzar el minijuego desde otros scripts
func launch_minigame():
	request_minigame()
