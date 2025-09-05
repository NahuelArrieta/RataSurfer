extends Control

signal random_zone_in
signal random_zone_out

@onready var controlled_zone: Control = $MainBar/ControlledZone
@onready var random_movement_zone: Control = $MainBar/RandomMovementZone

func reset_balance_game() -> void:
	controlled_zone.reset()
	random_movement_zone.reset()

func start_balance_game() -> void:
	reset_balance_game()
	show()
	controlled_zone.start()
	random_movement_zone.start()

func finish_balance_game() -> void:
	hide()
	controlled_zone.disable()
	random_movement_zone.reset()

func _on_area_2d_area_entered(area: Area2D) -> void:
	random_zone_in.emit()

func _on_area_2d_area_exited(area: Area2D) -> void:
	random_zone_out.emit()


func _on_player_started_sliding() -> void:
	start_balance_game()


func _on_player_stopped_sliding() -> void:
	finish_balance_game()
