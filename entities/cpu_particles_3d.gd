extends CPUParticles3D



func _on_movement_handler_player_jumped() -> void:
	emitting = false


func _on_movement_handler_started_sliding() -> void:
	emitting = false # this doesn't work for some reason


func _on_movement_handler_stopped_sliding() -> void:
	if not emitting:
		emitting = true


func _on_movement_handler_moved_left() -> void:
	if not emitting:
		emitting = true


func _on_movement_handler_moved_right() -> void:
	if not emitting:
		emitting = true
