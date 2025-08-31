extends Node

@onready var salto_audio_player: AudioStreamPlayer3D = $SaltoAudioPlayer

func _on_movement_handler_player_jumped() -> void:
	salto_audio_player.play()
