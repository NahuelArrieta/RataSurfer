extends Control

signal random_zone_in
signal random_zone_out

func _on_area_2d_area_entered(area: Area2D) -> void:
	random_zone_in.emit()

func _on_area_2d_area_exited(area: Area2D) -> void:
	random_zone_out.emit()
