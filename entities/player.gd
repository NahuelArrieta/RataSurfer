extends CharacterBody3D

signal player_died
signal started_sliding
signal stopped_sliding
signal lost_minigame


func _on_movement_handler_started_sliding() -> void:
	started_sliding.emit()


func _on_movement_handler_stopped_sliding() -> void:
	stopped_sliding.emit()


func _on_balance_minigame_random_zone_out() -> void:
	lost_minigame.emit()


func _on_animation_player_death_animation_finished() -> void:
	player_died.emit()
