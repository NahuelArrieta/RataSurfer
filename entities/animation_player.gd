extends AnimationPlayer


func _on_movement_handler_player_jumped() -> void:
	play("jump")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump":
		play("idle")
