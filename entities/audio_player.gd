extends Node

@onready var salto_audio_player: AudioStreamPlayer3D = $SaltoAudioPlayer
@onready var left_mvm_audio_player: AudioStreamPlayer3D = $LeftMvmAudioPlayer
@onready var right_mvm_audio_player: AudioStreamPlayer3D = $RightMvmAudioPlayer

func _on_movement_handler_player_jumped() -> void:
	salto_audio_player.play()


func _on_movement_handler_moved_left() -> void:
	left_mvm_audio_player.play()


func _on_movement_handler_moved_right() -> void:
	right_mvm_audio_player.play()
