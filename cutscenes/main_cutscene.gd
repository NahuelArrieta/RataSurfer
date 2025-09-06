extends Control

const LEVEL_PATH := "res://level/level.tscn"

@onready var video: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:

	# Conexiones seguras
	if not video.finished.is_connected(_on_video_finished):
		video.finished.connect(_on_video_finished)
	
	# Arranca la cinemática
	video.play()

func _on_video_finished() -> void:
	# Evita que el video capture el input por encima del botón
	if video is Control:
		video.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	# Permitir saltar con Enter/Esc (opcional)
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if video.is_playing():
			video.stop()
			_on_video_finished()
			_iniciar_juego()

func _iniciar_juego() -> void:
	if not ResourceLoader.exists(LEVEL_PATH):
		push_error("No se encontró la escena destino en: %s" % LEVEL_PATH)
		return

	var err := get_tree().change_scene_to_file(LEVEL_PATH)
	if err != OK:
		push_error("Error al cambiar de escena (%s): %s" % [LEVEL_PATH, err])


func _on_video_stream_player_finished() -> void:
	_on_video_finished()
	_iniciar_juego()
