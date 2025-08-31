extends Node

func _process(delta):
	# Debug: mostrar estado del sliding si es posible
	var movement_handler = get_node_or_null("/root/Level/Player/MovementHandler")
	if movement_handler:
		var is_sliding = movement_handler.is_sliding()
		if is_sliding:
			print("DEBUG: Jugador está deslizándose")
