extends Control

const LEVEL_PATH := "res://level/level.tscn"

@onready var video: VideoStreamPlayer = $VideoStreamPlayer
@onready var start_button: Button = $StartButton

func _ready() -> void:
	# Estado inicial
	start_button.visible = false
	start_button.disabled = true

	# Conexiones seguras
	if not video.finished.is_connected(_on_video_finished):
		video.finished.connect(_on_video_finished)

	if not start_button.pressed.is_connected(_on_StartButton_pressed):
		start_button.pressed.connect(_on_StartButton_pressed)

	# Arranca la cinemática
	video.play()

func _on_video_finished() -> void:
	# Evita que el video capture el input por encima del botón
	if video is Control:
		video.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Muestra y prioriza el botón
	start_button.visible = true
	start_button.disabled = false
	start_button.grab_focus()
	start_button.text = "Comenzar"

func _on_StartButton_pressed() -> void:
	print("[Cutscene] StartButton PRESSED")
	_iniciar_juego()

func _input(event: InputEvent) -> void:
	# Permitir saltar con Enter/Esc (opcional)
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		if video.playing:
			video.stop()
			_on_video_finished()

func _iniciar_juego() -> void:
	if not ResourceLoader.exists(LEVEL_PATH):
		push_error("No se encontró la escena destino en: %s" % LEVEL_PATH)
		return

	var err := get_tree().change_scene_to_file(LEVEL_PATH)
	if err != OK:
		push_error("Error al cambiar de escena (%s): %s" % [LEVEL_PATH, err])
