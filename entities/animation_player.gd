extends AnimationPlayer

signal death_animation_finished

func _on_movement_handler_player_jumped() -> void:
	play("jump")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump":
		play("idle")


func _on_movement_handler_started_sliding() -> void:
	play("slide")


func _on_movement_handler_stopped_sliding() -> void:
	play("idle")


func _on_gameover_area_3d_area_entered(area: Area3D) -> void:
	play("death")
	await animation_finished
	death_animation_finished.emit()
