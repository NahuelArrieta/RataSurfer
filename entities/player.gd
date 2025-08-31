extends CharacterBody3D

signal player_touched_obstacle

func _on_gameover_area_3d_area_entered(area: Area3D) -> void:
	player_touched_obstacle.emit()
